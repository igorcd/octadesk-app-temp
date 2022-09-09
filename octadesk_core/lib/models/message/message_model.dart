import 'package:octadesk_core/models/message/message_attachment.dart';
import 'package:collection/collection.dart';
import 'package:octadesk_core/models/message/message_catalog_model.dart';
import 'package:octadesk_core/models/message/message_story.dart';
import 'package:octadesk_core/models/message/message_template_model.dart';
import 'package:octadesk_core/octadesk_core.dart';

String generateTemplateContent(List<MacroComponentDTO> templateComponents) {
  List<String> sections = [];

  // Pegar Mensagem do Header
  var header = templateComponents.firstWhereOrNull((element) => element.type == MacroComponentTypeEnum.header);
  var headerTextsVariables = header?.variables.where((element) => element.type == MacroVariableTypeEnum.text).toList();
  if (headerTextsVariables != null && headerTextsVariables.isNotEmpty) {
    var headerText = headerTextsVariables.isEmpty ? "" : mapMessagesWithVariables(header!.message, headerTextsVariables);
    sections.add("<header>$headerText</header>");
  }

  // Texto do body
  var body = templateComponents.firstWhere((element) => element.type == MacroComponentTypeEnum.body);
  var bodyMessage = mapMessagesWithVariables(body.message, body.variables);
  sections.add(bodyMessage);

  var footer = templateComponents.firstWhereOrNull((element) => element.type == MacroComponentTypeEnum.footer);
  if (footer != null) {
    sections.add("<footer>${footer.message}</footer>");
  }

  return sections.join('\n');
}

class MessageModel {
  final String key;
  final AgentModel user;
  final String comment;
  final DateTime time;
  final MessageStory? quotedStory;
  final MessageTypeEnum type;

  List<MessageAttachment> attachments;
  List<String> buttons;
  MessageModel? quotedMessage;
  MessageStatusEnum status;
  MessageCatalogModel? catalog;

  bool get fromClient => [0, 2].contains(user.type);

  MessageModel({
    required this.quotedStory,
    required this.buttons,
    required this.quotedMessage,
    required this.key,
    required this.user,
    required this.comment,
    required this.time,
    required this.type,
    required this.status,
    required this.attachments,
    required this.catalog,
  });

  factory MessageModel.fromDTO(MessageDTO message) {
    // Verificar se existe botões de bot
    var hasbuttons = message.extendedData?["bot"]?["buttons"] != null;
    List<String> messageButtons = hasbuttons ? List.from(message.extendedData?["bot"]["buttons"]).map((el) => el["label"] as String).toList() : [];

    // Verificar se existe anexos
    List<MessageAttachment> messageAttachments = message.attachments.where((e) => !e.isStory).map((e) => MessageAttachment.fromDTO(e)).toList();

    // Verificar se exite mensagem de template
    var hasTemplate = message.customFields is Map && message.customFields["template"] is Map && message.customFields["template"]["data"] is List;
    List<MacroComponentDTO>? templateComponents;

    if (hasTemplate) {
      // Componentes
      templateComponents = List.from(message.customFields["template"]["data"]).map((e) => MacroComponentDTO.fromMap(e)).toList();

      // Attachments
      var templateAttachments = templateComponents
              .firstWhereOrNull((element) => element.type == MacroComponentTypeEnum.header)
              ?.variables
              .where((element) => element.type != MacroVariableTypeEnum.text)
              .map((e) => MessageAttachment(mimeType: null, thumbnail: null, name: e.key, url: e.value, isUnsupported: false))
              .toList() ??
          [];

      messageAttachments.addAll(templateAttachments);

      // Botões
      var templateButtons = templateComponents.firstWhereOrNull((element) => element.type == MacroComponentTypeEnum.buttons)?.buttons.map((e) => e.label).toList() ?? [];
      messageButtons.addAll(templateButtons);
    }

    // Verificar se exite story
    var quotedCustomFields = message.quotedMessage?.customFields;
    var story = quotedCustomFields is Map && quotedCustomFields["story"] != null
        ? quotedCustomFields["story"] //
        : null;

    return MessageModel(
      key: message.key,
      user: AgentModel.fromAgentDTO(message.user),
      comment: templateComponents != null ? generateTemplateContent(templateComponents) : message.comment,
      quotedStory: story != null ? MessageStory.fromMap(story) : null,
      time: DateTime.parse(message.time).toLocal(),
      type: messageTypeEnumParser(message.type),
      status: MessageStatusEnum.values.firstWhereOrNull((e) => e.name == message.status) ?? MessageStatusEnum.error,
      attachments: messageAttachments,
      quotedMessage: message.quotedMessage != null && story == null ? MessageModel.fromDTO(message.quotedMessage!) : null,
      catalog: null,
      buttons: messageButtons,
    );
  }

  factory MessageModel.clone(MessageModel model) {
    return MessageModel(
      quotedStory: model.quotedStory,
      quotedMessage: model.quotedMessage != null ? MessageModel.clone(model.quotedMessage!) : null,
      key: model.key,
      user: model.user.clone(),
      comment: model.comment,
      time: model.time,
      type: model.type,
      status: model.status,
      attachments: [...model.attachments],
      catalog: model.catalog,
      buttons: [...model.buttons],
    );
  }
}
