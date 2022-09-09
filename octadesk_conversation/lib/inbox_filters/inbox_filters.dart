import 'package:octadesk_core/octadesk_core.dart';

class InboxFilters {
  /// Retornar salas fechadas
  static RoomFilterModel closed({required int page, int limit = 20}) {
    return RoomFilterModel(
      title: "Conversas fechadas",
      descriptor: RoomFilterEnum.closed,
      validator: (room) => !room.isOpened,
      rule: {
        "status": [2, 5, 7],
        "page": page,
        "limit": limit
      },
    );
  }

  /// Retornar todas as salas
  static RoomFilterModel open({required int page, int limit = 20}) {
    return RoomFilterModel(
      title: "Todas as conversas",
      descriptor: RoomFilterEnum.open,
      validator: (room) {
        // Se for um bot, retornar apenas caso ja tenha sido iniciado
        if (room.isBot && room.isOpened) {
          return room.status != RoomStatusEnum.started;
        }

        return [RoomStatusEnum.waiting, RoomStatusEnum.talking, RoomStatusEnum.missed, RoomStatusEnum.started].contains(room.status);
      },
      rule: {
        "status": [0, 1, 3],
        "page": page,
        "limit": limit,
      },
    );
  }

  /// Minhas conversas
  static RoomFilterModel mine({required int page, required String agentId, int limit = 20}) {
    return RoomFilterModel(
      title: "Suas conversas",
      descriptor: RoomFilterEnum.mine,
      validator: (room) => room.agent?.id == agentId,
      rule: {
        "agent._id": agentId,
        "status": [0, 1, 3],
        "page": page,
        "limit": limit,
      },
    );
  }

  /// Salas não respondidas
  static RoomFilterModel notAnswered({required int page, required String agentId, int limit = 20}) {
    return RoomFilterModel(
      title: "Não respondidas",
      descriptor: RoomFilterEnum.notAnswered,
      validator: (room) => room.hasNewMessage,
      rule: {
        "agent._id": agentId,
        "status": 1,
        "lastMessageUserType": {
          "\$in": [2, 0]
        },
        "limit": limit
      },
    );
  }

  /// Menções
  static RoomFilterModel mentions({required int page, required String agentId, int limit = 20}) {
    return RoomFilterModel(
      title: "Menções",
      descriptor: RoomFilterEnum.mentions,
      validator: (room) => room.mentions != null && room.mentions!.contains(agentId),
      rule: {
        "status": [0, 1, 3],
        "page": page,
        "messages.mentions._id": agentId,
        "limit": limit,
      },
    );
  }

  /// Participações
  static RoomFilterModel participations({required int page, required String agentId, int limit = 20}) {
    return RoomFilterModel(
      title: "Participações",
      descriptor: RoomFilterEnum.participations,
      validator: (room) => room.agent?.id == agentId,
      rule: {
        "status": [0, 1, 3],
        "page": page,
        "users._id": agentId,
        "limit": limit,
      },
    );
  }

  /// Não atribuidas
  static RoomFilterModel notAssigned({required int page, int limit = 20}) {
    return RoomFilterModel(
      title: "Não atribuidas",
      descriptor: RoomFilterEnum.notAssigned,
      validator: (room) => room.agent == null,
      rule: {
        "status": [0, 1, 3],
        "page": 1,
        "agent._id": null,
        "limit": limit
      },
    );
  }

  /// Bots
  static RoomFilterModel bot({required int page, int limit = 20}) {
    return RoomFilterModel(
      title: "Conversas do bot",
      descriptor: RoomFilterEnum.bot,
      validator: (room) => room.isBot && room.status == RoomStatusEnum.started,
      rule: {
        "status": [4],
        "page": 1,
        "agent._id": null,
        "flux.botId": {"\$ne": null},
        "botInfo.hasStarted": true,
        "limit": limit,
      },
    );
  }

  static RoomFilterModel getFilterByType(RoomFilterEnum filterType, {required int page, int limit = 20, required String agentId}) {
    switch (filterType) {
      case RoomFilterEnum.bot:
        return bot(page: page, limit: limit);
      case RoomFilterEnum.closed:
        return closed(page: page, limit: limit);
      case RoomFilterEnum.mentions:
        return mentions(page: page, limit: limit, agentId: agentId);
      case RoomFilterEnum.mine:
        return mine(page: page, limit: limit, agentId: agentId);
      case RoomFilterEnum.notAnswered:
        return notAnswered(page: page, limit: limit, agentId: agentId);
      case RoomFilterEnum.notAssigned:
        return notAssigned(page: page, limit: limit);
      case RoomFilterEnum.open:
        return open(page: page, limit: limit);
      case RoomFilterEnum.participations:
        return participations(page: page, limit: limit, agentId: agentId);
      default:
        return open(page: page, limit: limit);
    }
  }
}
