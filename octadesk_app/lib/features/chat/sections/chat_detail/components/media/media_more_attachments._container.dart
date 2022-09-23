import 'package:flutter/material.dart';
import 'package:octadesk_app/resources/index.dart';

class MediaMoreAttachmentsContainer extends StatelessWidget {
  const MediaMoreAttachmentsContainer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Image.asset(AppIcons.attach, width: AppSizes.s12),
        const SizedBox(height: AppSizes.s02),
        const Text(
          "Mais 2 anexos",
          textAlign: TextAlign.center,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: AppSizes.s03_5),
        )
      ],
    );
  }
}
