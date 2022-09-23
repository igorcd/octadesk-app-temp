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

  // info
  static const int _infoPrimaryValue = 0xff5A6377;
  static const MaterialColor info = MaterialColor(
    _infoPrimaryValue,
    <int, Color>{
      100: Color(0xffF4F4F5),
      200: Color(0xffE3E4E8),
      300: Color(0xffC4C7CF),
      400: Color(0xff7C8498),
      500: Color(_infoPrimaryValue),
      600: Color(0xff4F5464),
      700: Color(0xff3F4454),
      800: Color(0xff303243),
      900: Color(0xff1E202E)
    },
  );

  // Purple
  static const int _purplePrimaryValue = 0xff7b16c1;
  static const MaterialColor purple = MaterialColor(
    _purplePrimaryValue,
    <int, Color>{
      100: Color(0xfff5f1f9),
      200: Color(0xffe8dcf1),
      300: Color(0xffccaede),
      400: Color(0xff9051b9),
      500: Color(_purplePrimaryValue),
      600: Color(0xff612a88),
      700: Color(0xff50346d),
      800: Color(0xff322a46),
    },
  );

  // News
  static const int _newsPrimaryValue = 0xff5D28B8;
  static const MaterialColor news = MaterialColor(
    _newsPrimaryValue,
    <int, Color>{
      100: Color(0xfff3effb),
      200: Color(0xffe8dff6),
      300: Color(0xffc9b6ea),
      400: Color(0xff8b63d1),
      500: Color(_newsPrimaryValue),
      600: Color(0xff4d3082),
      700: Color(0xff403163),
      800: Color(0xff312d4a),
    },
  );

  // Indigo
  static const int _indigoPrimaryValue = 0xff3439c6;
  static const MaterialColor indigo = MaterialColor(
    _indigoPrimaryValue,
    <int, Color>{
      100: Color(0xffeeeefb),
      200: Color(0xffdedef7),
      300: Color(0xffbdbff0),
      400: Color(0xff7679e0),
      500: Color(_indigoPrimaryValue),
      600: Color(0xff373a86),
      700: Color(0xff2f3265),
      800: Color(0xff2c2e49),
    },
  );

  // Blue
  static const int _bluePrimaryValue = 0xff1366C9;
  static const MaterialColor blue = MaterialColor(
    _bluePrimaryValue,
    <int, Color>{
      100: Color(0xffECF4FD),
      200: Color(0xffDAE8FB),
      300: Color(0xffB1CFF5),
      400: Color(0xff5699EA),
      500: Color(_bluePrimaryValue),
      600: Color(0xff285C9A),
      700: Color(0xff2F4C74),
      800: Color(0xff29354D),
    },
  );

  // Teal
  static const int _tealPrimaryValue = 0xff067E88;
  static const MaterialColor teal = MaterialColor(
    _tealPrimaryValue,
    <int, Color>{
      100: Color(0xffeffafb),
      200: Color(0xffd8f1f3),
      300: Color(0xffabe3e8),
      400: Color(0xff49c2cb),
      500: Color(_tealPrimaryValue),
      600: Color(0xff227077),
      700: Color(0xff2e5c66),
      800: Color(0xff2a3e4b),
    },
  );

  // success
  static const int _successPrimaryValue = 0xff09a944;
  static const MaterialColor success = MaterialColor(
    _successPrimaryValue,
    <int, Color>{
      100: Color(0xffebfaf0),
      200: Color(0xffcff2db),
      300: Color(0xff86dfa7),
      400: Color(0xff38cc6f),
      500: Color(_successPrimaryValue),
      600: Color(0xff256f42),
      700: Color(0xff254b3a),
      800: Color(0xff203637),
    },
  );

  // Lime
  static const int _limePrimaryValue = 0xff91ae1e;
  static const MaterialColor lime = MaterialColor(
    _limePrimaryValue,
    <int, Color>{
      100: Color(0xfff5fae5),
      200: Color(0xffe3f1bb),
      300: Color(0xffd5e792),
      400: Color(0xffb0d02f),
      500: Color(_limePrimaryValue),
      600: Color(0xff6e7e2f),
      700: Color(0xff4a5232),
      800: Color(0xff2b3b2e),
    },
  );

  // Yellow
  static const int _warningPrimaryValue = 0xffFAC300;
  static const MaterialColor warning = MaterialColor(
    _warningPrimaryValue,
    <int, Color>{
      100: Color(0xfffffae5),
      200: Color(0xfffff3cb),
      300: Color(0xffffe894),
      400: Color(0xffffd642),
      500: Color(_warningPrimaryValue),
      600: Color(0xffb6931b),
      700: Color(0xff574b24),
      800: Color(0xff3c382f),
    },
  );

  // Amber
  static const int _amberPrimaryValue = 0xfffaa000;
  static const MaterialColor amber = MaterialColor(
    _amberPrimaryValue,
    <int, Color>{
      100: Color(0xfffff8eb),
      200: Color(0xffffeccc),
      300: Color(0xffffd894),
      400: Color(0xffffbb42),
      500: Color(_amberPrimaryValue),
      600: Color(0xffc18215),
      700: Color(0xff5d4a2d),
      800: Color(0xff3e3633),
    },
  );

  // Orange
  static const int _orangePrimaryValue = 0xffeb670a;
  static const MaterialColor orange = MaterialColor(
    _orangePrimaryValue,
    <int, Color>{
      100: Color(0xfffff2eb),
      200: Color(0xffffddc7),
      300: Color(0xffffba8a),
      400: Color(0xffff8b38),
      500: Color(_orangePrimaryValue),
      600: Color(0xffaa561c),
      700: Color(0xff553824),
      800: Color(0xff3b2c21),
    },
  );

  // danger
  static const int _dangerPrimaryValue = 0xffD33003;
  static const MaterialColor danger = MaterialColor(
    _dangerPrimaryValue,
    <int, Color>{
      100: Color(0xfffdf0ec),
      200: Color(0xfffbd9d0),
      300: Color(0xfff8baaa),
      400: Color(0xffF17250),
      500: Color(_dangerPrimaryValue),
      600: Color(0xffa23b20),
      700: Color(0xff5b332e),
      800: Color(0xff3e2d34),
    },
  );

  // Rose
  static const int _rosePrimaryValue = 0xffd1155d;
  static const MaterialColor rose = MaterialColor(
    _rosePrimaryValue,
    <int, Color>{
      100: Color(0xfffdecf3),
      200: Color(0xfffbd0e1),
      300: Color(0xfff8a0c2),
      400: Color(0xfff1508e),
      500: Color(_rosePrimaryValue),
      600: Color(0xffae285e),
      700: Color(0xff632b48),
      800: Color(0xff3a2739),
    },
  );

  // Pink
  static const int _pinkPrimaryValue = 0xffc1168d;
  static const MaterialColor pink = MaterialColor(
    _pinkPrimaryValue,
    <int, Color>{
      100: Color(0xffFCEEF7),
      200: Color(0xffF7CAE8),
      300: Color(0xfff19dd7),
      400: Color(0xffdd55b4),
      500: Color(_pinkPrimaryValue),
      600: Color(0xff9d2a7c),
      700: Color(0xff622d59),
      800: Color(0xff3c2942),
    },
  );
}
