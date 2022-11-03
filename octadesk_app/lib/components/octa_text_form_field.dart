import 'package:easy_mask/easy_mask.dart';
import 'package:flutter/material.dart';
import 'package:octadesk_app/resources/index.dart';

class OctaTextFormField extends StatelessWidget {
  final GlobalKey<FormFieldState>? inputKey;
  final FocusNode? focusNode;
  final TextEditingController? controller;
  final List<String>? masks;
  final Widget? prefix;
  final String? hintText;
  final void Function(String value)? onChange;
  final List<String? Function(String value)>? validators;
  final void Function(String value)? onValidate;
  final String? prefixText;
  final TextInputType? keyboardType;

  const OctaTextFormField({
    this.inputKey,
    this.masks,
    this.focusNode,
    this.controller,
    this.prefix,
    this.hintText,
    this.onChange,
    this.validators,
    this.onValidate,
    this.prefixText,
    this.keyboardType,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;

    return TextFormField(
      key: inputKey,
      keyboardType: keyboardType,
      inputFormatters: masks != null ? [TextInputMask(mask: masks)] : null,
      focusNode: focusNode,
      controller: controller,
      // controller: widget.controller,
      style: TextStyle(
        fontSize: AppSizes.s04,
        color: colorScheme.onBackground,
        fontWeight: FontWeight.w500,
      ),
      decoration: InputDecoration(
        prefixText: prefixText,
        prefixIcon: prefix,
        prefixIconConstraints: const BoxConstraints(minHeight: 0, minWidth: 0),
        contentPadding: EdgeInsets.zero,
        isDense: true,
        hintText: hintText,
        border: InputBorder.none,
        errorStyle: const TextStyle(height: 0),
      ),
      onChanged: onChange,
      // Valiação
      validator: (value) {
        if (validators != null) {
          String? validationError;
          for (var element in validators!) {
            validationError = validationError ??= element(controller?.text ?? value ?? "");
          }

          if (validationError != null && onValidate != null) {
            onValidate!(validationError);
          }
          return validationError != null ? "" : null;
        }

        return null;
      },
    );
  }
}
