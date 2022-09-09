import 'package:flutter/material.dart';
import 'package:octadesk_app/views/authentication/authentication_view.dart';
import 'package:octadesk_app/views/initialization/initialization_view.dart';
import 'package:octadesk_app/views/main/main_view.dart';
import 'package:octadesk_app/views/onboarding/onboarding_view.dart';

class PublicRouter {
  static final GlobalKey<NavigatorState> navigator = GlobalKey();
  static const String onboardingView = "onboarding";
  static const String authenticationView = "authentication";
  static const String mainView = "main";
  static const String initializationView = "initialization";

  static Route<dynamic> controller(RouteSettings settings) {
    switch (settings.name) {
      case initializationView:
        return MaterialPageRoute(builder: (context) => const InitializationView());

      //Start
      case onboardingView:
        return MaterialPageRoute(builder: (context) => const OnboardingView());

      //Start
      case authenticationView:
        return MaterialPageRoute(builder: (context) => const AuthenticationView());

      // Main
      case mainView:
        return MaterialPageRoute(builder: (context) => const MainView());

      default:
        throw ("Está rota é inválida");
    }
  }
}
