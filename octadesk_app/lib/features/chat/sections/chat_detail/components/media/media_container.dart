import 'package:flutter/material.dart';
import 'package:octadesk_app/components/index.dart';
import 'package:octadesk_app/resources/index.dart';

class MediaContainer extends StatelessWidget {
  final void Function()? onPressed;
  final void Function()? onDownload;
  final void Function()? onShare;
  final Widget child;
  final bool showDropdown;

  const MediaContainer({
    this.onDownload,
    this.onShare,
    this.onPressed,
    required this.child,
    this.showDropdown = true,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Renderizar botão do menu
    Widget renderMenu() {
      return PopupMenuButton<int>(
        onSelected: (value) {},
        itemBuilder: (context) {
          return [
            PopupMenuItem<int>(
              enabled: onDownload != null,
              value: 0,
              onTap: onDownload,
              child: const OctaText("Baixar"),
            ),
            PopupMenuItem<int>(
              value: 1,
              onTap: onShare,
              child: const OctaText("Compartilhar"),
            ),
          ];
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSizes.s03, vertical: AppSizes.s01_5),
          child: Icon(
            Icons.more_horiz,
            color: Theme.of(context).colorScheme.onSecondary,
            size: 20,
          ),
        ),
      );
    }

    return Stack(
      children: [
        Positioned.fill(
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onPressed,
              child: child,
            ),
          ),
        ),
        Align(
          alignment: Alignment.topRight,
          child: Visibility(
            visible: showDropdown,
            child: renderMenu(),
          ),
        )
      ],
    );
  }
}
