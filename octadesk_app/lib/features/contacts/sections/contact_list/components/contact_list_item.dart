import 'package:flutter/material.dart';
import 'package:octadesk_app/components/index.dart';
import 'package:octadesk_app/components/octa_chip.dart';
import 'package:octadesk_app/resources/index.dart';
import 'package:octadesk_core/octadesk_core.dart';

class ContactListItem extends StatelessWidget {
  final ContactListModel contact;
  final bool selected;
  final void Function() onPressed;
  const ContactListItem(this.contact, {required this.onPressed, required this.selected, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;
    var textTheme = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSizes.s02),
      height: AppSizes.s18,
      child: Material(
        borderRadius: BorderRadius.circular(AppSizes.s03_5),
        clipBehavior: Clip.hardEdge,
        color: selected ? colorScheme.background.withOpacity(.8) : Colors.transparent,

        // Botão
        child: InkWell(
          onTap: onPressed,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSizes.s02, vertical: AppSizes.s02),
            child: Row(
              children: [
                //
                // Avatar do usuário
                OctaAvatar(
                  size: AppSizes.s13,
                  name: contact.name,
                  source: contact.thumbUrl,
                ),
                const SizedBox(width: AppSizes.s04),

                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              contact.name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: textTheme.titleMedium,
                            ),
                          ),
                          OctaChip(
                            text: contactTypeEnumParser(contact.type),
                            color: contact.type == ContactTypeEnum.cliente ? AppColors.teal : AppColors.lime,
                          )
                        ],
                      ),
                      if (contact.organizationName.isNotEmpty)
                        OctaText.titleSmall(
                          contact.organizationName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
