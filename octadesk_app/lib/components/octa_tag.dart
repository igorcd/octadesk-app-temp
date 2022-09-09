import 'package:flutter/material.dart';
import 'package:octadesk_app/resources/index.dart';

class OctaTag extends StatelessWidget {
  final bool active;
  final String placeholder;
  final void Function() onPressed;
  final String icon;

  const OctaTag({this.active = false, required this.onPressed, required this.placeholder, this.icon = AppIcons.times, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return UnconstrainedBox(
      // Conteúdo principal
      child: Container(
        clipBehavior: Clip.hardEdge,
        height: AppSizes.s07,
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(AppSizes.s04)),
          border: Border.all(color: active ? AppColors.blue400 : AppColors.gray200, width: 1.5),
          color: active ? AppColors.blue400.withOpacity(.05) : AppColors.gray200,
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onPressed,
            child: Padding(
              padding: const EdgeInsets.only(left: AppSizes.s02_5, right: AppSizes.s02),
              child: Row(
                children: [
                  Text(
                    placeholder,
                    style: TextStyle(
                      color: active ? AppColors.blue400 : AppColors.gray500,
                      fontSize: AppSizes.s03_5,
                      height: 1,
                    ),
                  ),
                  Image.asset(
                    icon,
                    width: AppSizes.s04,
                    color: active ? AppColors.blue400 : AppColors.gray500,
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
