// ignore_for_file: avoid_print

import 'dart:async';

import 'package:octadesk_conversation/constants/socket_events.dart';
import 'package:octadesk_conversation/inbox_filters/inbox_filters.dart';
import 'package:octadesk_conversation/octadesk_conversation.dart';
import 'package:octadesk_core/octadesk_core.dart';
import 'package:octadesk_services/octadesk_services.dart';
import 'package:rxdart/rxdart.dart';
import 'package:collection/collection.dart';

class RoomsListController {
  ///
  /// Filtro atual
  ///
  late RoomFilterModel _inboxFilter;
  RoomFilterModel get inboxFilter => _inboxFilter;

  ///
  /// Stream de salas
  ///
  late final BehaviorSubject<List<RoomListModel>?> _roomsListStreamController;
  Stream<List<RoomListModel>?> get roomsStream => _roomsListStreamController.stream;

  ///
  /// Página atual
  ///
  int _currentPage = 1;
  bool _hasMorePages = false;
  bool _paginating = false;

  ///
  /// Validar o grupo do usuário atual
  ///
  bool _validateGroupRule(GroupDTO? roomGroup) {
    // Se não tiver grupo
    if (roomGroup == null) {
      return true;
    }

    // Se for administrador
    if ([1, 2].contains(OctadeskConversation.instance.agent!.roleType)) {
      return true;
    }

    // Se o agente não tiver grupo
    if (OctadeskConversation.instance.agentGroupId == null) {
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
    if (roomGroup.agents.firstWhereOrNull((e) => e.id == OctadeskConversation.instance.agent!.id) != null) {
      return true;
    }

    return false;
  }

  ///
  /// Inicializar
  ///
  void _initialize() {
    _roomsListStreamController = BehaviorSubject(
      onListen: _addRoomsUpdateListener,
      onCancel: () {
        print("▶️ PAROU DE ESCUTAR O LISTENER 'ROOMS_UPDATE'");
        OctadeskConversation.instance.socketReference!.off(SocketEvents.roomsUpdate);
      },
    );
  }

  Future<List<RoomListModel>> _getRooms({required int page, required int limit}) async {
    var body = {..._inboxFilter.rule};

    // Carregar dados iniciais
    body["page"] = page;
    body["limit"] = limit;

    var paginator = await ChatService.getRooms(body);
    var paginatorModel = RoomPaginationModel.fromDTO(paginator);
    _hasMorePages = paginatorModel.hasMorePages;
    return paginatorModel.rooms;
  }

  ///
  /// Adicionar listerer de quando as salas forem alteradas
  ///
  void _addRoomsUpdateListener() async {
    print("▶️ COMEÇOU A ESCUTAR O LISTENER ROOMS_UPDATE");

    // Adicionar evento ao socket
    OctadeskConversation.instance.socketReference!.on(SocketEvents.roomsUpdate, (data) {
      // Estado atual da paginação
      List<RoomListModel> currentRoomList = [..._roomsListStreamController.value!];

      // Salas alteradas
      var changedRooms = List.from(data).map((d) {
        var dto = RoomDTO.fromMap(d);
        return RoomListModel.fromDTO(dto);
      });

      // Varrer as salas
      changedRooms.forEach((changedRoom) {
        // Verificar se existe a sala
        var room = currentRoomList.firstWhereOrNull((room) => room.key == changedRoom.key);

        // Verificar se a sala foi fechada
        if (!changedRoom.isOpened) {
          currentRoomList.remove(room);
          return;
        }

        // Grupo da sala
        GroupDTO? roomGroup = changedRoom.group != null ? OctadeskConversation.instance.groups?.firstWhereOrNull((e) => e.id == changedRoom.group!.id) : null;

        var validRoomGroupRule = _validateGroupRule(roomGroup);

        // Se a conversa ja existir e for transferida para outro grupo
        if (room != null && !validRoomGroupRule) {
          currentRoomList.remove(room);
          return;
        }

        // Caso a sala tenha saído dos critérios, remover
        if (room != null && !inboxFilter.validator(changedRoom)) {
          currentRoomList.remove(room);
        }

        // Caso a sala não existe e esteja dentro do filtro atual, adicionar
        if (room == null && _inboxFilter.validator(changedRoom) && validRoomGroupRule) {
          currentRoomList.add(changedRoom);
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

      // Atualizar
      var newRoomList = currentRoomList
          .where((element) {
            return _inboxFilter.descriptor == RoomFilterEnum.bot ? element.status == RoomStatusEnum.started : element.status != RoomStatusEnum.started;
          })
          .sortedBy((element) => element.lastMessageTime)
          .reversed;

      // Caso esteja na primeira página pegar apenas os primeiros 20
      if (!_paginating) {
        newRoomList = newRoomList.take(20);
      }

      _roomsListStreamController.add(newRoomList.toList());
    });

    try {
      // Carregar dados iniciais
      var rooms = await _getRooms(page: 1, limit: 20);
      _roomsListStreamController.add(rooms);
    } catch (e) {
      _roomsListStreamController.addError(e);
      return;
    }
  }

  RoomsListController({required RoomFilterEnum inboxFilter}) {
    _inboxFilter = InboxFilters.getFilterByType(inboxFilter, page: 1, agentId: OctadeskConversation.instance.agent!.id);
    _initialize();
  }

  ///
  /// Atualizar salas
  ///
  Future<void> refreshRooms({bool clear = true}) async {
    try {
      if (clear) {
        _roomsListStreamController.add(null);
      }

      _currentPage = 1;
      _paginating = false;
      var rooms = await _getRooms(page: _currentPage, limit: 20);
      _roomsListStreamController.add(rooms);
    } catch (e) {
      _roomsListStreamController.addError(e);
    }
  }

  ///
  /// Mudar inbox
  ///
  void changeInbox(RoomFilterEnum inbox) async {
    // Atualizar valores
    _currentPage = 1;
    _paginating = false;
    _inboxFilter = InboxFilters.getFilterByType(inbox, page: 1, agentId: OctadeskConversation.instance.agent!.id);
    _inboxFilter.rule["limit"] = 20;

    _roomsListStreamController.add(null);
    try {
      await refreshRooms();
    } catch (e) {
      _roomsListStreamController.addError(e);
    }
  }

  ///
  /// Paginar
  ///
  Future<void> paginate() async {
    if (_hasMorePages) {
      _currentPage += 1;
      _paginating = false;

      try {
        List<RoomListModel> currentRooms = [..._roomsListStreamController.value!];
        List<RoomListModel> newRooms;

        // Caso seja a página 2, atualizar a primeira e carregar a segunda;
        if (_currentPage == 2) {
          newRooms = await _getRooms(page: 1, limit: 40);
          _roomsListStreamController.add(newRooms);
        } else {
          newRooms = await _getRooms(page: _currentPage, limit: 20);
          _roomsListStreamController.add([...currentRooms, ...newRooms]);
        }
      } catch (e) {
        _roomsListStreamController.addError(e);
      }
    }
  }

  void dispose() {
    _roomsListStreamController.close();
  }
}
