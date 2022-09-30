import 'package:flutter/material.dart';
import 'package:octadesk_app/resources/index.dart';

class RecordButton extends StatelessWidget {
  final bool recording;
  final bool active;
  final void Function() onPressed;

  const RecordButton({required this.onPressed, this.recording = false, this.active = true, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(999),
      clipBehavior: Clip.hardEdge,
      child: InkWell(
        onTap: () => active ? onPressed() : () {},
        child: AnimatedOpacity(
          duration: const Duration(milliseconds: 300),
          opacity: active ? 1 : .7,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            width: AppSizes.s16,
            height: AppSizes.s16,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: recording ? Colors.red.shade500 : Colors.white,
              borderRadius: const BorderRadius.all(Radius.circular(AppSizes.s10)),
            ),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: AppSizes.s13,
              height: AppSizes.s13,
              decoration: BoxDecoration(
                color: recording ? Colors.red.shade500 : Colors.white,
                border: Border.all(color: recording ? Colors.white : Colors.black38),
                borderRadius: const BorderRadius.all(Radius.circular(AppSizes.s10)),
                boxShadow: const [BoxShadow(blurRadius: 10, color: Colors.black38)],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
