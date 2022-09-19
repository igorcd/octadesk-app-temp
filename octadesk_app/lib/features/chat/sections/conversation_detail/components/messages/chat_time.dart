import 'package:flutter/material.dart';
import 'package:octadesk_app/resources/index.dart';
import 'package:octadesk_app/utils/helper_functions.dart';

class ChatTime extends StatelessWidget {
  final DateTime time;
  const ChatTime(this.time, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSizes.s02),
      child: Row(
        children: [
          Expanded(
            child: Divider(
              color: AppColors.info.shade200,
              indent: AppSizes.s04,
            ),
          ),
          Text(
            dateFormatterHelper(time).toUpperCase(),
            style: const TextStyle(fontFamily: "Poppins", fontWeight: FontWeight.w600, fontSize: AppSizes.s03),
          ),
          Expanded(
              child: Divider(
            color: AppColors.info.shade200,
            endIndent: AppSizes.s04,
          )),
        ],
      ),
    );
  }
}
