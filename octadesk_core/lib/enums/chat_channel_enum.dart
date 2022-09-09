enum ChatChannelEnum {
  whatsapp,
  whatsappOficial,
  web,
  facebookMessenger,
  instagram,
  email,
}

ChatChannelEnum chatChannelEnumParser(String value) {
  var channels = {
    "web": ChatChannelEnum.web,
    "whatsapp": ChatChannelEnum.whatsapp,
    "facebook-messenger": ChatChannelEnum.facebookMessenger,
    "instagram": ChatChannelEnum.instagram,
    "email": ChatChannelEnum.email,
  };

  return channels[value] ?? ChatChannelEnum.web;
}
