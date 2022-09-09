import 'package:octadesk_core/dtos/index.dart';

class ContactRoomPaginationDTO {
  final int page;
  final int pages;
  final int total;
  final int limit;
  final List<RoomDetailDTO> rooms;

  ContactRoomPaginationDTO({required this.page, required this.pages, required this.total, required this.limit, required this.rooms});

  factory ContactRoomPaginationDTO.fromMap(Map<String, dynamic> data) {
    return ContactRoomPaginationDTO(
      page: data["page"],
      pages: data["pages"],
      total: data["total"],
      limit: data["limit"],
      rooms: List.from(data["rooms"]).map((e) => RoomDetailDTO.fromMap(e)).toList(),
    );
  }
}
