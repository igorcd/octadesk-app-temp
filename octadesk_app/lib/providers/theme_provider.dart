import 'package:flutter/material.dart';
import 'package:octadesk_app/resources/app_theme.dart';
import 'package:octadesk_app/resources/index.dart';

enum DarkModeType {
  byOperatingSystem,
  light,
  dark,
}

class ThemeProvider extends ChangeNotifier {
  AppColorSwatch _primarySwatch = AppColorSwatch.blue;
  MaterialColor get primarySwatch {
    return AppColors.getColor(_primarySwatch);
  }

  DarkModeType _darkModeType = DarkModeType.byOperatingSystem;

  /// Tema escuro
  ThemeData get darkTheme {
    switch (_darkModeType) {
      case DarkModeType.byOperatingSystem:
      case DarkModeType.dark:
        return AppTheme.dark(primarySwatch);
      default:
        return AppTheme.light(primarySwatch);
    }
  }

  /// Tema escuro
  ThemeData get lightTheme {
    switch (_darkModeType) {
      case DarkModeType.byOperatingSystem:
      case DarkModeType.light:
        return AppTheme.light(primarySwatch);
      default:
        return AppTheme.dark(primarySwatch);
    }
  }

  void changeTheme(AppColorSwatch color) {
    _primarySwatch = color;
    notifyListeners();
  }

  void setDarkModeTIme(DarkModeType type) {
    _darkModeType = type;
    notifyListeners();
  }
}
