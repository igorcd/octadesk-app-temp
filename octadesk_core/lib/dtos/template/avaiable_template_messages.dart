class AvaiableTemplateMessages {
  final AvaiableWhatsAppTemplateMessage whatsappApiTemplateMessage;

  AvaiableTemplateMessages({required this.whatsappApiTemplateMessage});

  factory AvaiableTemplateMessages.fromMap(Map<String, dynamic> map) {
    return AvaiableTemplateMessages(
      whatsappApiTemplateMessage: AvaiableWhatsAppTemplateMessage.fromMap(map["whatsapp_api_template_messages"]),
    );
  }
}

class AvaiableWhatsAppTemplateMessage {
  final int available;
  final int purchased;

  AvaiableWhatsAppTemplateMessage({required this.available, required this.purchased});

  factory AvaiableWhatsAppTemplateMessage.fromMap(Map<String, dynamic> map) {
    return AvaiableWhatsAppTemplateMessage(
      available: map["available"],
      purchased: map["purchased"],
    );
  }
}
