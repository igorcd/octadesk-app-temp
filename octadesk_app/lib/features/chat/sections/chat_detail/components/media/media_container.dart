import 'package:flutter/material.dart';
import 'package:octadesk_app/components/index.dart';
import 'package:octadesk_app/resources/index.dart';

class MediaContainer extends StatelessWidget {
  final void Function() onPressed;
  final void Function()? onDownload;
  final void Function()? onShare;
  final double? width;
  final double? height;
  final Widget child;
  final bool showDropdown;

  bool get isVertical => width != null || height != null;

  const MediaContainer({
    this.onDownload,
    this.onShare,
    required this.onPressed,
    required this.child,
    required this.width,
    required this.height,
    this.showDropdown = true,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Renderizar botão do menu
    Widget renderMenu() {
      return PopupMenuButton<int>(
        icon: Icon(Icons.more_vert, color: AppColors.info.shade200),
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(AppSizes.s03))),
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
      );
    }

    return SizedBox(
      width: width ?? double.infinity,
      height: height,
      child: Stack(
        children: [
          Container(
            width: width ?? double.infinity,
            height: height,
            clipBehavior: Clip.hardEdge,

            // Estilização
            decoration: BoxDecoration(
              color: AppColors.info.shade100,
              borderRadius: const BorderRadius.all(Radius.circular(AppSizes.s02)),
              boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 8)],
              border: Border.all(color: const Color.fromRGBO(0, 123, 255, .2), width: 1),
            ),

            // Detecção do clique
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: onPressed,
                child: child,
              ),
            ),
          ),
          Align(
            alignment: isVertical ? Alignment.topRight : Alignment.centerRight,
            child: Visibility(
              visible: showDropdown,
              child: renderMenu(),
            ),
          )
        ],
      ),
    );
  }
}
