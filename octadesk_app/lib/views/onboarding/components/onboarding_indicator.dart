import 'package:flutter/material.dart';
import 'package:octadesk_app/resources/index.dart';

class OnboardingIndicator extends StatefulWidget {
  final int length;
  final int currentIndex;

  const OnboardingIndicator({required this.length, required this.currentIndex, Key? key}) : super(key: key);

  @override
  State<OnboardingIndicator> createState() => _OnboardingIndicatorState();
}

class _OnboardingIndicatorState extends State<OnboardingIndicator> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        widget.length,
        (i) => AnimatedOpacity(
          opacity: i == widget.currentIndex ? 1 : .2,
          duration: const Duration(milliseconds: 300),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSizes.s00_5),
            child: Container(
              width: 6,
              height: 6,
              decoration: const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(3)), color: AppColors.gray800),
            ),
          ),
        ),
      ).toList(),
    );
  }
}
