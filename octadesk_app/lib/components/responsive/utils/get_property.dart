library get_property;

import 'package:octadesk_app/components/responsive/utils/responsive.dart';
import 'package:octadesk_app/components/responsive/utils/screen_size.dart';

/// Pegar uma properiedade
T? getProperty<T>({required Map<String, dynamic> properties, required String property, required double screenWidth, required double screenHeight}) {
  if (properties[property] != null) {
    var el = (properties[property] as Responsive).toMap();

    // XS
    if ((screenHeight <= 680 || screenWidth < 360) && el["xs"] != null) {
      return el["xs"];
    }

    // 2XL
    if (screenWidth >= ScreenSize.xxl && el["xxl"] != null) {
      return el["xxl"];
    }
    // XL
    if (screenWidth >= ScreenSize.xl && el["xl"] != null) {
      return el["xl"];
    }
    // LG
    if (screenWidth >= ScreenSize.lg && el["lg"] != null) {
      return el["lg"];
    }
    // MD
    if (screenWidth >= ScreenSize.md && el["md"] != null) {
      return el["md"];
    }
    // SM
    if (screenWidth >= ScreenSize.sm && el["sm"] != null) {
      return el["sm"];
    }

    // Default
    else {
      return el["mobile"];
    }
  }
  return null;
}
