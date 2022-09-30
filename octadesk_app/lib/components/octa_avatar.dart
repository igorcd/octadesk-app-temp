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
