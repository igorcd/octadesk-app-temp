import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:octadesk_app/features/chat/chat_feature.dart';
import 'package:octadesk_app/features/chat/store/chat_store.dart';
import 'package:octadesk_app/features/settings/settings_feature.dart';
import 'package:octadesk_app/features/users/users_feature.dart';
import 'package:octadesk_app/views/authentication/authentication_view.dart';
import 'package:octadesk_app/views/initialization/initialization_view.dart';
import 'package:octadesk_app/views/main/main_view.dart';
import 'package:octadesk_app/views/onboarding/onboarding_view.dart';
import 'package:provider/provider.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');
final GlobalKey<NavigatorState> _shellNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'shell');

class AppRouter {
  static final GlobalKey<NavigatorState> navigator = GlobalKey();

  static const String initializationView = "initialization";
  static const String authenticationView = "authentication";
  static const String onboardingView = "onboarding";

  // Features
  static const String chatFeature = "chat";
  static const String botFeature = "bot";
  static const String dashboardsFeature = "dashboards";
  static const String usersFeature = "users";
  static const String settingsFeature = "settings";

  /// Gerador de transição
  static Widget _crossFadeTransitionBuilder({required Animation<double> animation, required Widget child}) {
    var transition = CurvedAnimation(parent: animation, curve: const Interval(0.6, 1, curve: Curves.ease));
    return ScaleTransition(
      scale: Tween<double>(begin: 0.98, end: 1).animate(transition),
      child: FadeTransition(opacity: transition, child: child),
    );
  }

  /// Gerador de página
  static Page _featuresPageBuilder({required LocalKey key, required Widget child}) {
    return CustomTransitionPage(
      key: key,
      child: child,
      transitionDuration: const Duration(milliseconds: 600),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        // Out Animation
        if (secondaryAnimation.value > 0) {
          return _crossFadeTransitionBuilder(animation: ReverseAnimation(secondaryAnimation), child: child);
        }
        // In Transition
        else {
          return _crossFadeTransitionBuilder(animation: animation, child: child);
        }
      },
    );
  }

  static GoRouter router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    routes: [
      // Inicialziação
      GoRoute(
        path: '/',
        name: initializationView,
        builder: (context, state) => const InitializationView(),
      ),

      // Autenticação
      GoRoute(
        path: '/authetication',
        name: authenticationView,
        builder: (context, state) => const AuthenticationView(),
      ),

      // Onboarding
      GoRoute(
        path: '/onboardinig',
        name: onboardingView,
        builder: (context, state) => const OnboardingView(),
      ),

      // Main View
      ShellRoute(
        navigatorKey: _shellNavigatorKey,
        builder: (context, state, child) => MainView(
          currentFeature: child,
        ),
        routes: [
          // Chat
          GoRoute(
            path: '/main',
            name: chatFeature,
            pageBuilder: (context, state) => _featuresPageBuilder(
              key: state.pageKey,
              child: ChangeNotifierProvider(
                create: (context) => ChatStore(),
                child: const ChatFeature(),
              ),
            ),
          ),

          // Bot
          GoRoute(
            path: '/bot',
            name: botFeature,
            pageBuilder: (context, state) => _featuresPageBuilder(key: state.pageKey, child: const Center(child: Text("BOT"))),
          ),
          GoRoute(
            path: '/dashboards',
            name: dashboardsFeature,
            pageBuilder: (context, state) => _featuresPageBuilder(key: state.pageKey, child: const Center(child: Text("Dashboards"))),
          ),
          GoRoute(
            path: '/users',
            name: usersFeature,
            pageBuilder: (context, state) => _featuresPageBuilder(key: state.pageKey, child: const UsersFeature()),
          ),
          GoRoute(
            path: '/settings',
            name: settingsFeature,
            pageBuilder: (context, state) => _featuresPageBuilder(key: state.pageKey, child: const SettingsFeature()),
          ),
        ],
      )
    ],
  );

  // static List<GoRoute> controller(RouteSettings settings) {
  //   switch (settings.name) {
  //     case initializationView:
  //       return MaterialPageRoute(builder: (context) => const InitializationView());

  //     //Start
  //     case onboardingView:
  //       return MaterialPageRoute(builder: (context) => const OnboardingView());

  //     //Start
  //     case authenticationView:
  //       return MaterialPageRoute(builder: (context) => const AuthenticationView());

  //     // Main
  //     case mainView:
  //       return MaterialPageRoute(builder: (context) => const MainFeature());

  //     default:
  //       throw ("Está rota é inválida");
  //   }
  // }
}
