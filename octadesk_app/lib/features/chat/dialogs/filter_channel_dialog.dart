import 'package:flutter/material.dart';
import 'package:octadesk_app/components/index.dart';
import 'package:octadesk_app/components/octa_radio_list_tile.dart';
import 'package:octadesk_app/resources/app_channel_badges.dart';
import 'package:octadesk_app/resources/index.dart';
import 'package:octadesk_core/enums/chat_channel_enum.dart';

class FilterChannelDialog extends StatefulWidget {
  final ChatChannelEnum? initialChannel;

  const FilterChannelDialog({required this.initialChannel, Key? key}) : super(key: key);

  @override
  State<FilterChannelDialog> createState() => _FilterChannelDialogState();
}

class _FilterChannelDialogState extends State<FilterChannelDialog> {
  ChatChannelEnum? _selectedChannelTemp;

  void _setChannelTemp(ChatChannelEnum? channel) {
    setState(() {
      _selectedChannelTemp = channel;
    });
  }

  @override
  void initState() {
    super.initState();
    _setChannelTemp(widget.initialChannel);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Column(
            children: [
              // Web
              OctaRadioListTile(
                groupValue: _selectedChannelTemp,
                value: ChatChannelEnum.web,
                onSelect: _setChannelTemp,
                child: Row(children: [
                  Image.asset(AppChannelBadges.webBadge, width: AppSizes.s06),
                  const SizedBox(width: AppSizes.s02),
                  OctaText.bodyLarge("Chat Web"),
                ]),
              ),
              const Divider(height: 1, thickness: 1),

              // WhatsApp
              OctaRadioListTile(
                groupValue: _selectedChannelTemp,
                value: ChatChannelEnum.whatsapp,
                onSelect: _setChannelTemp,
                child: Row(children: [
                  Image.asset(AppChannelBadges.whatsappBadge, width: AppSizes.s06),
                  const SizedBox(width: AppSizes.s02),
                  OctaText.bodyLarge("WhatsApp"),
                ]),
              ),
              const Divider(height: 1, thickness: 1),

              // Facebook
              OctaRadioListTile(
                groupValue: _selectedChannelTemp,
                value: ChatChannelEnum.facebookMessenger,
                onSelect: _setChannelTemp,
                child: Row(children: [
                  Image.asset(AppChannelBadges.menssegerBadge, width: AppSizes.s06),
                  const SizedBox(width: AppSizes.s02),
                  OctaText.bodyLarge("Facebook Messenger"),
                ]),
              ),
              const Divider(height: 1, thickness: 1),

              // Instagram
              OctaRadioListTile(
                groupValue: _selectedChannelTemp,
                value: ChatChannelEnum.instagram,
                onSelect: _setChannelTemp,
                child: Row(children: [
                  Image.asset(AppChannelBadges.instagramBadge, width: AppSizes.s06),
                  const SizedBox(width: AppSizes.s02),
                  OctaText.bodyLarge("Instagram"),
                ]),
              ),
            ],
          ),
        ),
        const Divider(height: 1, thickness: 1),
        Padding(
          padding: const EdgeInsets.all(AppSizes.s04),
          child: OctaButton(text: "Filtrar", onTap: () => Navigator.of(context).pop(_selectedChannelTemp)),
        )
      ],
    );
  }
}
