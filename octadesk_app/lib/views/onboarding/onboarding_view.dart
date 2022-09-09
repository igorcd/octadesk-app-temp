import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:octadesk_app/components/responsive/responsive_positioned.dart';
import 'package:octadesk_app/components/responsive/responsive_widgets.dart';
import 'package:octadesk_app/resources/index.dart';
import 'package:octadesk_app/router/public_router.dart';
import 'package:octadesk_app/toolbar/app_toolbar.dart';
import 'package:octadesk_app/views/onboarding/components/onboarding_indicator.dart';
import 'package:octadesk_app/views/onboarding/includes/onboarding_page_one.dart';
import 'package:octadesk_app/views/onboarding/includes/onboarding_page_three.dart';
import 'package:octadesk_app/views/onboarding/includes/onboarding_page_two.dart';
import 'package:url_launcher/url_launcher_string.dart';

class OnboardingView extends StatefulWidget {
  const OnboardingView({Key? key}) : super(key: key);

  @override
  State<OnboardingView> createState() => _OnboardingViewState();
}

class _OnboardingViewState extends State<OnboardingView> {
  final _controller = PageController(initialPage: 0);
  int currentPage = 0;

  @override
  Widget build(BuildContext context) {
    var insets = MediaQuery.of(context).padding;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarBrightness: Brightness.dark,
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          //
          // Container Principal
          child: Container(
            padding: EdgeInsets.only(top: insets.top + AppSizes.s04, bottom: insets.bottom),
            height: MediaQuery.of(context).size.height - kAppToolbarHeight,
            constraints: const BoxConstraints(minHeight: 550),

            // Container interno
            child: Stack(
              children: [
                //
                // Carrossel
                Positioned.fill(
                  child: PageView(
                    onPageChanged: (page) {
                      setState(() {
                        currentPage = page;
                      });
                    },
                    controller: _controller,
                    children: [
                      // Primeira pagina do onboarding
                      OnboardingPageOne(
                        onClickNext: () => _controller.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.ease),
                      ),

                      // Segunda página do onboarding
                      OnboardingPageTwo(
                        onClickNext: () => _controller.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.ease),
                        onClickPrev: () => _controller.previousPage(duration: const Duration(milliseconds: 300), curve: Curves.ease),
                      ),

                      // Terceira página do onboarding
                      OnboardingPageThree(
                        register: () async => await launchUrlString('https://octadesk.com', mode: LaunchMode.externalApplication),
                        login: () => Navigator.pushNamed(context, PublicRouter.authenticationView),
                      ),
                    ],
                  ),
                ),

                Center(
                  child: Container(
                    width: double.infinity,
                    constraints: const BoxConstraints(maxHeight: 650, maxWidth: 450),
                    child: Stack(
                      children: [
                        //
                        // Logo
                        Align(
                          alignment: Alignment.topCenter,
                          child: Image.asset(
                            AppImages.appLogo,
                            height: AppSizes.s10,
                          ),
                        ),

                        // Indicadores
                        ResponsivePositioned(
                          bottom: Responsive(AppSizes.s35, xs: AppSizes.s30),
                          right: Responsive(0),
                          left: Responsive(0),
                          child: OnboardingIndicator(
                            currentIndex: currentPage,
                            length: 3,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
