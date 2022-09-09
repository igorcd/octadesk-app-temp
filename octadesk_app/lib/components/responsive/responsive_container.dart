import 'package:flutter/material.dart';
import 'package:octadesk_app/components/responsive/utils/get_property.dart';
import 'package:octadesk_app/components/responsive/utils/responsive.dart';

class ResponsiveContainer extends StatelessWidget {
  final BoxConstraints? constraints;
  final Responsive<double>? width;
  final Responsive<double>? height;
  final Responsive<BoxDecoration>? decoration;
  final Responsive<EdgeInsets>? padding;
  final Responsive<EdgeInsets>? margin;
  final Widget? child;
  final Clip clipBehavior;
  const ResponsiveContainer({this.clipBehavior = Clip.none, this.width, this.margin, this.child, this.padding, this.height, this.constraints, this.decoration, Key? key})
      : super(key: key);

  /// Fazer merde do decoration
  BoxDecoration _mergeDecorations(BoxDecoration decoration1, BoxDecoration decoration2) {
    return decoration1.copyWith(
      backgroundBlendMode: decoration2.backgroundBlendMode,
      border: decoration2.border,
      borderRadius: decoration2.borderRadius,
      boxShadow: decoration2.boxShadow,
      color: decoration2.color,
      gradient: decoration2.gradient,
      image: decoration2.image,
      shape: decoration2.shape,
    );
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    Map<String, dynamic> properties = {
      "width": width,
      "height": height,
      "decoration": decoration,
      "padding": padding,
      "margin": margin,
    };

    BoxDecoration? getDecoration(double width, double height) {
      var currentDecoration = getProperty<BoxDecoration>(properties: properties, property: "decoration", screenWidth: width, screenHeight: height);

      if (currentDecoration != null) {
        return _mergeDecorations(decoration!.mobile, currentDecoration);
      }

      return null;
    }

    return Container(
      clipBehavior: clipBehavior,
      width: getProperty<double>(properties: properties, property: "width", screenWidth: size.width, screenHeight: size.height),
      height: getProperty<double>(properties: properties, property: "height", screenWidth: size.width, screenHeight: size.height),
      padding: getProperty<EdgeInsets>(properties: properties, property: "padding", screenWidth: size.width, screenHeight: size.height),
      margin: getProperty<EdgeInsets>(properties: properties, property: "margin", screenWidth: size.width, screenHeight: size.height),
      constraints: constraints,
      decoration: getDecoration(size.width, size.height),
      child: child,
    );
  }
}
