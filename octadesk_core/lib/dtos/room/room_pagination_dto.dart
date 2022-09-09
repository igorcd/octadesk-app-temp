import 'package:octadesk_core/dtos/room/room_dto.dart';

class RoomPaginationDTO {
  final int page;
  final int pages;
  final int total;
  final int limit;
  final List<RoomDTO> rooms;
  final int dbtime;
  final bool hasMorePages;

  RoomPaginationDTO({
    required this.dbtime,
    required this.hasMorePages,
    required this.limit,
    required this.page,
    required this.pages,
    required this.rooms,
    required this.total,
  });

  factory RoomPaginationDTO.fromMap(Map<String, dynamic> data) {
    var rooms = List.from(data["rooms"]).map((room) => RoomDTO.fromMap(room)).toList();

    return RoomPaginationDTO(
      dbtime: data["dbtime"] ?? 0,
      hasMorePages: data["hasMorePages"] ?? false,
      limit: data["limit"],
      page: data["page"],
      pages: data["pages"],
      rooms: rooms,
      total: data["total"],
    );
  }
}
