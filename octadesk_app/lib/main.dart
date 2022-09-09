import 'dart:io';
import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:octadesk_app/providers/authentication_provider.dart';
import 'package:octadesk_app/resources/index.dart';
import 'package:octadesk_app/router/public_router.dart';
import 'package:octadesk_app/toolbar/app_toolbar.dart';
import 'package:octadesk_core/enums/octa_environment_enum.dart';
import 'package:octadesk_services/octadesk_services.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setEnvironment(environment: OctaEnvironmentEnum.qa);
  initializeDateFormatting('pt_BR', null);

  if (Platform.isWindows) {
    doWhenWindowReady(() {
      appWindow.show();
    });
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthenticationProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          fontFamily: "NotoSans",
          textTheme: const TextTheme(
            displayMedium: TextStyle(
              fontFamily: "Poppins",
              fontWeight: FontWeight.w600,
              letterSpacing: -1,
              height: 1.2,
              fontSize: 22,
              color: AppColors.gray800,
            ),
            displaySmall: TextStyle(
              fontFamily: "Poppins",
              fontWeight: FontWeight.w600,
              letterSpacing: -1,
              height: 1.1,
              fontSize: AppSizes.s04_5,
              color: AppColors.gray800,
            ),

            // Headline Small
            headlineLarge: TextStyle(
              fontFamily: "Poppins",
              fontWeight: FontWeight.w600,
              letterSpacing: -1,
              height: 1.1,
              fontSize: AppSizes.s06,
              color: AppColors.gray800,
            ),
            headlineMedium: TextStyle(
              fontFamily: "Poppins",
              fontWeight: FontWeight.w500,
              color: AppColors.gray800,
              fontSize: AppSizes.s06,
            ),
            headlineSmall: TextStyle(
              fontFamily: "Poppins",
              fontWeight: FontWeight.bold,
              color: AppColors.gray800,
              fontSize: AppSizes.s04,
            ),

            titleMedium: TextStyle(
              fontFamily: "Poppins",
              fontWeight: FontWeight.bold,
              fontSize: AppSizes.s03_5,
              color: AppColors.gray800,
            ),
            titleSmall: TextStyle(
              color: AppColors.gray600,
              fontSize: AppSizes.s03,
            ),

            // Label Medium
            labelMedium: TextStyle(
              fontSize: AppSizes.s03,
              color: AppColors.gray800,
              fontWeight: FontWeight.w500,
            ),
            labelSmall: TextStyle(
              fontSize: AppSizes.s03,
              color: AppColors.gray800,
              fontWeight: FontWeight.normal,
              letterSpacing: 0,
            ),
            bodyLarge: TextStyle(
              fontFamily: "Poppins",
              fontWeight: FontWeight.w600,
              fontSize: AppSizes.s04,
              color: AppColors.gray800,
            ),
            bodyMedium: TextStyle(
              fontSize: AppSizes.s04,
              color: AppColors.gray800,
            ),
            bodySmall: TextStyle(
              fontSize: AppSizes.s03_5,
              color: AppColors.gray600,
            ),
          ),
        ),
        home: AppToolbar(
          child: Navigator(
            key: PublicRouter.navigator,
            initialRoute: PublicRouter.initializationView,
            onGenerateRoute: PublicRouter.controller,
            // Controlador de rotas
          ),
        ),
      ),
    );
  }
}
