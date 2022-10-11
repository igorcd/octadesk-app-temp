// ignore_for_file: avoid_print
import 'dart:async';
import 'package:octadesk_conversation/constants/socket_events.dart';
import 'package:octadesk_conversation/octadesk_conversation.dart';
import 'package:octadesk_core/octadesk_core.dart';
import 'package:octadesk_services/octadesk_services.dart';
import 'package:rxdart/rxdart.dart';
import 'package:dio/dio.dart';

class RoomController {
  final String roomKey;
  final CancelToken cancelToken;

  /// Stream da Sala
  late BehaviorSubject<RoomModel?> _roomStreamController = BehaviorSubject();
  Stream<RoomModel?> get roomStream => _roomStreamController.stream;

  /// Sala atual
  RoomModel? get room => _roomStreamController.value;

  // ====== Métodos privados ======

  ///
  /// Verificar se pode mandar apenas mensagens template (WhatsApp Oficial)
  ///
  bool _checkIfCanSendOnlyTemplateMessages(RoomModel room) {
    // Caso a sala não possua integrator
    if (room.integrator == null || room.integrator?.integratorName == 'octadesk') {
      return false;
    }

    // Caso o cliente não tenha enviado mensagens, pode enviar apenas template
    if (room.clientLastMessageDate == null) {
      return true;
    }

    var integrator = OctadeskConversation.instance.integrators.firstWhere((element) => element.name == room.integrator!.integratorName);
    var intervalFromLastMessage = DateTime.now().toUtc().difference(room.clientLastMessageDate!).inHours;

    return intervalFromLastMessage > integrator.hoursToAnswer - 1;
  }

  ///
  /// Reconectar
  ///
  Future<void> _reconnect(dynamic _) async {
    print("CHAMOU O RECONECT DENTRO DO DETALHE DA SALA");
    if (!_roomStreamController.isClosed) {
      ChatService.readMessages(roomKey);
      OctadeskConversation.instance.socketReference!.emit(SocketEvents.joinRoom, roomKey);
      refreshRoom();
    }
  }

  ///
  /// Inicializar
  ///
  void _initialize() {
    var socket = OctadeskConversation.instance.socketReference!;

    // Instanciar a stream
    _roomStreamController = BehaviorSubject<RoomModel?>();

    // Quando para de escutar a stream
    _roomStreamController.onCancel = () {
      print("▶️ SAIU DA SALA $roomKey");
      // Sair da sala
      socket.emit(SocketEvents.leaveRoom, roomKey);

      // Parar de escutar o evento
      socket.off(SocketEvents.roomUpdate);
      socket.off(SocketEvents.reconnect, _reconnect);
    };

    // Adicionar evento do socket ao iniciar a primeira escuta
    _roomStreamController.onListen = () async {
      print("▶️ COMEÇOU A ESCUTAR A STREAM $roomKey");

      // Adicionar evento de nova mensagem
      socket.on(SocketEvents.roomUpdate, (room) {
        print("▶️ CHEGOU MENSAGEM NA SALA $roomKey");
        final data = RoomDetailDTO.fromMap(room);
        var roomModel = RoomModel.fromDTO(data);

        // Verificar se pode enviar apenas template messages
        roomModel.canSendOnlyTemplateMessages = _checkIfCanSendOnlyTemplateMessages(roomModel);
        _roomStreamController.add(roomModel);
      });

      // Adicionar o listener para reconexão
      socket.on(SocketEvents.reconnect, _reconnect);

      // Acessar sala
      socket.emit(SocketEvents.joinRoom, roomKey);

      // Carregar dados iniciais
      try {
        var resp = await ChatService.getRoom(roomKey, cancelToken: cancelToken);
        var roomModel = RoomModel.fromDTO(resp);

        roomModel.canSendOnlyTemplateMessages = _checkIfCanSendOnlyTemplateMessages(roomModel);

        if (!_roomStreamController.isClosed) {
          _roomStreamController.add(roomModel);
        }
      } catch (e) {
        // Caso seja apenas cancelar
        if (e is DioError && e.type == DioErrorType.cancel) {
          _roomStreamController.close();
        } else {
          _roomStreamController.addError(e);
        }
      }
    };
  }

  ///
  /// Construtor
  ///
  RoomController({required this.roomKey, required this.cancelToken}) {
    _initialize();
  }

  // ====== Métodos públicos =======

  /// Atualizar sala
  Future<void> refreshRoom() async {
    print("CAIU NO ROOM_CONTROLLER REFRESH");
    if (!_roomStreamController.isClosed) {
      var resp = await ChatService.getRoom(room!.key);
      var newRoom = RoomModel.fromDTO(resp);
      if (!_roomStreamController.isClosed) {
        _roomStreamController.add(newRoom);
      }
    }
  }

  ///
  /// Método de finalizar sala
  ///
  Future<void> close() async {
    if (room!.closingDetails == null) {
      var newRoom = room!.clone();
      var agent = OctadeskConversation.instance.agent!;

      try {
        newRoom.closingDetails = RoomClosingDetailsModel(closedBy: AgentModel.fromAgentDTO(agent), closedDate: DateTime.now());
        _roomStreamController.add(newRoom);
        await ChatService.closeChat(newRoom.key, agent);
      } catch (e) {
        newRoom.closingDetails = null;
        _roomStreamController.add(newRoom);
      }
    }
  }

  ///
  /// Assumir conversa
  ///
  Future takeOverChat() async {
    // Agente atual
    var newRoom = room!.clone();
    var currentAgent = room!.agent?.clone();
    var agent = OctadeskConversation.instance.agent!;

    try {
      // Atualizar o agente
      newRoom.agent = AgentModel.fromAgentDTO(agent);
      _roomStreamController.add(newRoom);

      // Realizar a requisição
      await ChatService.assignConversationToAgent(newRoom.key, agent.id);

      // Marcar mensagens como lidas
      ChatService.readMessages(newRoom.key);
    } catch (e) {
      // Em  caso de erro, voltar para o agente anterior
      newRoom.agent = currentAgent;
      _roomStreamController.add(newRoom);
      rethrow;
    }
  }

  ///
  /// Atualizar tags
  ///
  void updateTags(List<TagModel> tags) {
    var newRoom = room!.clone();
    newRoom.tags = [...tags];
    _roomStreamController.add(newRoom);
  }

  ///
  /// Método de dispose
  ///
  Future<void> dispose() async {
    _roomStreamController.add(null);
    await _roomStreamController.close();
  }
}

class SendMessageParams {
  final String message;
  final List<String> attachments;
  final List<AgentDTO> mentions;
  final bool isInternal;
  final MessageModel? quotedMessage;
  final MacroContentDTO? template;

  SendMessageParams({
    required this.message,
    required this.attachments,
    required this.mentions,
    required this.isInternal,
    this.quotedMessage,
    this.template,
  });
}
