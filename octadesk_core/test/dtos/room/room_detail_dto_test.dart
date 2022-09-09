import 'package:flutter_test/flutter_test.dart';
import 'package:octadesk_core/dtos/index.dart';
import 'package:octadesk_core/mock/dtos/room/room_detail_dto.mock.dart' as mock;

void main() {
  testWidgets('room detail dto ...', (tester) async {
    var parsedRoom = RoomDetailDTO.fromMap(mock.roomDetailDTOMock);
    expect(parsedRoom.runtimeType, RoomDetailDTO);
  });
}
