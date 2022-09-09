import 'dart:io';
import 'package:octadesk_core/dtos/upload/upload_response_dto.dart';
import 'package:octadesk_services/utils/get_media_type.dart';
import 'package:path/path.dart' as path;
import 'package:dio/dio.dart';
import 'package:octadesk_core/dtos/contact/contact_room_pagination_dto.dart';
import 'package:octadesk_core/octadesk_core.dart';
import 'package:octadesk_services/http_clients/octa_client.dart';

class ChatService {
  /// Pegar o tamanho das salas
  static Future<List<int>> getRoomsCount(List<Map<String, dynamic>> filters) async {
    var resp = await OctaClient.chat.post('/rooms/count', data: filters);
    return List.from(resp.data);
  }

  /// Listar salas
  static Future<RoomPaginationDTO> getRooms(Map<String, dynamic> filter) async {
    var resp = await OctaClient.chat.post('/rooms/list', data: filter);
    return RoomPaginationDTO.fromMap(resp.data);
  }

  /// Pegar os detalhes de uma sala
  static Future<RoomDetailDTO> getRoom(String key, {CancelToken? cancelToken}) async {
    var resp = await OctaClient.chat.get('/rooms/$key/open', cancelToken: cancelToken);
    return RoomDetailDTO.fromMap(resp.data);
  }

  /// Carregar agente
  static Future<AgentDTO> getAgent(String id) async {
    var resp = await OctaClient.chat.get('/agents/$id');
    return AgentDTO.fromMap(resp.data);
  }

  /// Carregar agentes
  static Future<List<AgentDTO>> getAgents() async {
    var resp = await OctaClient.chat.get('/agents');
    return List.from(resp.data).map((e) => AgentDTO.fromMap(e)).toList();
  }

  /// Enviar mensagem
  static Future<MessageDTO> sendMessage(MessagePostDTO message) async {
    var data = message.toMap();
    var resp = await OctaClient.chat.post('/rooms/${message.chatKey}/messages', data: data);
    return MessageDTO.fromMap(resp.data);
  }

  /// Fechar chat
  static Future<void> closeChat(String roomId, AgentDTO agent) async {
    await OctaClient.chat.put('/rooms/$roomId/close', data: agent.toMap());
  }

  /// Visualizar histório de conversas de contato
  static Future<ContactRoomPaginationDTO> getContactConversations({required String contactId, required int page, CancelToken? cancelToken}) async {
    var resp = await OctaClient.chat.get('/rooms/user/$contactId', queryParameters: {"page": page}, cancelToken: cancelToken);
    return ContactRoomPaginationDTO.fromMap(resp.data);
  }

  /// Realizar o upload de arquivo
  static Future<UploadResponseDTO> uploadFile({required File file, required ChatChannelEnum channel}) async {
    //
    // Nome do arquivo
    var fileName = path.basename(file.path);

    var multipartFile = await MultipartFile.fromFile(file.path, filename: fileName, contentType: getMediaType(file.path));
    var formData = FormData.fromMap({"file": multipartFile});

    Map<String, dynamic> params = {
      "channel": channel.name,
    };

    // Verificar se é um vídeo

    var sections = fileName.split('.');
    var extension = sections.length > 1 ? sections[1].toLowerCase() : "";

    bool isVideo = ["mp4"].contains(extension);
    bool isImage = ["jpg", "png", "jpeg"].contains(extension);

    if (isVideo || isImage) {
      params.addAll({
        "createthumbnail": isVideo,
      });
    }

    bool isAudio = ["aac"].contains(extension);
    if (isAudio) {
      params.addAll({
        'saveas': 'audio/ogg; codecs=opus',
        'extension': 'opus',
        'audioBitrate': '48k',
        'audioChannels': 1,
      });
    }

    var resp = await OctaClient.chat.post(
      '/upload',
      data: formData,
      queryParameters: params,
    );

    return UploadResponseDTO.fromMap(resp.data);
  }

  /// Mudar status da conexão do usuário
  static Future changeConnectionStatus(String agentId, ConnectionStatusEnum status) async {
    await OctaClient.chat.put('/agents/$agentId/status', data: {'status': status.index});
  }

  /// Atribuir conversa
  static Future assignConversationToAgent(String roomId, String agentId) async {
    await OctaClient.chat.put('/rooms/$roomId/agent/$agentId');
  }

  /// Atribuir conversa a um grupo
  static Future assignConversationToGroup(String roomId, String groupId) async {
    await OctaClient.chat.put('/rooms/$roomId/group/$groupId');
  }

  /// Ler mensagens
  static Future readMessages(String roomId) async {
    await OctaClient.chat.put('/rooms/$roomId/messages/read');
  }

  /// Agente começou a digitar
  static Future handleTyping({required bool typing, required String roomId, required String agentId, required String agentEmail, required String agentName}) async {
    await OctaClient.chat.post('/rooms/$roomId/typing/${typing ? 'start' : 'stop'}', data: {
      "id": agentId,
      "name": agentName,
      "email": agentEmail,
    });
  }

  /// Carregar macros
  static Future<List<MacroDTO>> getAvaiableMacros(String roomId) async {
    var resp = await OctaClient.chat.post('/quick-reply/filter', data: {"roomKey": roomId});
    return List.from(resp.data).map((e) => MacroDTO.fromMap(e)).toList();
  }

  /// Carregar tags
  static Future<List<TagDTO>> getTags({required String query}) async {
    var resp = await OctaClient.chat.get('/public-tags/autocomplete', queryParameters: {"q": query});
    return List.from(resp.data).map((e) => TagDTO.fromMap(e)).toList();
  }

  /// Deletar tags
  static Future<List<TagPostDTO>> deleteTags({required List<String> tags, required String roomId}) async {
    var resp = await OctaClient.chat.delete('/rooms/$roomId/public-tags', data: tags);
    return List.from(resp.data).map((e) => TagPostDTO.fromMap(e)).toList();
  }

  /// Adicionar tags
  static Future<List<TagPostDTO>> addTags({required List<TagPostDTO> tags, required roomId}) async {
    var resp = await OctaClient.chat.post('/rooms/$roomId/public-tags', data: tags.map((e) => e.toMap()).toList());
    return List.from(resp.data).map((e) => TagPostDTO.fromMap(e)).toList();
  }

  /// Carregar grupos
  static Future<List<GroupDTO>> getGroups() async {
    var resp = await OctaClient.chat.get('/groups');
    return List.from(resp.data).map((e) => GroupDTO.fromMap(e)).toList();
  }

  /// Iniciar nova conversa
  static Future<RoomDetailDTO> startNewConversation({
    required String attendancePhone,
    required String clientPhone,
    required ContactPostDTO user,
    required String integrator,
  }) async {
    var dataToSend = {
      "channel": "whatsapp",
      "user": {
        "email": user.email,
        "name": user.name,
        "phoneContacts": user.phoneContacts.map((e) => e.toMap()).toList(),
        "organization": user.organization,
      },
      "domainFrom": attendancePhone,
      "tags": ["proactive"],
      "customFields": [
        {
          "integrator": {
            "integrator": integrator,
            "from": {"number": clientPhone},
            "to": {"number": attendancePhone}
          }
        }
      ],
      "messages": [],
      "organization": user.organization,
      "clientTimeZone": 180,
    };

    // Se o usuário tiver um ID, adicionar a requisição
    if (user.id != null) {
      dataToSend.update("user", (value) {
        (value as Map)["id"] = user.id;
        return value;
      });
    }

    // Se utilizar um integrator é necessário adicionar o horário da última mensagem
    if (integrator != 'octadesk') {
      // Verificar a última sala
      var resp = await OctaClient.chat.post('/rooms/filter', data: {
        "createdBy._id": user.id,
        "channel": "whatsapp",
        "sort": {
          "property": "created",
          "direction": "desc",
        },
        "limit": 1
      });
      var lastRooms = RoomPaginationDTO.fromMap(resp.data);

      // Caso tenha conversas
      if (lastRooms.rooms.isNotEmpty) {
        var room = lastRooms.rooms[0];

        // Caso tenha uma data da última mensagem
        if (room.clientLastMessageDate != null) {
          dataToSend.addAll({
            "clientLastMessageDate": room.clientLastMessageDate!,
          });
        }
      }
    }

    try {
      var resp = await OctaClient.chat.post('/rooms/opened/user/$clientPhone/$attendancePhone', data: dataToSend);
      return RoomDetailDTO.fromMap(resp.data);
    } on DioError catch (e) {
      if (e.response?.statusCode == 409) {
        return RoomDetailDTO.fromMap(e.response!.data);
      }
      rethrow;
    }
  }

  /// Templates disponívels
  static Future<AvaiableTemplateMessages> getAvaiableTemplateMessages() async {
    var resp = await OctaClient.chat.get('/core/plans/availability', queryParameters: {"filter": "whatsappApiTemplateMessagePlan"});
    return AvaiableTemplateMessages.fromMap(resp.data);
  }
}
