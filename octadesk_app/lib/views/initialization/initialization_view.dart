import 'package:flutter/material.dart';
import 'package:octadesk_app/components/octa_pulse_animation.dart';
import 'package:octadesk_app/providers/authentication_provider.dart';
import 'package:octadesk_app/resources/app_images.dart';
import 'package:octadesk_app/resources/app_sizes.dart';
import 'package:provider/provider.dart';

class InitializationView extends StatefulWidget {
  const InitializationView({Key? key}) : super(key: key);

  @override
  State<InitializationView> createState() => _InitializationViewState();
}

class _InitializationViewState extends State<InitializationView> {
  @override
  void initState() {
    super.initState();
    Provider.of<AuthenticationProvider>(context, listen: false).initializeApplication(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: OctaPulseAnimation(
          child: Image.asset(
            AppImages.appLogoSplash,
            width: AppSizes.s30,
          ),
        ),
      ),
    );
  }
}
