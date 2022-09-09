enum ConnectionStatusEnum {
  online,
  offline,
  busy,
}

ConnectionStatusEnum connectionStatusEnumParser(int value) {
  var channels = {
    0: ConnectionStatusEnum.online,
    1: ConnectionStatusEnum.offline,
    2: ConnectionStatusEnum.busy,
  };

  return channels[value] ?? ConnectionStatusEnum.online;
}
