import 'package:flutter/material.dart';
import 'package:octadesk_app/components/index.dart';
import 'package:octadesk_app/resources/index.dart';

class ContactOrganizationInput extends StatelessWidget {
  final void Function()? onAdd;
  final void Function()? onRemove;
  final String value;

  const ContactOrganizationInput({required this.value, this.onAdd, this.onRemove, super.key});

  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;

    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              OctaText.labelLarge("Organização"),
              Text(
                value,
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
            onPressed: onAdd ?? onRemove!,
            icon: onAdd != null ? AppIcons.attach : AppIcons.detach,
          ),
        )
      ],
    );
  }
}
