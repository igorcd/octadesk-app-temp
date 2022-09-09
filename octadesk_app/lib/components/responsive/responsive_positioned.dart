import 'package:flutter/material.dart';
import 'package:octadesk_app/components/responsive/responsive_widgets.dart';
import 'package:octadesk_app/components/responsive/utils/get_property.dart';

class ResponsivePositioned extends StatelessWidget {
  final Responsive<double>? top;
  final Responsive<double>? left;
  final Responsive<double>? bottom;
  final Responsive<double>? right;
  final Responsive<double>? width;
  final Responsive<double>? height;
  final Widget child;

  const ResponsivePositioned({required this.child, this.top, this.left, this.bottom, this.right, this.width, this.height, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var screenWidth = size.width;
    var screenHeight = size.height;

    var properties = {
      "top": top,
      "left": left,
      "bottom": bottom,
      "right": right,
      "width": width,
      "height": height,
    };
    return Positioned(
      top: getProperty(properties: properties, property: "top", screenWidth: screenWidth, screenHeight: screenHeight),
      bottom: getProperty(properties: properties, property: "bottom", screenWidth: screenWidth, screenHeight: screenHeight),
      height: getProperty(properties: properties, property: "height", screenWidth: screenWidth, screenHeight: screenHeight),
      left: getProperty(properties: properties, property: "left", screenWidth: screenWidth, screenHeight: screenHeight),
      right: getProperty(properties: properties, property: "right", screenWidth: screenWidth, screenHeight: screenHeight),
      width: getProperty(properties: properties, property: "width", screenWidth: screenWidth, screenHeight: screenHeight),
      child: child,
    );
  }
}
