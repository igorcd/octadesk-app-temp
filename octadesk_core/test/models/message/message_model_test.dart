import 'package:flutter_test/flutter_test.dart';
import 'package:octadesk_core/dtos/message/message_dto.dart';
import 'package:octadesk_core/mock/dtos/message/messate_dto.mock.dart' as mock;
import 'package:octadesk_core/models/index.dart';

void main() {
  testWidgets('Teste de mapeamento de DTO para message Model', (tester) async {
    var messageDTO = MessageDTO.fromMap(mock.messageMock);
    var model = MessageModel.fromDTO(messageDTO);
    expect(model.runtimeType, MessageModel);
  });
}
