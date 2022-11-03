import 'package:flutter/material.dart';
import 'package:octadesk_app/components/index.dart';
import 'package:octadesk_app/resources/index.dart';

class ChatInputAttachmentButtons extends StatelessWidget {
  // final void Function() onOpenCamera;
  final void Function() onOpenAttachments;
  final void Function() onOpenMicrophone;
  const ChatInputAttachmentButtons({
    // required this.onOpenCamera,
    required this.onOpenAttachments,
    required this.onOpenMicrophone,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSizes.s02, right: AppSizes.s01),
      child: Row(children: [
        // OctaIconButton(
        //   onPressed: onOpenCamera,
        //   icon: AppIcons.camera,
        //   color: colorScheme.onSecondary,
        //   size: AppSizes.s08,
        //   iconSize: AppSizes.s06,
        // ),
        // const SizedBox(width: AppSizes.s00_5),
        OctaIconButton(
          onPressed: onOpenAttachments,
          icon: AppIcons.attach,
          color: colorScheme.onSecondary,
          size: AppSizes.s08,
          iconSize: AppSizes.s06,
        ),
        OctaIconButton(
          onPressed: onOpenMicrophone,
          icon: AppIcons.microphone,
          color: colorScheme.onSecondary,
          size: AppSizes.s08,
          iconSize: AppSizes.s06,
        ),
      ]),
    );
  }
}
