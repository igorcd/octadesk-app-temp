import 'package:flutter/material.dart';
import 'package:octadesk_app/components/index.dart';
import 'package:octadesk_app/features/contacts/dialogs/organizations_dialog.dart';
import 'package:octadesk_app/resources/index.dart';
import 'package:octadesk_app/utils/helper_functions.dart';

class ContactOrganizationInput extends StatelessWidget {
  const ContactOrganizationInput({super.key});

  @override
  Widget build(BuildContext context) {
    void addOrganization() async {
      var resp = await showOctaBottomSheet(
        context,
        title: "Organizações",
        child: const OrganizationsDialog(),
      );
    }

    var colorScheme = Theme.of(context).colorScheme;

    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              OctaText.labelLarge("Organização"),
              Text(
                "Nome",
                style: TextStyle(
                  fontSize: AppSizes.s04,
                  color: colorScheme.onBackground,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: AppSizes.s01_5),
          child: OctaIconButton(
            size: AppSizes.s08,
            iconSize: AppSizes.s07,
            onPressed: () => addOrganization(),
            icon: true ? AppIcons.attach : AppIcons.detach,
          ),
        )
      ],
    );
  }
}
