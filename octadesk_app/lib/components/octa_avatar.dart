import 'package:flutter/material.dart';
import 'package:octadesk_app/resources/index.dart';
import 'package:transparent_image/transparent_image.dart';

class OctaAvatar extends StatelessWidget {
  final Color? backgroundColor;
  final double size;
  final double borderRadius;
  final Widget? badge;
  final double badgeVerticalOffset;
  final double badgeHorizontalOffset;
  final String? source;
  final String? name;
  final bool showBorder;
  final Color? fontColor;
  final double fontSize;
  final FontWeight fontWeight;
  final bool isLocalPicture;

  const OctaAvatar({
    this.fontWeight = FontWeight.bold,
    this.fontColor,
    this.fontSize = AppSizes.s04_5,
    this.backgroundColor,
    this.showBorder = false,
    this.size = AppSizes.s12,
    this.borderRadius = AppSizes.s03_5,
    this.source,
    this.badge,
    this.name,
    this.badgeVerticalOffset = -5,
    this.badgeHorizontalOffset = -5,
    this.isLocalPicture = false,
    Key? key,
  }) : super(key: key);

  Widget _renderImage() {
    return Container(
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(borderRadius)), color: AppColors.info.shade100),
      child: isLocalPicture
          ? Image.asset(source!)
          : FadeInImage.memoryNetwork(
              placeholder: kTransparentImage,
              image: source!,
            ),
    );
  }

  /// Formatar iniciais
  String getInitialsHelper(String? name) {
    if (name != null && name.trim().isNotEmpty) {
      var words = name.trim().split(" ");
      if (words.length > 1) {
        return words[0][0].toUpperCase() + words[words.length - 1][0].toUpperCase();
      } else if (words[0].length > 1) {
        return words[0].substring(0, 2).toUpperCase();
      } else {
        return words[0].toUpperCase();
      }
    }

    return "-";
  }

  Widget _renderInitials() {
    return Container(
      decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(borderRadius)), color: backgroundColor ?? AppColors.info.shade200),
      child: Center(
        child: Text(
          getInitialsHelper(name!),
          style: TextStyle(fontWeight: fontWeight, fontSize: fontSize, color: fontColor ?? AppColors.info.shade700),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        //
        // Imagem
        Container(
          width: size,
          height: size,
          clipBehavior: Clip.hardEdge,
          decoration: BoxDecoration(
            boxShadow: const [BoxShadow(color: Color.fromRGBO(0, 0, 0, .07), blurRadius: 4, offset: Offset(0, 4))],
            borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
            color: AppColors.info.shade300,
            border: showBorder ? Border.all(color: AppColors.info.shade800, width: 2) : null,
          ),
          child: source != null && source!.isNotEmpty ? _renderImage() : _renderInitials(),
        ),
        //
        // Badge
        if (badge != null)
          Positioned(
            bottom: badgeVerticalOffset,
            right: badgeHorizontalOffset,
            child: Center(
              child: badge,
            ),
          )
      ],
    );
  }
}
