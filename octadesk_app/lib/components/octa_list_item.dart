import 'package:flutter/material.dart';
import 'package:octadesk_app/components/index.dart';
import 'package:octadesk_app/resources/index.dart';

class OctaListItem extends StatelessWidget {
  final void Function()? onPressed;
  final String title;
  final String? subtitle;
  final String? pictureUrl;
  final bool isLocalPicture;
  final bool showDivider;
  final bool selected;
  final double avatarBorderRadius;

  const OctaListItem({
    required this.title,
    this.subtitle,
    this.pictureUrl,
    required this.showDivider,
    this.selected = false,
    this.onPressed,
    this.isLocalPicture = false,
    this.avatarBorderRadius = AppSizes.s02_5,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: selected ? AppColors.info.shade100 : null,
      height: AppSizes.s18,
      child: Column(
        children: [
          Expanded(
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: onPressed,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: AppSizes.s06),
                  child: Row(
                    children: [
                      OctaAvatar(
                        borderRadius: avatarBorderRadius,
                        source: pictureUrl,
                        name: title,
                        isLocalPicture: isLocalPicture,
                      ),
                      const SizedBox(width: AppSizes.s04),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            OctaText.titleMedium(
                              title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            if (subtitle != null)
                              OctaText.titleSmall(
                                subtitle!,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
          const Divider(height: 1, thickness: 1)
        ],
      ),
    );
  }
}
