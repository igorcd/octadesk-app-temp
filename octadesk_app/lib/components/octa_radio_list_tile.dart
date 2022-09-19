import 'package:flutter/material.dart';
import 'package:octadesk_app/components/octa_text.dart';
import 'package:octadesk_app/resources/index.dart';

class OctaRadioListTile<T> extends StatelessWidget {
  final T groupValue;
  final T value;
  final String label;
  final Widget? child;
  final void Function(T value) onSelect;
  bool get selected => groupValue == value;

  const OctaRadioListTile({this.label = "", this.child, required this.groupValue, required this.value, required this.onSelect, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,

      // Evento de clique
      child: InkWell(
        onTap: () => onSelect(value),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: AppSizes.s05),
          height: AppSizes.s16,
          child: Row(
            children: [
              // Circulo do Radio
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                width: AppSizes.s07,
                height: AppSizes.s07,
                decoration: BoxDecoration(
                  boxShadow: const [AppShadows.s100],
                  borderRadius: const BorderRadius.all(Radius.circular(AppSizes.s03_5)),
                  color: selected ? AppColors.blue.shade400 : Colors.white,
                  border: Border.all(color: selected ? AppColors.blue.shade400 : AppColors.info.shade200, width: 2),
                ),
                child: Center(
                  child: AnimatedScale(
                    duration: const Duration(milliseconds: 300),
                    scale: selected ? 1 : 0,
                    curve: Curves.bounceOut,
                    child: Container(
                      width: AppSizes.s04_5,
                      height: AppSizes.s04_5,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(AppSizes.s02)),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: AppSizes.s02_5),

              // Label
              child ?? OctaText.bodyLarge(label),
            ],
          ),
        ),
      ),
    );
  }
}
