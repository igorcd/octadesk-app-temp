import 'package:flutter/material.dart';
import 'package:octadesk_app/resources/app_colors.dart';

class OctaDivider extends StatelessWidget {
  final bool vertical;
  const OctaDivider({this.vertical = false, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return vertical
        ? const VerticalDivider(
            width: 2,
            thickness: 2,
            color: AppColors.gray100,
          )
        : const Divider(
            height: 2,
            thickness: 2,
            color: AppColors.gray100,
          );
  }
}
