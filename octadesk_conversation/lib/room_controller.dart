import 'dart:async';
import 'dart:io';
import 'package:octadesk_conversation/plugins/ntp_offset.dart';
import 'package:octadesk_core/dtos/message/attachment_post_dto.dart';
import 'package:octadesk_core/models/message/message_attachment.dart';
import 'package:octadesk_core/octadesk_core.dart';
import 'package:octadesk_services/octadesk_services.dart';
import 'package:rxdart/rxdart.dart';
import 'package:uuid/uuid.dart';
import 'package:collection/collection.dart';

class RoomController {
  // Propriedades
  late AgentDTO _agent;
  late BehaviorSubject<RoomModel?> _roomStreamController;
  Stream<RoomModel?> get roomStream => _roomStreamController.stream;

  /// Sala atual
  RoomModel? get room => _roomStreamController.value;

  // Se a sala está ativa
  bool get active => !_roomStreamController.isClosed;

  RoomController({required BehaviorSubject<RoomModel?> roomStreamController, required AgentDTO agent}) {
    _roomStreamController = roomStreamController;
    _agent = agent;
  }

  // ====== Métodos privados ======

  ///
  /// Enviar mensagem
  ///
  Future<void> _handleSendMessage({
    required String message,
    required List<MessageAttachment> attachments,
    required List<AgentDTO> mentions,
    required bool isInternal,
    MessageModel? quotedMessage,
    MacroContentDTO? template,
  }) async {
    var internal = isInternal || mentions.isNotEmpty;

    var date = ntpDateTime().toUtc();

    //Dados a serem enviados
    var dataToSend = MessagePostDTO(
      key: Uuid().v4(),
      time: date.toIso8601String(),
      quotedMessageKey: quotedMessage?.key,
      type: internal ? 'internal' : 'public',
      status: 'sending',
      chatKey: room!.key,
      comment: message,
      user: _agent,
      attachments: attachments.map((e) => AttachmentPostDTO(name: e.name, url: "", duration: e.duration, ptt: e.ptt)).toList(),
      customFields: {},
      mentions: [...mentions],
    );

    if (template != null) {
      dataToSend.customFields.addAll({
        'template': template.toMap(),
      });
    }

    // Nova instancia da sala
    var newRoom = room!.clone();

    // Criar placeholder
    var messagePlaceholder = MessageModel(
      quotedStory: null,
      buttons: template?.components.firstWhereOrNull((element) => element.type == MacroComponentTypeEnum.buttons)?.buttons.map((e) => e.label).toList() ?? [],
      quotedMessage: quotedMessage != null ? MessageModel.clone(quotedMessage) : null,
      key: dataToSend.key,
      user: AgentModel.fromAgentDTO(_agent),
      comment: template != null ? generateTemplateContent(template.components) : dataToSend.comment,
      time: date,
      type: internal ? MessageTypeEnum.internal : MessageTypeEnum.public,
      status: MessageStatusEnum.tryingToSend,
      attachments: attachments,
      catalog: null,
    );

    try {
      messagePlaceholder.quotedMessage = quotedMessage != null ? MessageModel.clone(quotedMessage) : null;
      messagePlaceholder.attachments = [...attachments];

      // Adicionar o placeholder

      newRoom.messages.insert(0, messagePlaceholder);
      _roomStreamController.add(newRoom);

      // Fazer upload dos arquivos
      if (attachments.isNotEmpty) {
        var futures = attachments.map((e) => ChatService.uploadFile(
              file: File(e.localFilePath!),
              channel: newRoom.channel,
            ));

        var files = await Future.wait(futures);

        for (var i = 0; i < files.length; i++) {
          var ref = dataToSend.attachments[i];
          var file = files[i];

          ref.name = file.name;
          ref.url = file.url;
          ref.thumbnailUrl = file.thumbnailUrl;
        }
      }

      // Enviar a mensagem
      await ChatService.sendMessage(dataToSend);
    } catch (e) {
      messagePlaceholder.status = MessageStatusEnum.error;
      _roomStreamController.add(newRoom);
    }
  }

  // ====== Métodos públicos =======

  /// Atualizar sala
  Future<void> refreshRoom() async {
    if (!_roomStreamController.isClosed) {
      var resp = await ChatService.getRoom(room!.key);
      var newRoom = RoomModel.fromDTO(resp);
      _roomStreamController.add(newRoom);
    }
  }

  ///
  /// Enviar mensagems
  ///
  Future<void> sendMessage({
    required String message,
    required List<MessageAttachment> attachments,
    required List<AgentDTO> mentions,
    required bool isInternal,
    MessageModel? quotedMessage,
    MacroContentDTO? template,
  }) async {
    //
    // Verificar se é um chat de Whatsapp, caso seja só é permitido um anexo por mensagem
    if (room!.channel == ChatChannelEnum.whatsapp && attachments.length > 1) {
      List<Future> futures = [];
      for (var i = 0; i < attachments.length; i++) {
        var attachment = attachments[i];
        var isLastAttachment = i == attachments.length - 1;

        var comment = isLastAttachment ? message : "";
        var quoted = isLastAttachment ? quotedMessage : null;

        futures.add(
          _handleSendMessage(
            attachments: [attachment],
            message: comment,
            quotedMessage: quoted,
            isInternal: isInternal,
            mentions: mentions,
            template: template,
          ),
        );
      }
      await Future.wait(futures);
      return;
    }

    // Caso contrário enviar mensagem normalmente
    await _handleSendMessage(
      message: message,
      attachments: attachments,
      quotedMessage: quotedMessage,
      isInternal: isInternal,
      mentions: mentions,
      template: template,
    );
  }

  ///
  /// Método de finalizar sala
  ///
  Future<void> close() async {
    if (room!.closingDetails == null) {
      var newRoom = room!.clone();

      try {
        newRoom.closingDetails = RoomClosingDetailsModel(closedBy: AgentModel.fromAgentDTO(_agent), closedDate: DateTime.now());
        _roomStreamController.add(newRoom);
        await ChatService.closeChat(newRoom.key, _agent);
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

    try {
      // Atualizar o agente
      newRoom.agent = AgentModel.fromAgentDTO(_agent);
      _roomStreamController.add(newRoom);

      // Realizar a requisição
      await ChatService.assignConversationToAgent(newRoom.key, _agent.id);

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
