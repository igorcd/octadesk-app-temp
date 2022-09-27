import 'package:flutter/material.dart';
import 'package:octadesk_app/components/index.dart';
import 'package:octadesk_app/resources/app_channel_badges.dart';
import 'package:octadesk_app/resources/app_sizes.dart';
import 'package:octadesk_app/utils/helper_functions.dart';
import 'package:octadesk_core/dtos/contact/contact_phone_dto.dart';

class ContactPhoneList extends StatelessWidget {
  final List<ContactPhoneDTO> contacts;
  const ContactPhoneList(this.contacts, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: contacts.length,
      itemBuilder: (c, i) {
        var contact = contacts[i];

        return OctaListItem(
          title: setPhoneMaskHelper(contact.countryCode + contact.number),
          leading: Image.asset(
            AppChannelBadges.whatsappBadge,
            width: AppSizes.s12,
          ),
          onPressed: () => Navigator.of(context).pop(contact),
        );
      },
    );
  }
}
