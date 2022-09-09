import 'package:octadesk_core/dtos/room/room_pagination_dto.dart';
import 'package:octadesk_core/models/room/room_list_model.dart';

class RoomPaginationModel {
  late int totalPages;
  late bool hasMorePages;
  late List<RoomListModel> rooms;

  RoomPaginationModel({required this.totalPages, required this.hasMorePages, required this.rooms});

  factory RoomPaginationModel.fromDTO(RoomPaginationDTO dto) {
    return RoomPaginationModel(
      totalPages: dto.total,
      rooms: dto.rooms.map((room) => RoomListModel.fromDTO(room)).toList(),
      hasMorePages: dto.hasMorePages,
    );
  }

  RoomPaginationModel clone() {
    return RoomPaginationModel(totalPages: totalPages, hasMorePages: hasMorePages, rooms: [...rooms]);
  }
}
