import 'package:collection/collection.dart';

enum MessageTypeEnum {
  public,
  internal,
}

MessageTypeEnum messageTypeEnumParser(String message) {
  return MessageTypeEnum.values.firstWhereOrNull((element) => element.name == message) ?? MessageTypeEnum.public;
}
