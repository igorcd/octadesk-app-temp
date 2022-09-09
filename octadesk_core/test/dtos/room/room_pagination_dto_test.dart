import 'package:flutter_test/flutter_test.dart';
import 'package:octadesk_core/dtos/index.dart';
import 'package:octadesk_core/mock/dtos/room/room_pagination_dto_prod.mock.dart' as mock;

void main() {
  testWidgets('room dto ...', (tester) async {
    var parsedRoom = RoomPaginationDTO.fromMap(mock.roomPaginationDTOProd);
    expect(parsedRoom.runtimeType, RoomPaginationDTO);
  });
}
