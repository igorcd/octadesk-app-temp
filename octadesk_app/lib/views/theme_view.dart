import 'package:flutter/material.dart';
import 'package:octadesk_app/components/index.dart';
import 'package:octadesk_app/components/octa_select.dart';
import 'package:octadesk_app/providers/theme_provider.dart';
import 'package:octadesk_app/resources/app_colors.dart';
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

    Widget colorSwatch(AppColorSwatch swatch, void Function(AppColorSwatch value) onSelect) {
      var color = AppColors.getColor(swatch);

      return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            width: 60,
            height: 60,
            decoration: ShapeDecoration(
              gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [
                color.shade400,
                color.shade500,
              ]),
              shadows: const [
                BoxShadow(blurRadius: 6, color: Colors.black26, offset: Offset(0, 4)),
              ],
              shape: ContinuousRectangleBorder(
                borderRadius: BorderRadius.circular(30),
                side: BorderSide(
                  color: Theme.of(context).colorScheme.primary.value == color.value ? AppColors.info.shade800 : Colors.transparent,
                  width: 2,
                ),
              ),
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(onTap: () => onSelect(swatch)),
            ),
          ),
          const SizedBox(height: AppSizes.s03),
          OctaText.displaySmall(swatch.name),
        ],
      );
    }

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Container(
        constraints: const BoxConstraints.expand(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            FlutterLogo(
              size: 230,
              style: FlutterLogoStyle.stacked,
              textColor: Theme.of(context).colorScheme.onPrimaryContainer,
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
            SizedBox(
              width: 700,
              child: Wrap(
                runSpacing: 30,
                spacing: 30,
                runAlignment: WrapAlignment.center,
                alignment: WrapAlignment.center,
                children: [
                  colorSwatch(AppColorSwatch.amber, (value) => themeProvider.changeTheme(value)),
                  colorSwatch(AppColorSwatch.blue, (value) => themeProvider.changeTheme(value)),
                  colorSwatch(AppColorSwatch.danger, (value) => themeProvider.changeTheme(value)),
                  colorSwatch(AppColorSwatch.indigo, (value) => themeProvider.changeTheme(value)),
                  colorSwatch(AppColorSwatch.info, (value) => themeProvider.changeTheme(value)),
                  colorSwatch(AppColorSwatch.lime, (value) => themeProvider.changeTheme(value)),
                  colorSwatch(AppColorSwatch.news, (value) => themeProvider.changeTheme(value)),
                  colorSwatch(AppColorSwatch.orange, (value) => themeProvider.changeTheme(value)),
                  colorSwatch(AppColorSwatch.pink, (value) => themeProvider.changeTheme(value)),
                  colorSwatch(AppColorSwatch.purple, (value) => themeProvider.changeTheme(value)),
                  colorSwatch(AppColorSwatch.rose, (value) => themeProvider.changeTheme(value)),
                  colorSwatch(AppColorSwatch.success, (value) => themeProvider.changeTheme(value)),
                  colorSwatch(AppColorSwatch.teal, (value) => themeProvider.changeTheme(value)),
                  colorSwatch(AppColorSwatch.warning, (value) => themeProvider.changeTheme(value)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
