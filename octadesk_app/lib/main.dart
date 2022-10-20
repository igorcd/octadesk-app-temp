import 'dart:io';
import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';
import 'package:flutter_portal/flutter_portal.dart';
import 'package:octadesk_app/providers/authentication_provider.dart';
import 'package:octadesk_app/providers/theme_provider.dart';
import 'package:octadesk_app/router/public_router.dart';
import 'package:octadesk_app/toolbar/app_toolbar.dart';
import 'package:octadesk_core/enums/octa_environment_enum.dart';
import 'package:octadesk_services/octadesk_services.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setEnvironment(environment: OctaEnvironmentEnum.prod);
  // initializeDateFormatting('pt_BR', null);

  if (Platform.isWindows) {
    doWhenWindowReady(() {
      appWindow.show();
    });
  }

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthenticationProvider()),
        ChangeNotifierProvider(create: (context) => ThemeProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(builder: (context, value, child) {
      return MaterialApp.router(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,

        // Dark Theme
        darkTheme: value.darkTheme,

        // Light Theme
        theme: value.lightTheme,
        builder: (context, child) {
          return AppToolbar(child: Portal(child: child!));
        },
        routerConfig: AppRouter.router,
      );
    });
  }
}
