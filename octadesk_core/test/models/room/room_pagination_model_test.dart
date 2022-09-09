import 'package:flutter_test/flutter_test.dart';
import 'package:octadesk_core/dtos/room/room_pagination_dto.dart';
import 'package:octadesk_core/mock/dtos/room/room_pagination_dto.mock.dart' as mock;
import 'package:octadesk_core/models/index.dart';

void main() {
  testWidgets('room pagination model ...', (tester) async {
    var parsedDTO = RoomPaginationDTO.fromMap(mock.roomPaginationDTOMock);
    var parsedModel = RoomPaginationModel.fromDTO(parsedDTO);
    expect(parsedModel.runtimeType, RoomPaginationModel);
  });
}
