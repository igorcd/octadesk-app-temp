import 'package:flutter/material.dart';
import 'package:octadesk_app/components/octa_toogle.dart';
import 'package:octadesk_app/resources/index.dart';

class OctaToogleButton extends StatelessWidget {
  final bool active;
  final void Function(bool active) onChange;

  const OctaToogleButton({required this.active, required this.onChange, super.key});

  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;

    // Container principal
    return Container(
      width: AppSizes.s40,
      height: AppSizes.s13,
      decoration: BoxDecoration(
        border: Border.all(width: 2, color: colorScheme.outline),
        borderRadius: BorderRadius.circular(AppSizes.s02),
      ),
      clipBehavior: Clip.hardEdge,

      // Botão
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => onChange(!active),
          child: AnimatedOpacity(
            duration: const Duration(milliseconds: 150),
            opacity: active ? 1 : .6,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Ativo
                SizedBox(
                  width: 58,
                  child: Text(
                    active ? "Ativo" : "Inativo",
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
                OctaToogle(
                  active: active,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
