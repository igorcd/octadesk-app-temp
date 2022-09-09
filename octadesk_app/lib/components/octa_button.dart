import 'package:flutter/material.dart';
import 'package:octadesk_app/resources/index.dart';

enum ButtonStyleEnum {
  primary,
  secondary,
  hollow,
}

class OctaButton extends StatelessWidget {
  final void Function() onPressed;
  final bool disabled;
  final bool loading;
  final String text;
  final ButtonStyleEnum type;

  const OctaButton({
    required this.onPressed,
    required this.text,
    this.type = ButtonStyleEnum.primary,
    this.loading = false,
    this.disabled = false,
    Key? key,
  }) : super(key: key);

  Widget _renderContent() {
    return loading
        ? const SizedBox(
            width: AppSizes.s05,
            height: AppSizes.s05,
            child: CircularProgressIndicator(
              color: Colors.white,
              strokeWidth: 3,
            ),
          )
        : Text(
            text,
            style: TextStyle(
              fontSize: AppSizes.s04,
              fontFamily: "NotoSans",
              color: disabled || type == ButtonStyleEnum.secondary || type == ButtonStyleEnum.hollow ? AppColors.blue400 : Colors.white,
              fontWeight: FontWeight.bold,
            ),
          );
  }

  @override
  Widget build(BuildContext context) {
    var is2xsScreenHelper = MediaQuery.of(context).size.height <= 640;

    // Tratar clique quando o botão estiver desabilitado
    return IgnorePointer(
      ignoring: disabled || loading,

      // Controlar opacidade do botão
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 300),
        opacity: disabled ? .3 : 1,

        // Container principal
        child: Container(
          height: is2xsScreenHelper ? AppSizes.s09 : AppSizes.s12,
          //
          // Estilização
          decoration: BoxDecoration(
            border: Border.all(color: type == ButtonStyleEnum.hollow ? Colors.white : AppColors.blue500, width: 1),
            color: disabled || type == ButtonStyleEnum.secondary || type == ButtonStyleEnum.hollow ? Colors.white : AppColors.blue500,
            borderRadius: const BorderRadius.all(Radius.circular(AppSizes.s02_5)),
          ),

          // Conteúdo
          child: Material(
            color: Colors.transparent,
            //
            child: InkWell(
              splashColor: type == ButtonStyleEnum.primary ? AppColors.blue600 : AppColors.gray100,
              onTap: onPressed,
              child: Center(
                child: _renderContent(),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
