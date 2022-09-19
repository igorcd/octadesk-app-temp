import 'package:flutter/material.dart';
import 'package:octadesk_app/providers/authentication_provider.dart';
import 'package:octadesk_app/resources/app_colors.dart';
import 'package:octadesk_app/router/features_router.dart';
import 'package:provider/provider.dart';

class MainView extends StatelessWidget {
  const MainView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var authenticationProvider = Provider.of<AuthenticationProvider>(context, listen: false);

    return FutureBuilder(
      future: authenticationProvider.checkUserStatusAndInitializeChat(),
      builder: (context, snapshot) {
        // Em caso de erro
        if (snapshot.hasError) {
          return Scaffold(
            body: Center(
              child: Text(snapshot.error.toString()),
            ),
          );
        }

        // Loading
        if (snapshot.connectionState != ConnectionState.done) {
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(color: AppColors.blue),
            ),
          );
        }

        // Conteúdo
        return Navigator(
          key: FeaturesRouter.featuresNavigator,
          onGenerateRoute: FeaturesRouter.controller,
          initialRoute: FeaturesRouter.chatModule,
        );
      },
    );
  }
}
