import 'package:flutter/material.dart';
import 'package:octadesk_app/components/index.dart';
import 'package:octadesk_app/resources/index.dart';

class NoContactSelected extends StatelessWidget {
  const NoContactSelected({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.s08),
        child: OctaText.headlineLarge(
          "Selecione um contato",
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
