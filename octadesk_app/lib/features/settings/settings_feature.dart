import 'package:flutter/material.dart';
import 'package:octadesk_app/components/octa_text.dart';
import 'package:octadesk_app/providers/theme_provider.dart';
import 'package:octadesk_app/resources/index.dart';
import 'package:provider/provider.dart';

class SettingsFeature extends StatelessWidget {
  const SettingsFeature({super.key});

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
                  color: themeProvider.primarySwatch.shade500.value == color.shade500.value ? AppColors.info.shade800 : Colors.transparent,
                  width: 4,
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

    return Container(
      alignment: Alignment.center,
      child: SizedBox(
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
    );
  }
}
