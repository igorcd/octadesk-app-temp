import 'package:flutter/material.dart';
import 'package:octadesk_app/resources/app_colors.dart';
import 'package:octadesk_app/resources/app_sizes.dart';
import 'package:octadesk_app/utils/helper_functions.dart';

class ConversationHistoryButton extends StatelessWidget {
  final DateTime date;
  final void Function() onTap;
  const ConversationHistoryButton({required this.date, required this.onTap, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppSizes.s02),
        border: Border.all(color: AppColors.gray200),
      ),
      child: Material(
        borderRadius: BorderRadius.circular(AppSizes.s02),
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(AppSizes.s03),
            child: Text(
              dateTimeFormatterHelper().format(date),
              style: const TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 13,
                color: AppColors.gray500,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
