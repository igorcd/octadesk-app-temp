import 'package:flutter/material.dart';
import 'package:octadesk_app/resources/index.dart';

class OctaInput extends StatefulWidget {
  final String label;
  final String hintText;
  final TextInputType keyboardType;
  final FocusNode? focusNode;
  final FocusNode? nextNode;
  final bool captalize;
  final List<String? Function(String value)>? validators;
  final bool isPassword;
  final bool readOnly;
  final TextEditingController? controller;
  final Function? onSubmit;

  const OctaInput(
    this.label, {
    this.hintText = '',
    this.keyboardType = TextInputType.text,
    this.focusNode,
    this.nextNode,
    this.captalize = false,
    this.validators,
    this.isPassword = false,
    this.readOnly = false,
    this.controller,
    this.onSubmit,
    Key? key,
  }) : super(key: key);

  @override
  State<OctaInput> createState() => _OctaInputState();
}

class _OctaInputState extends State<OctaInput> {
  // State
  bool _inFocus = false;
  String _error = "";

  Color _renderBorderColor() {
    if (_inFocus) {
      return AppColors.blue;
    }

    if (_error.isNotEmpty) {
      return AppColors.warning;
    }

    return AppColors.info.shade200;
  }

  @override
  Widget build(BuildContext context) {
    var is2xsScreenHelper = MediaQuery.of(context).size.height <= 640;

    /// Função de renderização do TextField
    Widget renderTextField() {
      return TextFormField(
        decoration: InputDecoration(
          // Estilo do placeholder
          hintStyle: TextStyle(
            fontWeight: FontWeight.w300,
            fontFamily: 'NotoSans',
            color: AppColors.info.shade300,
          ),
          errorStyle: const TextStyle(height: 0),
          border: InputBorder.none,
          hintText: widget.hintText,
          isDense: true,
          contentPadding: is2xsScreenHelper
              ? const EdgeInsets.symmetric(horizontal: AppSizes.s02_5, vertical: AppSizes.s02)
              : const EdgeInsets.symmetric(horizontal: AppSizes.s03_5, vertical: AppSizes.s03),
        ),
        focusNode: widget.focusNode,
        controller: widget.controller,
        keyboardType: widget.keyboardType,
        textCapitalization: widget.captalize ? TextCapitalization.sentences : TextCapitalization.none,
        textInputAction: widget.nextNode != null ? TextInputAction.next : TextInputAction.done,

        style: TextStyle(
          fontFamily: "NotoSans",
          fontWeight: FontWeight.normal,
          fontSize: is2xsScreenHelper ? AppSizes.s04 * 0.875 : AppSizes.s04,
          color: AppColors.info.shade800,
        ),
        onFieldSubmitted: (_) {
          if (widget.nextNode != null) {
            FocusScope.of(context).requestFocus(widget.nextNode);
          } else if (widget.onSubmit != null) {
            widget.onSubmit!();
          }
        },
        readOnly: widget.readOnly,
        obscureText: widget.isPassword,

        // Valiação
        validator: (value) {
          if (widget.validators != null) {
            String? validationError;
            for (var element in widget.validators!) {
              validationError = validationError ??= element(widget.controller?.text ?? value ?? "");
            }

            setState(() {
              _error = validationError ?? "";
            });

            return validationError != null ? "" : null;
          }

          return null;
        },
      );
    }

    return Focus(
      onFocusChange: (hasFocus) => setState(() {
        _inFocus = hasFocus;
        if (hasFocus) {
          widget.focusNode?.requestFocus();
        }
      }),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          //
          // Label
          Text(
            widget.label,
            style: TextStyle(fontFamily: "NotoSans", fontSize: AppSizes.s03, color: AppColors.info.shade800),
          ),
          const SizedBox(
            height: AppSizes.s01,
          ),

          // Container do input
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.ease,
            //
            // Estilo
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(
                width: 2,
                color: _renderBorderColor(),
              ),
              borderRadius: const BorderRadius.all(Radius.circular(AppSizes.s02_5)),
              boxShadow: [
                BoxShadow(
                  color: _inFocus ? AppColors.blue.shade400 : Colors.transparent,
                  blurRadius: 3,
                  offset: const Offset(0, 0),
                ),
              ],
            ),

            // Input
            child: renderTextField(),
          ),
          _error.isNotEmpty
              ? Text(
                  _error,
                  style: TextStyle(fontSize: AppSizes.s03, fontWeight: FontWeight.w500, color: AppColors.warning, fontFamily: "NotoSans"),
                )
              : const SizedBox.shrink()
        ],
      ),
    );
  }
}
