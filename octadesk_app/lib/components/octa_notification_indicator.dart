import 'package:flutter/material.dart';
import 'package:octadesk_app/resources/index.dart';

class OctaNotificationIndicator extends StatefulWidget {
  const OctaNotificationIndicator({Key? key}) : super(key: key);

  @override
  State<OctaNotificationIndicator> createState() => _OctaNotificationIndicatorState();
}

class _OctaNotificationIndicatorState extends State<OctaNotificationIndicator> with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    _controller = AnimationController(vsync: this, duration: const Duration(seconds: 2))..repeat(reverse: false);
    _animation = CurvedAnimation(parent: _controller, curve: Curves.ease);

    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        FadeTransition(
          opacity: Tween<double>(begin: .8, end: 0).animate(_animation),
          child: ScaleTransition(
            scale: Tween<double>(begin: 1, end: 2).animate(_animation),
            child: Container(
              height: AppSizes.s01_5,
              width: AppSizes.s01_5,
              decoration: BoxDecoration(borderRadius: const BorderRadius.all(Radius.circular(AppSizes.s01_5)), color: AppColors.info.shade800),
            ),
          ),
        ),
        Container(
          height: AppSizes.s01_5,
          width: AppSizes.s01_5,
          decoration: BoxDecoration(borderRadius: const BorderRadius.all(Radius.circular(AppSizes.s01_5)), color: AppColors.info.shade800),
        ),
      ],
    );
  }
}
