import 'package:flutter/material.dart';
import 'package:octadesk_app/components/index.dart';
import 'package:octadesk_app/views/authentication/provider/authentication_view_provider.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../../components/responsive/responsive_widgets.dart';
import '../../../resources/index.dart';

class LoginInclude extends StatelessWidget {
  const LoginInclude({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var query = MediaQuery.of(context);
    var screenWidth = query.size.width;
    bool is2xsScreen = MediaQuery.of(context).size.height <= 640;

    return Consumer<AuthenticationViewProvider>(
      builder: (context, value, child) {
        return ResponsiveContainer(
          padding: Responsive(
            const EdgeInsets.symmetric(vertical: AppSizes.s06, horizontal: AppSizes.s05),
            xs: const EdgeInsets.symmetric(vertical: AppSizes.s06, horizontal: AppSizes.s05),
            md: const EdgeInsets.symmetric(horizontal: AppSizes.s40, vertical: AppSizes.s04),
            lg: const EdgeInsets.symmetric(vertical: AppSizes.s18, horizontal: AppSizes.s10),
            xxl: const EdgeInsets.symmetric(vertical: AppSizes.s18, horizontal: AppSizes.s16),
          ),
          child: Form(
            key: value.form,
            autovalidateMode: value.autoValidate ? AutovalidateMode.onUserInteraction : AutovalidateMode.disabled,
            child: Column(
              crossAxisAlignment: screenWidth > ScreenSize.lg ? CrossAxisAlignment.start : CrossAxisAlignment.stretch,
              children: [
                //
                // Logo
                ResponsiveContainer(
                  height: Responsive(AppSizes.s08, md: AppSizes.s09),
                  margin: Responsive(
                    const EdgeInsets.only(bottom: AppSizes.s04),
                    lg: const EdgeInsets.only(bottom: AppSizes.s12),
                  ),
                  child: Image.asset(
                    AppImages.appLogo,
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                  ),
                ),

                // Conteúdo
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: screenWidth > ScreenSize.lg ? CrossAxisAlignment.stretch : CrossAxisAlignment.center,
                    children: [
                      //
                      // Título
                      OctaText.headlineLarge(
                        "Que bom ver você aqui de novo",
                        textAlign: screenWidth > ScreenSize.lg ? TextAlign.left : TextAlign.center,
                      ),
                      const SizedBox(height: AppSizes.s02),

                      // Subtítulo
                      OctaText(
                        "Entre com a sua conta",
                        textAlign: screenWidth > ScreenSize.lg ? TextAlign.left : TextAlign.center,
                      ),
                      const SizedBox(height: AppSizes.s06),

                      // E-mail
                      OctaInput(
                        "E-mail",
                        hintText: "octavio@exemplo.com",
                        keyboardType: TextInputType.emailAddress,
                        nextNode: value.passwordFocusNode,
                        controller: value.emailController,
                        validators: const [AppValidators.notEmpty, AppValidators.email],
                        readOnly: value.loading,
                      ),
                      const SizedBox(height: AppSizes.s06),

                      // Senha
                      OctaInput(
                        "Senha",
                        hintText: "Digite sua senha",
                        isPassword: true,
                        focusNode: value.passwordFocusNode,
                        controller: value.passwordController,
                        onSubmit: () => value.authenticate(),
                        validators: const [AppValidators.notEmpty],
                        readOnly: value.loading,
                      ),
                      const SizedBox(height: AppSizes.s02),

                      // Versão
                      const Center(child: OctaAppVersion()),

                      // Registrar
                      SizedBox(height: is2xsScreen ? AppSizes.s02 : AppSizes.s10),
                      Row(
                        children: [
                          OctaText.labelSmall("Ainda não é cliente? "),
                          OctaTextButton(
                            onPressed: () async => await launchUrlString('https://octadesk.com', mode: LaunchMode.externalApplication),
                            text: "Crie sua conta",
                          ),
                        ],
                      )
                    ],
                  ),
                ),

                // Botão de submeter
                OctaButton(
                  text: "Entrar",
                  onTap: () => value.authenticate(),
                  loading: value.loading,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
