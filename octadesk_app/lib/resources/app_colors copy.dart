import 'package:flutter/material.dart';

enum AppColorSwatch {
  info,
  purple,
  news,
  indigo,
  blue,
  teal,
  success,
  lime,
  warning,
  amber,
  orange,
  danger,
  rose,
  pink,
}

class AppColors {
  const AppColors._();

  static MaterialColor getColor(AppColorSwatch swatch) {
    switch (swatch) {
      case AppColorSwatch.info:
        return info;
      case AppColorSwatch.purple:
        return purple;
      case AppColorSwatch.news:
        return news;
      case AppColorSwatch.indigo:
        return indigo;
      case AppColorSwatch.blue:
        return blue;
      case AppColorSwatch.teal:
        return teal;
      case AppColorSwatch.success:
        return success;
      case AppColorSwatch.lime:
        return lime;
      case AppColorSwatch.warning:
        return warning;
      case AppColorSwatch.amber:
        return amber;
      case AppColorSwatch.orange:
        return orange;
      case AppColorSwatch.danger:
        return danger;
      case AppColorSwatch.rose:
        return rose;
      case AppColorSwatch.pink:
        return pink;
      default:
        return blue;
    }
  }

  // ======= info =======
  static const int _infoPrimaryValue = 0xff5A6377;
  static const List<Color> _infoSwatch = [
    Color(0xffF4F4F5),
    Color(0xffE3E4E8),
    Color(0xffC4C7CF),
    Color(0xff7C8498),
    Color(_infoPrimaryValue),
    Color(0xff4F5464),
    Color(0xff3F4454),
    Color(0xff303243),
  ];
  static MaterialColor get info {
    var swatch = WidgetsBinding.instance.window.platformBrightness == Brightness.dark ? _infoSwatch.reversed.toList() : _infoSwatch;
    return MaterialColor(
      _infoPrimaryValue,
      swatch.asMap().map((key, value) => MapEntry((key + 1) * 100, value)),
    );
  }

  // ======= Purple =======
  static const int _purplePrimaryValue = 0xff7B15C1;
  static const List<Color> _purpleSwatch = [
    Color(0xfff5f1f9),
    Color(0xffe8dcf1),
    Color(0xffccaede),
    Color(0xff9051b9),
    Color(_purplePrimaryValue),
    Color(0xff612a88),
    Color(0xff50346d),
    Color(0xff322a46),
  ];
  static MaterialColor get purple {
    var swatch = WidgetsBinding.instance.window.platformBrightness == Brightness.dark ? _purpleSwatch.reversed.toList() : _purpleSwatch;
    return MaterialColor(
      _purplePrimaryValue,
      swatch.asMap().map((key, value) => MapEntry((key + 1) * 100, value)),
    );
  }

  // ======= News =======
  static const int _newsPrimaryValue = 0xff5D28B8;
  static const List<Color> _newsSwatch = [
    Color(0xfff3effb),
    Color(0xffe8dff6),
    Color(0xffc9b6ea),
    Color(0xff8b63d1),
    Color(_newsPrimaryValue),
    Color(0xff4d3082),
    Color(0xff403163),
    Color(0xff312d4a),
  ];
  static MaterialColor get news {
    var swatch = WidgetsBinding.instance.window.platformBrightness == Brightness.dark ? _newsSwatch.reversed.toList() : _newsSwatch;
    return MaterialColor(
      _newsPrimaryValue,
      swatch.asMap().map((key, value) => MapEntry((key + 1) * 100, value)),
    );
  }

  // ======= Indigo =======
  static const int _indigoPrimaryValue = 0xff3439C6;
  static const List<Color> _indigoSwatch = [
    Color(0xffeeeefb),
    Color(0xffdedef7),
    Color(0xffbdbff0),
    Color(0xff7679e0),
    Color(_indigoPrimaryValue),
    Color(0xff373a86),
    Color(0xff2f3265),
    Color(0xff2c2e49),
  ];
  static MaterialColor get indigo {
    var swatch = WidgetsBinding.instance.window.platformBrightness == Brightness.dark ? _indigoSwatch.reversed.toList() : _indigoSwatch;
    return MaterialColor(
      _indigoPrimaryValue,
      swatch.asMap().map((key, value) => MapEntry((key + 1) * 100, value)),
    );
  }

  // ======= Blue =======
  static const int _bluePrimaryValue = 0xff1366C9;
  static const List<Color> _blueSwatch = [
    Color(0xffECF4FD),
    Color(0xffDAE8FB),
    Color(0xffB1CFF5),
    Color(0xff5699EA),
    Color(_bluePrimaryValue),
    Color(0xff285C9A),
    Color(0xff2F4C74),
    Color(0xff29354D),
  ];
  static MaterialColor get blue {
    var swatch = WidgetsBinding.instance.window.platformBrightness == Brightness.dark ? _blueSwatch.reversed.toList() : _blueSwatch;
    return MaterialColor(
      _bluePrimaryValue,
      swatch.asMap().map((key, value) => MapEntry((key + 1) * 100, value)),
    );
  }

// ======= Teal =======
  static const int _tealPrimaryValue = 0xff067E88;
  static const List<Color> _tealSwatch = [
    Color(0xffeffafb),
    Color(0xffd8f1f3),
    Color(0xffabe3e8),
    Color(0xff49c2cb),
    Color(_tealPrimaryValue),
    Color(0xff227077),
    Color(0xff2e5c66),
    Color(0xff2a3e4b),
  ];
  static MaterialColor get teal {
    var swatch = WidgetsBinding.instance.window.platformBrightness == Brightness.dark ? _tealSwatch.reversed.toList() : _tealSwatch;
    return MaterialColor(
      _tealPrimaryValue,
      swatch.asMap().map((key, value) => MapEntry((key + 1) * 100, value)),
    );
  }

  // ======= success =======
  static const int _successPrimaryValue = 0xff09a944;
  static const List<Color> _successSwatch = [
    Color(0xffebfaf0),
    Color(0xffcff2db),
    Color(0xff86dfa7),
    Color(0xff38cc6f),
    Color(_successPrimaryValue),
    Color(0xff256f42),
    Color(0xff254b3a),
    Color(0xff203637),
  ];
  static MaterialColor get success {
    var swatch = WidgetsBinding.instance.window.platformBrightness == Brightness.dark ? _successSwatch.reversed.toList() : _successSwatch;
    return MaterialColor(
      _successPrimaryValue,
      swatch.asMap().map((key, value) => MapEntry((key + 1) * 100, value)),
    );
  }

  // ======= Lime =======
  static const int _limePrimaryValue = 0xff91AE1E;
  static const List<Color> _limeSwatch = [
    Color(0xfff5fae5),
    Color(0xffe3f1bb),
    Color(0xffd5e792),
    Color(0xffb0d02f),
    Color(_limePrimaryValue),
    Color(0xff6e7e2f),
    Color(0xff4a5232),
    Color(0xff2b3b2e),
  ];
  static MaterialColor get lime {
    var swatch = WidgetsBinding.instance.window.platformBrightness == Brightness.dark ? _limeSwatch.reversed.toList() : _limeSwatch;
    return MaterialColor(
      _limePrimaryValue,
      swatch.asMap().map((key, value) => MapEntry((key + 1) * 100, value)),
    );
  }

  // ======= warning =======
  static const int _warningPrimaryValue = 0xffD33003;
  static const List<Color> _warningSwatch = [
    Color(0xffFDF0EC),
    Color(0xffFBD9D0),
    Color(0xffF8BAAA),
    Color(0xffF17250),
    Color(_warningPrimaryValue),
    Color(0xffA23B20),
    Color(0xff5B332E),
    Color(0xff3E2D34),
  ];
  static MaterialColor get warning {
    var swatch = WidgetsBinding.instance.window.platformBrightness == Brightness.dark ? _warningSwatch.reversed.toList() : _warningSwatch;
    return MaterialColor(
      _warningPrimaryValue,
      swatch.asMap().map((key, value) => MapEntry((key + 1) * 100, value)),
    );
  }

  // ======= Amber =======
  static const int _amberPrimaryValue = 0xfffaa000;
  static const List<Color> _amberSwatch = [
    Color(0xfffff8eb),
    Color(0xffffeccc),
    Color(0xffffd894),
    Color(0xffffbb42),
    Color(_amberPrimaryValue),
    Color(0xffc18215),
    Color(0xff5d4a2d),
    Color(0xff3e3633),
  ];
  static MaterialColor get amber {
    var swatch = WidgetsBinding.instance.window.platformBrightness == Brightness.dark ? _amberSwatch.reversed.toList() : _amberSwatch;
    return MaterialColor(
      _amberPrimaryValue,
      swatch.asMap().map((key, value) => MapEntry((key + 1) * 100, value)),
    );
  }

  // ======= Orange =======
  static const int _orangePrimaryValue = 0xffeb670a;
  static const List<Color> _orangeSwatch = [
    Color(0xfffff2eb),
    Color(0xffffddc7),
    Color(0xffffba8a),
    Color(0xffff8b38),
    Color(_orangePrimaryValue),
    Color(0xffaa561c),
    Color(0xff553824),
    Color(0xff3b2c21),
  ];
  static MaterialColor get orange {
    var swatch = WidgetsBinding.instance.window.platformBrightness == Brightness.dark ? _orangeSwatch.reversed.toList() : _orangeSwatch;
    return MaterialColor(
      _orangePrimaryValue,
      swatch.asMap().map((key, value) => MapEntry((key + 1) * 100, value)),
    );
  }

  // ======= danger =======
  static const int _dangerPrimaryValue = 0xffD33003;
  static const List<Color> _dangerSwatch = [
    Color(0xfffdf0ec),
    Color(0xfffbd9d0),
    Color(0xfff8baaa),
    Color(0xffF17250),
    Color(_dangerPrimaryValue),
    Color(0xffa23b20),
    Color(0xff5b332e),
    Color(0xff3e2d34),
  ];
  static MaterialColor get danger {
    var swatch = WidgetsBinding.instance.window.platformBrightness == Brightness.dark ? _dangerSwatch.reversed.toList() : _dangerSwatch;
    return MaterialColor(
      _dangerPrimaryValue,
      swatch.asMap().map((key, value) => MapEntry((key + 1) * 100, value)),
    );
  }

  // ======= Rose =======
  static const int _rosePrimaryValue = 0xffD1155D;
  static const List<Color> _roseSwatch = [
    Color(0xfffdecf3),
    Color(0xfffbd0e1),
    Color(0xfff8a0c2),
    Color(0xfff1508e),
    Color(_rosePrimaryValue),
    Color(0xffae285e),
    Color(0xff632b48),
    Color(0xff3a2739),
  ];
  static MaterialColor get rose {
    var swatch = WidgetsBinding.instance.window.platformBrightness == Brightness.dark ? _roseSwatch.reversed.toList() : _roseSwatch;
    return MaterialColor(
      _rosePrimaryValue,
      swatch.asMap().map((key, value) => MapEntry((key + 1) * 100, value)),
    );
  }

  // ======= Pink =======
  static const int _pinkPrimaryValue = 0xffC1158D;
  static const List<Color> _pinkSwatch = [
    Color(0xffFCEEF7),
    Color(0xffF7CAE8),
    Color(0xfff19dd7),
    Color(0xffdd55b4),
    Color(_pinkPrimaryValue),
    Color(0xff9d2a7c),
    Color(0xff622d59),
    Color(0xff3c2942),
  ];
  static MaterialColor get pink {
    var swatch = WidgetsBinding.instance.window.platformBrightness == Brightness.dark ? _pinkSwatch.reversed.toList() : _pinkSwatch;
    return MaterialColor(
      _pinkPrimaryValue,
      swatch.asMap().map((key, value) => MapEntry((key + 1) * 100, value)),
    );
  }
}
