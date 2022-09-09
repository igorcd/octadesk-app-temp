enum RoomEventTypeEnum {
  created,
  agentChange,
  groupChange,
  // statusChange,
  unknown,
}

RoomEventTypeEnum roomEventTypeEnumParser(String value) {
  if (value == "created") {
    return RoomEventTypeEnum.created;
  }
  // if (value == "status") {
  //   return RoomEventTypeEnum.statusChange;
  // }
  if (value == "agent") {
    return RoomEventTypeEnum.agentChange;
  }
  if (value == "group") {
    return RoomEventTypeEnum.groupChange;
  }

  return RoomEventTypeEnum.unknown;
}
