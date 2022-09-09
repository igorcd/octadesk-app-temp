import 'package:flutter/material.dart';
import 'package:octadesk_app/components/index.dart';
import 'package:octadesk_app/resources/index.dart';

class OctaSelectListItem extends StatelessWidget {
  final void Function() onPressed;
  final String title;
  const OctaSelectListItem({required this.onPressed, required this.title, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: AppSizes.s16,
      child: Column(
        children: [
          Expanded(
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: onPressed,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: AppSizes.s05),
                  height: AppSizes.s16,
                  child: Row(
                    children: [
                      Expanded(
                        child: OctaText.bodyLarge(title),
                      ),
                      Image.asset(AppIcons.angleRight, width: AppSizes.s05)
                    ],
                  ),
                ),
              ),
            ),
          ),
          const Divider(height: 1, thickness: 1),
        ],
      ),
    );
  }
}
