// ignore_for_file: avoid_print

library octadesk_conversation;

import 'dart:async';

import 'package:octadesk_conversation/constants/socket_events.dart';
import 'package:octadesk_conversation/inbox_filters/inbox_filters.dart';
import 'package:octadesk_conversation/inbox_messages_counter_controller.dart';
import 'package:octadesk_conversation/plugins/ntp_offset.dart';
import 'package:octadesk_conversation/room_controller.dart';
import 'package:octadesk_core/dtos/agent/agent_connection_status_dto.dart';
import 'package:octadesk_core/octadesk_core.dart';
import 'package:octadesk_services/octadesk_services.dart';
import 'package:rxdart/rxdart.dart';
import 'package:socket_io_client/socket_io_client.dart';
import 'package:collection/collection.dart';
import 'package:dio/dio.dart';

class OctadeskConversation {
  Future<void>? _initializationFuture;

  // Referencia do socket
  Socket? _socket;

  // ID do agente atual
  String? _agentId;

  // Referência do agente atual
  AgentDTO? _agent;

  // ID do grupo do agente atual
  String? _agentGroupId;

  // Grupos de atendimento
  List<GroupDTO>? _groups;

  // Página atual
  int _currentPage = 1;

  // Carregando página atual
  bool _loadingNextPage = false;

  // Verificar se está inicializado
  bool get initialized => _socket != null && _agentId != null && _agent != null && _groups != null;

  // Filtro atual
  RoomFilterModel? _inboxFilter;
  RoomFilterModel? get inboxFilter => _inboxFilter;

  /// Stream de status da conexão
  BehaviorSubject<ConnectionStatusEnum?>? _connectionStatusStreamController;
  Stream<ConnectionStatusEnum?>? get connectionStatusStream => _connectionStatusStreamController?.stream;

  /// Stream de salas
  BehaviorSubject<RoomPaginationModel?>? _roomsStreamController;
  Stream<RoomPaginationModel?>? get roomsStream => _roomsStreamController?.stream;

  // Agentes
  List<AgentDTO> _agents = [];
  List<AgentDTO> get agents => [..._agents];

  // Números de telefone
  List<PhoneNumberModel> _phoneNumbers = [];
  List<PhoneNumberModel> get phoneNumbers => [..._phoneNumbers];

  // Integrators
  List<IntegratorModel> _integrators = [];
  List<IntegratorModel> get integrators => [..._integrators];

  // ========== MÉTODOS PRIVADOS ================

  /// Tratar reconexão
  void _handleReconnection() async {
    print(_socket);
    if (_socket != null) {
      await Future.delayed(Duration(seconds: 10));
      print("▶️ TENTANDO RECONECTAR");

      _socket!.connect();
    }
  }

  // Conectar ao socket;
  void _connectSocket() async {
    print("▶️ TENTANDO CONECTAR");

    // Caso conecte
    _socket!.on(SocketEvents.connected, (data) {
      // Identificar usuário
      _socket!.emit('identify', _agentId);
      _socket!.emit('session:activity', _agentId);
      print("▶️ CONECTADO");
    });

    // Caso não consiga conectar
    _socket!.on(SocketEvents.connectError, (data) {
      print("❌ FALHA AO CONECTAR");
      _handleReconnection();
    });

    // Adicionar evento de perda de conexão
    _socket!.on(SocketEvents.lostConnection, (data) {
      print("⚠️ CONEXÃO PERDIDA - $data");
      _handleReconnection();
    });

    // Conectar
    _socket!.connect();
  }

  /// Adicionar listener de mudança no status da conexão
  void _addConnectionStatusChangeListener() async {
    print("▶️ ADICIONOU O LISTENER DO EVENTO: ${SocketEvents.agentConnectionStatusChange}");

    var newStatus = ConnectionStatusEnum.values[_agent!.connectionStatus ?? 0];
    _connectionStatusStreamController!.add(newStatus);

    // Adicionar listener do status
    _socket!.on(SocketEvents.agentConnectionStatusChange, (data) {
      print("▶️ ATUALIZOU STATUS DO USUÁRIO");
      var resp = AgentConnectionStatusDTO.fromMap(data);
      if (resp.idAgent == _agentId) {
        var newStatus = ConnectionStatusEnum.values[resp.status];
        _connectionStatusStreamController!.add(newStatus);
      }
    });
  }

  /// Validar o grupo do usuário atual
  bool _validateGroupRule(GroupDTO? roomGroup) {
    // Se não tiver grupo
    if (roomGroup == null) {
      return true;
    }

    // Se for administrador
    if ([1, 2].contains(_agent!.roleType)) {
      return true;
    }

    // Se o agente não tiver grupo
    if (_agentGroupId == null) {
      return true;
    }

    // Se as configurações avançadas estiverem desligadas
    if (roomGroup.advancedSettings?.enabled == false) {
      return true;
    }

    // Bloqueio desligado
    if (roomGroup.advancedSettings?.canShare == false) {
      return true;
    }

    // Se o usuário estiver no grupo
    if (roomGroup.agents.firstWhereOrNull((e) => e.id == _agentId!) != null) {
      return true;
    }

    return false;
  }

  // Adicionar listerer de quando as salas forem alteradas
  void _addRoomsUpdateListener() async {
    print("▶️ COMEÇOU A ESCUTAR O LISTENER ROOMS_UPDATE");

    try {
      // Carregar dados iniciais
      var paginator = await ChatService.getRooms(_inboxFilter!.rule);
      _roomsStreamController!.add(RoomPaginationModel.fromDTO(paginator));
    } catch (e) {
      _roomsStreamController!.addError(e);
      return;
    }

    // Adicionar evento ao socket
    _socket!.on(SocketEvents.roomsUpdate, (data) {
      print("▶️ SALAS ATUALIZADAS");
      // Status atual da lista
      RoomPaginationModel currentPaginator = _roomsStreamController!.value!.clone();

      // Salas alteradas
      var changedRooms = List.from(data).map((d) {
        var dto = RoomDTO.fromMap(d);
        return RoomListModel.fromDTO(dto);
      });

      // Varrer as salas
      changedRooms.forEach((changedRoom) {
        // Verificar se existe a sala
        var room = currentPaginator.rooms.firstWhereOrNull((room) => room.key == changedRoom.key);

        // Verificar se a sala foi fechada
        if (!changedRoom.isOpened) {
          currentPaginator.rooms.remove(room);
          return;
        }

        // Grupo da sala
        GroupDTO? roomGroup = changedRoom.group != null ? _groups?.firstWhereOrNull((e) => e.id == changedRoom.group!.id) : null;

        var validRoomGroupRule = _validateGroupRule(roomGroup);

        // Se a conversa ja existir e for transferida para outro grupo
        if (room != null && !validRoomGroupRule) {
          currentPaginator.rooms.remove(room);
          return;
        }

        // Caso a sala tenha saído dos critérios, remover
        if (room != null && !inboxFilter!.validator(changedRoom)) {
          currentPaginator.rooms.remove(room);
        }

        // Caso a sala não existe e esteja dentro do filtro atual, adicionar
        if (room == null && _inboxFilter!.validator(changedRoom) && validRoomGroupRule) {
          currentPaginator.rooms.add(changedRoom);
          return;
        }

        // Caso a sala exista na listagem, editar
        if (room != null) {
          room.agent = changedRoom.agent;
          room.channel = changedRoom.channel;
          room.hasAttachments = changedRoom.hasAttachments;
          room.hasNewMessage = changedRoom.hasNewMessage;
          room.isBot = changedRoom.isBot;
          room.lastMessage = changedRoom.lastMessage;
          room.lastMessageTime = changedRoom.lastMessageTime;
          room.status = changedRoom.status;
          room.user = changedRoom.user;
        }
      });

      currentPaginator.rooms = currentPaginator.rooms
          .where((element) {
            return _inboxFilter!.descriptor == RoomFilterEnum.bot ? element.status == RoomStatusEnum.started : element.status != RoomStatusEnum.started;
          })
          .sortedBy((element) => element.lastMessageTime)
          .reversed
          .toList();

      _roomsStreamController!.add(currentPaginator);
    });
  }

  /// Initializar
  Future<void> _initialize({required String agentId, required String socketUrl, required String subDomain, required RoomFilterModel inboxFilter}) async {
    try {
      // Instanciar o socket
      var uri = Uri.parse(socketUrl);
      var url = "wss://${uri.authority}/$subDomain";
      var path = uri.path == '/' ? '/socket/socket.io' : '${uri.path}/socket/socket.io';

      _agentId = agentId;
      _inboxFilter = inboxFilter;

      _socket = io(
        url,
        OptionBuilder()
            .setTransports(['websocket'])
            .disableAutoConnect()
            .setQuery({"sd": subDomain})
            .setPath(path) // propriedades
            .build(),
      );

      // Carregar dados iniciais
      var resp = await Future.wait([
        ChatService.getAgent(agentId), // Agente atual
        ChatService.getGroups(), // Grupos
        ChatService.getAgents(), // Lista de agentes
        NumbersService.getWhatsAppNumbers(), // Números de Whatsapp
        IntegratorService.getIntegratorNumbers(), // Números de Whatsapp oficial,
        IntegratorService.getIntegrators(), // Integrators
        adjustNtpOffset(),
      ]);

      // Setar agente
      _agent = resp[0] as AgentDTO;

      // Setar grupos
      _groups = resp[1] as List<GroupDTO>;

      // Setar os agentes
      _agents = resp[2] as List<AgentDTO>;

      // Setar números de telefone disponíveis
      var whatsAppNumbers = (resp[3] as List<NumberDTO>).map((e) => PhoneNumberModel.fromWhatsAppNumber(e));
      var integratorNumbers = (resp[4] as List<IntegratorNumberDTO>).map((e) => PhoneNumberModel.fromIntegratorNumber(e));
      _phoneNumbers = [...whatsAppNumbers, ...integratorNumbers];

      // Setar os integrators
      _integrators = (resp[5] as List<IntegratorDTO>).map((e) => IntegratorModel.fromDTO(e)).toList();

      // Setar Id do grupo atual do agente
      _agentGroupId = _groups!.firstWhereOrNull((e) {
        return e.agents.firstWhereOrNull((element) => element.id == _agentId) != null;
      })?.id;

      _connectSocket();
    } catch (e) {
      return Future.error(e);
    }
  }

  /// Construtor
  OctadeskConversation._internal();
  static final OctadeskConversation instance = OctadeskConversation._internal();

  // ============= MÉTODOS PÚBLICOS ================
  Future<void> initialize({required String agentId, required String socketUrl, required String subDomain, required RoomFilterModel inboxFilter}) {
    if (_initializationFuture != null) {
      return _initializationFuture!;
    }

    _initializationFuture = _initialize(agentId: agentId, socketUrl: socketUrl, subDomain: subDomain, inboxFilter: inboxFilter);
    return _initializationFuture!;
  }

  /// Pegar stream de status da conexão
  Stream<ConnectionStatusEnum?> getAgentConnectionStatusStream() {
    // Verificar se está inicializado
    if (!initialized) {
      throw "Não inicializado";
    }

    // Verificar se a stream já foi inicializada
    if (_connectionStatusStreamController != null) {
      return _connectionStatusStreamController!.stream;
    }

    // Inicializar stream de status de conexão
    _connectionStatusStreamController = BehaviorSubject.seeded(
      ConnectionStatusEnum.offline,
      onListen: _addConnectionStatusChangeListener,
      onCancel: () {
        print("⚠️ PAROU DE ESCUTAR O LISTENER ${SocketEvents.agentConnectionStatusChange}");
        _socket!.off(SocketEvents.agentConnectionStatusChange);
      },
    );

    return _connectionStatusStreamController!.stream;
  }

  /// Pegar stream de salas
  Stream<RoomPaginationModel?> getRoomsListStream() {
    // Verificar se está inicializado
    if (!initialized) {
      throw "Não inicializado";
    }

    // Verificar se a stream já foi inicializada
    if (_roomsStreamController != null) {
      return _roomsStreamController!.stream;
    }

    _roomsStreamController = BehaviorSubject(
      onListen: _addRoomsUpdateListener,
      onCancel: () {
        print("▶️ PAROU DE ESCUTAR O LISTENER 'ROOMS_UPDATE'");
        _socket!.off(SocketEvents.roomsUpdate);
      },
    );

    return _roomsStreamController!.stream;
  }

  /// Pegar stream de detalhe da sala
  CancelToken? _loadRoomDetailCancelToken;
  RoomController getRoomDetailController(String roomKey) {
    // Verificar se está inicializado
    if (!initialized) {
      throw "Não inicializado";
    }

    // Instanciar a stream
    var roomStreamController = BehaviorSubject<RoomModel?>();

    // Adicionar evento do socket ao iniciar a primeira escuta
    roomStreamController.onListen = () async {
      print("▶️ COMEÇOU A ESCUTAR A STREAM $roomKey");
      _loadRoomDetailCancelToken?.cancel();
      _loadRoomDetailCancelToken = CancelToken();

      // Adicionar evento de nova mensagem
      _socket!.on(SocketEvents.roomUpdate, (room) {
        print("▶️ CHEGOU MENSAGEM NA SALA $roomKey");
        final data = RoomDetailDTO.fromMap(room);
        var roomModel = RoomModel.fromDTO(data);
        roomStreamController.add(roomModel);
      });

      // Acessar sala
      _socket!.emit(SocketEvents.joinRoom, roomKey);

      // Carregar dados iniciais
      try {
        var resp = await ChatService.getRoom(roomKey, cancelToken: _loadRoomDetailCancelToken);
        var roomModel = RoomModel.fromDTO(resp);
        if (!roomStreamController.isClosed) {
          roomStreamController.add(roomModel);
        }
      } catch (e) {
        // Caso seja apenas cancelar
        if (e is DioError && e.type == DioErrorType.cancel) {
          roomStreamController.close();
        } else {
          roomStreamController.addError(e);
        }
      }
    };

    // Quando para de escutar a stream
    roomStreamController.onCancel = () {
      print("▶️ SAIU DA SALA $roomKey");
      // Sair da sala
      _socket!.emit(SocketEvents.leaveRoom, roomKey);
      // Parar de escutar o evento
      _socket!.off(SocketEvents.roomUpdate);
    };

    return RoomController(roomStreamController: roomStreamController, agent: _agent!);
  }

  /// Pegar controller do counter de mensagens dos inbox
  InboxMessagesCounterController getInboxFiltersMessagesCountController() {
    // Verificar se está inicializado
    if (!initialized) {
      throw "Não inicializado";
    }

    var filters = [
      InboxFilters.open(page: 1, limit: 1000),
      InboxFilters.mine(page: 1, agentId: _agentId!, limit: 1000),
      InboxFilters.notAnswered(page: 1, agentId: _agentId!, limit: 1000),
      InboxFilters.mentions(page: 1, agentId: _agentId!, limit: 1000),
      InboxFilters.participations(page: 1, agentId: _agentId!, limit: 1000),
      InboxFilters.notAssigned(page: 1, limit: 1000),
      InboxFilters.bot(page: 1, limit: 1000),
    ];

    var inboxFiltersMessagesCountController = InboxMessagesCounterController(filters);
    return inboxFiltersMessagesCountController;
  }

  /// Atualizar salas
  Future<void> refreshRooms() async {
    if (_socket == null) {
      throw "Cliente não inicializado";
    }
    var rooms = await ChatService.getRooms(_inboxFilter!.rule);
    var _roomsPaginator = RoomPaginationModel.fromDTO(rooms);
    _currentPage = 1;
    _roomsStreamController!.add(_roomsPaginator);
  }

  /// Mudar inbox
  void changeInbox(RoomFilterModel inbox) async {
    if (_socket == null) {
      throw "Cliente não inicializado";
    }

    // Colocar o limite de requests para 20
    inbox.rule["limit"] = 20;

    // Atualizar valores
    _inboxFilter = inbox;

    _roomsStreamController!.add(null);
    try {
      await refreshRooms();
    } catch (e) {
      _roomsStreamController!.addError(e);
    }
  }

  /// Carregar próxima página
  void loadNextConversationsListPage() async {
    var hasMorePages = _roomsStreamController?.value?.hasMorePages ?? false;
    if (!_loadingNextPage && hasMorePages) {
      // Situação atual
      var currentRooms = _roomsStreamController!.value!.clone().rooms;

      _loadingNextPage = true;
      _currentPage += 1;

      // Atualizar página
      var filter = {...inboxFilter!.rule};
      filter['page'] = _currentPage;

      // Realizar a requisição
      var paginatorDTO = await ChatService.getRooms(filter);
      var paginator = RoomPaginationModel.fromDTO(paginatorDTO);

      // Adicionar as salas
      var newRooms = paginator.rooms.where((room) => currentRooms.firstWhereOrNull((element) => element.key == room.key) == null);

      paginator.rooms = [...currentRooms, ...newRooms];

      _roomsStreamController?.add(paginator);
      _loadingNextPage = false;
    }
  }

  /// Limpar
  void dispose() {
    print("CAIU NO DISPOSE");
    _socket?.clearListeners();
    _socket?.dispose();
    _socket = null;
    _initializationFuture = null;
    _agentId = null;
    _agent = null;
    _agentGroupId = null;
    _groups = null;
    _inboxFilter = null;
    _connectionStatusStreamController?.close();
    _roomsStreamController?.close();
    _connectionStatusStreamController = null;
    _roomsStreamController = null;
  }
}
