import 'package:flutter/material.dart';
import 'package:octadesk_app/components/octa_text.dart';
import 'package:octadesk_app/resources/index.dart';

class OctaEmptySliver extends StatelessWidget {
  final String text;
  const OctaEmptySliver({required this.text, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Container(
        alignment: Alignment.center,
        height: AppSizes.s18,
        child: OctaText(text),
      ),
    );
  }
}
