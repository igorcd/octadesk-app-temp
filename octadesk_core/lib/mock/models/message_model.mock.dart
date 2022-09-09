import 'package:octadesk_core/models/message/message_attachment.dart';
import 'package:octadesk_core/octadesk_core.dart';

MessageModel messageModel = MessageModel(
    quotedStory: null,
    catalog: null,
    quotedMessage: null,
    key: "4941f24c-ec5a-4206-ac93-e13b425f04b1",
    user: AgentModel(
        type: 2,
        email: "igor.dantas@octadesk.com",
        id: "04570580-7ee3-4626-9f53-6bc0e9c9f322",
        name: "Igor Dantas",
        thumbUrl: null,
        active: true,
        connectionStatus: ConnectionStatusEnum.online,
        phones: []),
    comment: "Mensagem mock",
    time: DateTime.now(),
    type: MessageTypeEnum.public,
    status: MessageStatusEnum.sending,
    attachments: [
      MessageAttachment(
        mimeType: null,
        thumbnail: null,
        duration: 0,
        name: "anexo-mock.jpg",
        url: "www.mock.com/anexo-mock.jpg",
        isUnsupported: false,
      )
    ],
    buttons: []);
