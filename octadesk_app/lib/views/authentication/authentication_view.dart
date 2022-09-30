import 'package:flutter/material.dart';
import 'package:octadesk_app/providers/authentication_provider.dart';
import 'package:octadesk_app/resources/app_illustrations.dart';
import 'package:octadesk_app/resources/app_sizes.dart';
import 'package:octadesk_app/toolbar/app_toolbar.dart';
import 'package:octadesk_app/views/authentication/includes/login_include.dart';
import 'package:octadesk_app/views/authentication/includes/tenant_select_include.dart';
import 'package:octadesk_app/views/authentication/provider/authentication_view_provider.dart';
import 'package:provider/provider.dart';

import '../../components/responsive/responsive_widgets.dart';

class AuthenticationView extends StatelessWidget {
  const AuthenticationView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Controle da tela
    var query = MediaQuery.of(context);
    var top = query.padding.top;
    var bottom = query.padding.bottom;
    var screenHeight = query.size.height - bottom - top - kAppToolbarHeight;
    var colorScheme = Theme.of(context).colorScheme;

    return ChangeNotifierProvider(
      create: (context) => AuthenticationViewProvider(context, Provider.of<AuthenticationProvider>(context, listen: false)),
      child: Scaffold(
        backgroundColor: colorScheme.surface,
        body: SafeArea(
          child: SingleChildScrollView(
            //
            // Manter tamanho mínimo da tela
            child: ConstrainedBox(
              constraints: const BoxConstraints(minHeight: 500),
              child: SizedBox(
                height: screenHeight,
                child: Stack(
                  children: [
                    //
                    // Imagem
                    Align(
                      alignment: Alignment.centerRight,
                      child: Padding(
                        padding: const EdgeInsets.only(right: AppSizes.s20),
                        child: SizedBox(
                          width: 500,
                          child: Image.asset(
                            AppIllustrations.illustrationLogin,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ),

                    // Formulário
                    Align(
                      alignment: Alignment.centerLeft,
                      child: ResponsiveContainer(
                        decoration: Responsive(BoxDecoration(color: colorScheme.surface)),
                        constraints: const BoxConstraints(maxHeight: 750),
                        width: Responsive(double.infinity, lg: 505, xxl: 550),
                        margin: Responsive(
                          EdgeInsets.zero,
                          lg: const EdgeInsets.only(left: AppSizes.s10),
                          xl: const EdgeInsets.only(left: AppSizes.s20),
                        ),
                        child: Consumer<AuthenticationViewProvider>(
                          builder: (context, value, child) {
                            //
                            // Conteúdo
                            return AnimatedSwitcher(
                              transitionBuilder: (child, animation) {
                                return FadeTransition(
                                  opacity: animation,
                                  child: ScaleTransition(
                                    scale: Tween<double>(begin: .95, end: 1).animate(animation),
                                    child: child,
                                  ),
                                );
                              },
                              duration: const Duration(milliseconds: 300),
                              switchInCurve: const Interval(0.5, 1, curve: Curves.ease),
                              switchOutCurve: const Interval(0.5, 1, curve: Curves.ease),
                              child: value.tenantSelectOpened ? const TenantSelectInclude() : const LoginInclude(),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
