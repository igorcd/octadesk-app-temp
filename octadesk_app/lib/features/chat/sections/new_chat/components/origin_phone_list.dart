import 'package:flutter/material.dart';
import 'package:octadesk_app/components/index.dart';
import 'package:octadesk_app/resources/app_channel_badges.dart';
import 'package:octadesk_app/resources/index.dart';
import 'package:octadesk_app/utils/helper_functions.dart';
import 'package:octadesk_core/octadesk_core.dart';

class OriginPhoneList extends StatelessWidget {
  final List<PhoneNumberModel> numbers;
  const OriginPhoneList(this.numbers, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: numbers.length,
      itemBuilder: (c, i) {
        var number = numbers[i];

        return OctaListItem(
          title: number.name.isEmpty ? "-" : number.name,
          subtitle: setPhoneMaskHelper(number.number),
          leading: Image.asset(
            AppChannelBadges.whatsappBadge,
            width: AppSizes.s12,
          ),
          onPressed: () => Navigator.of(context).pop(number),
        );
      },
    );
  }
}
