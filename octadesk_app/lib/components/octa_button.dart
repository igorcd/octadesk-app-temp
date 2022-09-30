import 'package:flutter/material.dart';
import 'package:octadesk_app/resources/index.dart';

class OctaButton extends StatelessWidget {
  final void Function() onTap;
  final String text;
  final bool loading;
  final double? width;
  final bool disabled;
  final bool outline;

  const OctaButton({
    required this.onTap,
    required this.text,
    this.loading = false,
    this.disabled = false,
    this.outline = false,
    this.width,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var backgroundColor = Theme.of(context).colorScheme.primary;

    Widget renderContent() {
      return loading
          ? SizedBox(
              width: AppSizes.s05,
              height: AppSizes.s05,
              child: CircularProgressIndicator(
                color: outline ? backgroundColor : Colors.white,
                strokeWidth: 3,
              ),
            )
          : Text(
              text,
              style: TextStyle(
                fontSize: AppSizes.s04,
                fontFamily: "NotoSans",
                color: outline ? backgroundColor : Colors.white,
                fontWeight: FontWeight.bold,
              ),
            );
    }

    // Tratar clique quando o botão estiver desabilitado
    return IgnorePointer(
      ignoring: disabled || loading,

      // Controlar opacidade do botão
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 300),
        opacity: disabled ? .3 : 1,

        // Container principal
        child: Container(
          height: AppSizes.s12,
          width: width,
          //
          // Estilização
          decoration: BoxDecoration(
            color: outline ? Colors.transparent : backgroundColor,
            borderRadius: const BorderRadius.all(Radius.circular(AppSizes.s02_5)),
            border: outline ? Border.all(color: backgroundColor) : null,
          ),

          // Conteúdo
          child: Material(
            color: Colors.transparent,
            //
            child: InkWell(
              onTap: onTap,
              child: Center(
                child: renderContent(),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
