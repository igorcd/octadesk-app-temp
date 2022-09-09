import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:octadesk_app/features/chat/chat_module.dart';
import 'package:octadesk_app/features/users/users_module.dart';

class FeaturesRouter {
  static GlobalKey<NavigatorState> featuresNavigator = GlobalKey<NavigatorState>();

  static PageRouteBuilder _fadeTransition(Widget page) {
    return PageRouteBuilder(
      transitionDuration: const Duration(milliseconds: 150),
      pageBuilder: (c, _, __) => page,
      transitionsBuilder: (ctx, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: animation,
          child: child,
        );
      },
    );
  }

  static const String chatModule = "chatModule";
  static const String usersModule = "usersModule";

  static Route<dynamic> controller(RouteSettings settings) {
    switch (settings.name) {
      case chatModule:
        return _fadeTransition(const ChatModule());

      //Start
      case usersModule:
        return _fadeTransition(const UsersModule());

      default:
        throw ("Está rota é inválida");
    }
  }
}
