import 'package:flutter/material.dart';
import 'package:octadesk_app/components/index.dart';
import 'package:octadesk_app/components/responsive/responsive_widgets.dart';
import 'package:octadesk_app/resources/index.dart';
import 'package:octadesk_app/views/authentication/components/tenant_list_item.dart';
import 'package:octadesk_app/views/authentication/provider/authentication_view_provider.dart';
import 'package:provider/provider.dart';

class TenantSelectInclude extends StatelessWidget {
  const TenantSelectInclude({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var query = MediaQuery.of(context);
    var screenWidth = query.size.width;

    EdgeInsets calcListPadding() {
      if (screenWidth >= ScreenSize.xxl) {
        return const EdgeInsets.only(left: AppSizes.s16, right: AppSizes.s03);
      }
      if (screenWidth >= ScreenSize.lg) {
        return const EdgeInsets.only(left: AppSizes.s10, right: AppSizes.s03);
      }
      if (screenWidth >= ScreenSize.md) {
        return const EdgeInsets.symmetric(horizontal: AppSizes.s40);
      }
      return const EdgeInsets.symmetric(horizontal: AppSizes.s05);
    }

    return Consumer<AuthenticationViewProvider>(
      builder: (context, value, child) {
        return Column(
          children: [
            ResponsiveContainer(
              padding: Responsive(
                const EdgeInsets.only(top: AppSizes.s06, left: AppSizes.s05, right: AppSizes.s05),
                md: const EdgeInsets.only(top: AppSizes.s04, right: AppSizes.s40, left: AppSizes.s40),
                lg: const EdgeInsets.only(top: AppSizes.s18, right: AppSizes.s10, left: AppSizes.s10),
                xxl: const EdgeInsets.only(top: AppSizes.s18, right: AppSizes.s16, left: AppSizes.s16),
              ),
              child: Column(
                crossAxisAlignment: screenWidth > ScreenSize.lg ? CrossAxisAlignment.start : CrossAxisAlignment.stretch,
                children: [
                  //
                  // Logo
                  ResponsiveContainer(
                    margin: Responsive(
                      const EdgeInsets.only(bottom: AppSizes.s04),
                      lg: const EdgeInsets.only(bottom: AppSizes.s12),
                    ),
                    child: Transform.translate(
                      offset: const Offset(-AppSizes.s03, 0),
                      child: Row(
                        children: [
                          OctaIconButton(
                            onPressed: () => value.closeTenantSelect(),
                            icon: AppIcons.arrowBack,
                            iconSize: AppSizes.s06,
                            size: AppSizes.s10,
                          ),
                          const SizedBox(width: AppSizes.s01),
                          Expanded(
                            child: Image.asset(
                              AppImages.appLogo,
                              height: AppSizes.s09,
                              alignment: screenWidth > ScreenSize.lg ? Alignment.centerLeft : Alignment.center,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),

                  //
                  // Título
                  OctaText.headlineLarge(
                    "Junte-se a sua equipe",
                    textAlign: screenWidth > ScreenSize.lg ? TextAlign.left : TextAlign.center,
                  ),
                  const SizedBox(height: AppSizes.s02),

                  // Subtítulo
                  OctaText(
                    "Escolha um desses ambientes para entra",
                    textAlign: screenWidth > ScreenSize.lg ? TextAlign.left : TextAlign.center,
                  ),
                  const SizedBox(height: AppSizes.s06),
                ],
              ),
            ),

            // Conteúdo
            Expanded(
              //
              // Consumer
              child: ListView.separated(
                padding: calcListPadding(),
                separatorBuilder: (c, i) => const SizedBox(height: AppSizes.s03),
                itemBuilder: (c, i) {
                  //
                  // Referencia a tenant
                  var tenant = value.tenants[i];
                  return TenantListItem(label: tenant.name, onTap: () => value.selectTenant(context, tenant.id));
                },
                itemCount: value.tenants.length,
              ),
            ),
          ],
        );
      },
    );
  }
}
