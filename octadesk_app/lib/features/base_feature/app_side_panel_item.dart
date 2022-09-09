import 'package:flutter/material.dart';
import 'package:octadesk_app/resources/index.dart';

class AppSidePanelItem extends StatelessWidget {
  final String label;
  final String? trailing;
  final bool selected;
  final void Function()? onTap;
  const AppSidePanelItem({this.onTap, this.trailing, required this.label, required this.selected, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: AppSizes.s03),
      child: Material(
        borderRadius: BorderRadius.circular(AppSizes.s02),
        clipBehavior: Clip.hardEdge,
        color: selected ? AppColors.gray100 : Colors.transparent,
        child: InkWell(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: AppSizes.s04, vertical: AppSizes.s02_5),
            child: Opacity(
                opacity: selected ? 1 : .7,
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        label,
                        style: TextStyle(
                          fontSize: AppSizes.s03,
                          color: AppColors.gray800,
                          fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                        ),
                      ),
                    ),
                    if (trailing != null)
                      Text(
                        trailing!,
                        style: TextStyle(
                          fontSize: AppSizes.s03,
                          color: AppColors.gray800,
                          fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                        ),
                      )
                  ],
                )),
          ),
        ),
      ),
    );
  }
}
