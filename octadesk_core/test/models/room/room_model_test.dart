import 'package:flutter_test/flutter_test.dart';
import 'package:octadesk_core/dtos/room/room_detail_dto.dart';
import 'package:octadesk_core/mock/dtos/room/room_detail_dto.mock.dart' as mock;
import 'package:octadesk_core/models/index.dart';

void main() {
  testWidgets('room model ...', (tester) async {
    var parsedDTO = RoomDetailDTO.fromMap(mock.roomDetailDTOMock);
    var parsedModel = RoomModel.fromDTO(parsedDTO);
    expect(parsedModel.runtimeType, RoomModel);
  });
}
