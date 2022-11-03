import 'package:flutter/material.dart';
import 'package:octadesk_app/resources/index.dart';
import 'package:transparent_image/transparent_image.dart';

class OctaAvatar extends StatelessWidget {
  final double size;
  final Widget? badge;
  final double badgeVerticalOffset;
  final double badgeHorizontalOffset;
  final String? source;
  final String? name;
  final double fontSize;
  final bool isLocalPicture;

  const OctaAvatar({
    this.fontSize = AppSizes.s04,
    this.size = AppSizes.s12,
    this.source,
    this.badge,
    this.name,
    this.badgeVerticalOffset = -2,
    this.badgeHorizontalOffset = -2,
    this.isLocalPicture = false,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget renderImage() {
      return isLocalPicture
          ? Image.asset(source!, fit: BoxFit.cover)
          : FadeInImage.memoryNetwork(
              placeholder: kTransparentImage,
              image: source!,
              fit: BoxFit.cover,
            );
    }

    /// Formatar iniciais
    String getInitialsHelper(String? name) {
      var formattedName = name?.trim().padRight(3, "").toLowerCase().substring(0, 3);
      if (formattedName != null) {
        return "${formattedName.substring(0, 1).toUpperCase()}${formattedName.substring(1, 3)}";
      }
      return "-";
    }

    Widget renderInitials() {
      return Center(
        child: Text(
          getInitialsHelper(name!),
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.w600,
            color: Theme.of(context).colorScheme.onSecondary,
            fontFamily: "Poppins",
          ),
        ),
      );
    }

    return Stack(
      clipBehavior: Clip.none,
      children: [
        //
        // Imagem
        Container(
          width: size,
          height: size,
          clipBehavior: Clip.hardEdge,
          decoration: ShapeDecoration(
            color: Theme.of(context).colorScheme.outline,
            shape: ContinuousRectangleBorder(
              borderRadius: BorderRadius.circular(size / 2),
            ),
          ),
          child: source != null && source!.isNotEmpty ? renderImage() : renderInitials(),
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
