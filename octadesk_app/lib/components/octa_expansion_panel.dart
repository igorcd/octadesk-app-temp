import 'package:flutter/material.dart';
import 'package:octadesk_app/components/index.dart';
import 'package:octadesk_app/resources/app_icons.dart';
import 'package:octadesk_app/resources/app_sizes.dart';

class OctaExpansionPanel extends StatefulWidget {
  final String title;
  final Widget content;
  final bool isOpened;
  const OctaExpansionPanel({required this.title, required this.content, required this.isOpened, Key? key}) : super(key: key);

  @override
  State<OctaExpansionPanel> createState() => _OctaExpansionPanelState();
}

class _OctaExpansionPanelState extends State<OctaExpansionPanel> with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 150));
    _animation = CurvedAnimation(parent: _controller, curve: Curves.ease);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () => _controller.value == 1 ? _controller.reverse() : _controller.forward(),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: AppSizes.s04),
              height: AppSizes.s12,
              child: Row(
                children: [
                  Expanded(
                    child: OctaText.bodyLarge(widget.title),
                  ),
                  RotationTransition(
                    turns: Tween<double>(begin: 0, end: .5).animate(_animation),
                    child: Image.asset(AppIcons.angleDown, width: AppSizes.s06),
                  ),
                ],
              ),
            ),
          ),
        ),
        SizeTransition(
          sizeFactor: _animation,
          child: widget.content,
        )
      ],
    );
  }
}
