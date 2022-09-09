import 'package:flutter/material.dart';
import 'package:octadesk_app/components/octa_text.dart';
import 'package:octadesk_app/resources/index.dart';

class TenantListItem extends StatelessWidget {
  final String label;
  final void Function() onTap;
  const TenantListItem({required this.label, required this.onTap, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: AppSizes.s12,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: AppSizes.s04),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppSizes.s02),
              border: Border.all(color: AppColors.gray300),
            ),
            child: OctaText(
              label,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
      ),
    );
  }
}
