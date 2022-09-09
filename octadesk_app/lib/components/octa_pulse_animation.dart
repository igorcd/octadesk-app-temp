import 'package:flutter/material.dart';

class OctaPulseAnimation extends StatefulWidget {
  final Widget child;

  const OctaPulseAnimation({required this.child, Key? key}) : super(key: key);
  @override
  State<OctaPulseAnimation> createState() => _OctaPulseAnimationState();
}

class _OctaPulseAnimationState extends State<OctaPulseAnimation> with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 1000));
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
    _controller.repeat(reverse: true);
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: Tween<double>(begin: 0.5, end: 1).animate(_animation),
      child: widget.child,
    );
  }
}
