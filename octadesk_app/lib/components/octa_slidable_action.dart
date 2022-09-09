import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:octadesk_app/resources/index.dart';

class OctaSlidableAction extends StatelessWidget {
  final String icon;
  final void Function() onPressed;
  final double bottomPadding;
  const OctaSlidableAction({required this.icon, this.bottomPadding = AppSizes.s05, required this.onPressed, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Center(
        child: Padding(
          padding: EdgeInsets.only(bottom: bottomPadding),
          child: Container(
            clipBehavior: Clip.hardEdge,
            width: AppSizes.s09,
            height: AppSizes.s09,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(AppSizes.s05)),
              color: Colors.black54,
            ),
            child: GestureDetector(
              onTap: () {
                Slidable.of(context)?.close();
                onPressed();
              },
              child: Center(
                child: Image.asset(
                  icon,
                  width: AppSizes.s05,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
