import 'package:flutter_test/flutter_test.dart';
import 'package:octadesk_core/dtos/index.dart';
import 'package:octadesk_core/mock/dtos/message/messate_dto.mock.dart' as mock;

void main() {
  testWidgets('Mapeamento do Mesage DTO', (tester) async {
    // Verifican parse de um mapa
    var messageDTO = MessageDTO.fromMap(mock.messageMock);
    expect(messageDTO.runtimeType, MessageDTO);
  });
}
