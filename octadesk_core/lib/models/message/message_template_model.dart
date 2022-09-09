import 'package:octadesk_core/dtos/index.dart';
import 'package:collection/collection.dart';
import 'package:octadesk_core/models/message/message_attachment.dart';

/// Mapear mensagens macro, atribuindo o valor das variáveis
String mapMessagesWithVariables(String message, List<MacroVariableDTO> variables) {
  var regex = RegExp("<span(.*?)</span>");

  return message.replaceAllMapped(regex, (match) {
    var variableName = match[0]!.split('"')[1];
    var variableValue = variables.firstWhereOrNull((element) => element.key == variableName)?.value ?? "";
    return variableValue;
  });
}

class MessageTemplateModel {
  List<MessageAttachment> attachments;
  String? headerMessage;
  String bodyMessage;
  String? footerMessage;

  MessageTemplateModel({required this.attachments, this.headerMessage, required this.bodyMessage, this.footerMessage});

  factory MessageTemplateModel.fromMap(Map<String, dynamic> map) {
    var macro = MacroDTO.fromMap(map);

    // Pegar Mensagem do body
    var bodyMessage = mapMessagesWithVariables(macro.body.message, macro.body.variables);

    // Instanciar o template
    var template = MessageTemplateModel(bodyMessage: bodyMessage, attachments: []);

    // Adicionar informações do header
    if (macro.header != null) {
      // Adicionar os attachments do template
      var attachments = macro.header?.variables.where((element) => element.type != MacroVariableTypeEnum.text).toList();
      if (attachments != null) {
        for (var attachment in attachments) {
          template.attachments.add(MessageAttachment(mimeType: null, thumbnail: null, name: "Template attachment", url: attachment.value, isUnsupported: false));
        }
      }

      var headerTexts = macro.header?.variables.where((element) => element.type == MacroVariableTypeEnum.text).toList();
      // Adicionar mensagens do header
      if (headerTexts != null) {
        template.headerMessage = mapMessagesWithVariables(macro.header!.message, headerTexts);
      }
    }

    // Adicionar mensagem do footer
    if (macro.footer != null) {
      template.footerMessage = macro.footer!.message;
    }

    return template;
  }
}
