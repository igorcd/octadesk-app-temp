import 'package:flutter/material.dart';
import 'package:octadesk_app/components/index.dart';
import 'package:octadesk_app/components/octa_select.dart';
import 'package:octadesk_app/providers/theme_provider.dart';
import 'package:octadesk_app/resources/app_colors.dart';
import 'package:octadesk_app/resources/app_images.dart';
import 'package:octadesk_app/resources/app_sizes.dart';
import 'package:octadesk_app/utils/helper_functions.dart';
import 'package:provider/provider.dart';

class ThemeView extends StatefulWidget {
  const ThemeView({super.key});

  @override
  State<ThemeView> createState() => _ThemeViewState();
}

class _ThemeViewState extends State<ThemeView> {
  @override
  Widget build(BuildContext context) {
    ThemeProvider themeProvider = Provider.of(context);

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Container(
        constraints: const BoxConstraints.expand(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              AppImages.appLogoIcon,
              height: 150,
              color: Theme.of(context).colorScheme.onPrimaryContainer,
            ),
            const SizedBox(height: 20),
            Image.asset(
              AppImages.appLogoText,
              height: 30,
              color: Theme.of(context).colorScheme.onPrimaryContainer,
            ),
            const SizedBox(height: AppSizes.s10),
            SizedBox(
              width: 500,
              child: OctaText(
                l10n(context).helloWorld,
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: AppSizes.s10),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 250,
                  child: OctaButton(onTap: () {}, text: "Botão primário"),
                ),
                const SizedBox(width: 20),
                SizedBox(
                  width: 250,
                  child: OctaSelect<DarkModeType>(
                    label: "Modo do Dark Mode",
                    values: [
                      OctaSelectItem(value: DarkModeType.byOperatingSystem, text: "Definido pelo sistema operacional"),
                      OctaSelectItem(value: DarkModeType.light, text: "Claro"),
                      OctaSelectItem(value: DarkModeType.dark, text: "Escuro"),
                    ],
                    value: DarkModeType.byOperatingSystem,
                    onChanged: (value) => themeProvider.setDarkModeTIme(value!),
                    hint: "Selecione um tipo",
                  ),
                ),
              ],
            ),
            const SizedBox(
              width: 500,
              child: Divider(height: 50),
            ),
          ],
        ),
      ),
    );
  }
}
