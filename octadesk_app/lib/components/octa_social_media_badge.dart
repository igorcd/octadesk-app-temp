import 'package:flutter/material.dart';
import 'package:octadesk_app/resources/app_channel_badges.dart';
import 'package:octadesk_core/octadesk_core.dart';

class OctaSocialMediaBadge extends StatelessWidget {
  final ChatChannelEnum socialMedia;

  OctaSocialMediaBadge(this.socialMedia, {Key? key}) : super(key: key);

  final Map<ChatChannelEnum, String> images = {
    ChatChannelEnum.instagram: AppChannelBadges.instagramBadge,
    ChatChannelEnum.facebookMessenger: AppChannelBadges.menssegerBadge,
    ChatChannelEnum.web: AppChannelBadges.webBadge,
    ChatChannelEnum.whatsapp: AppChannelBadges.whatsappBadge,
    ChatChannelEnum.whatsappOficial: AppChannelBadges.whatsappOficialBadge,
    ChatChannelEnum.email: AppChannelBadges.emailBadge,
  };

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 20,
      height: 20,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        border: Border.all(
          color: Colors.white,
          width: 2,
        ),
        image: DecorationImage(image: AssetImage(images[socialMedia]!), fit: BoxFit.cover),
        color: Colors.white,
      ),
    );
  }
}
