import 'package:flutter/material.dart';
import 'package:octadesk_app/resources/index.dart';

class OctaRadioListTile<T> extends StatelessWidget {
  final T groupValue;
  final T value;
  final String label;
  final void Function(T value) onSelect;
  bool get selected => groupValue == value;

  const OctaRadioListTile({required this.label, required this.groupValue, required this.value, required this.onSelect, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;

    return Material(
      color: Colors.transparent,

      // Evento de clique
      child: InkWell(
        onTap: () => onSelect(value),

        // Container principal
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: AppSizes.s05),
          height: AppSizes.s14,
          child: Row(
            children: [
              // Label
              Expanded(
                child: Text(
                  label,
                  style: const TextStyle(fontFamily: "Poppins", fontSize: AppSizes.s04_5, fontWeight: FontWeight.w500),
                ),
              ),

              // Circulo do Radio
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                width: AppSizes.s07,
                height: AppSizes.s07,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(AppSizes.s03_5)),
                  color: selected ? colorScheme.primary : colorScheme.surface,
                  border: Border.all(color: selected ? colorScheme.primary : colorScheme.outline, width: 3),
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
            ],
          ),
        ),
      ),
    );
  }
}
