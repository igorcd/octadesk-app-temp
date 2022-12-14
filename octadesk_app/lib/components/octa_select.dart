import 'package:flutter/material.dart';
import 'package:octadesk_app/resources/index.dart';

class OctaSelectItem<T> {
  final T value;
  final String text;

  OctaSelectItem({required this.value, required this.text});
}

class OctaSelect<T> extends StatefulWidget {
  final String emptyPlaceholder;
  final List<OctaSelectItem<T>> values;
  final FocusNode? focusNode;
  final T? value;
  final String? label;
  final String hint;
  final List<String? Function(String value)>? validators;
  final void Function(T? value) onChanged;

  const OctaSelect({
    this.emptyPlaceholder = "Nenhum valor disponível",
    this.validators,
    required this.values,
    this.focusNode,
    required this.value,
    required this.onChanged,
    this.label,
    required this.hint,
    Key? key,
  }) : super(key: key);

  @override
  State<OctaSelect<T>> createState() => _OctaSelectState<T>();
}

class _OctaSelectState<T> extends State<OctaSelect<T>> {
  @override
  Widget build(BuildContext context) {
    Widget renderContent() {
      return DropdownButtonFormField<T>(
        // Valiação
        validator: (value) {
          if (widget.validators != null) {
            String? validationError;
            // ignore: avoid_function_literals_in_foreach_calls
            widget.validators!.forEach((validator) {
              validationError = validationError ??= validator(value.toString());
            });
            return validationError;
          }
          return null;
        },

        focusNode: widget.focusNode,
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        value: widget.value,
        icon: const SizedBox.shrink(),
        decoration: const InputDecoration(
          contentPadding: EdgeInsets.only(top: AppSizes.s01, bottom: 7, right: AppSizes.s04, left: AppSizes.s04),
          border: InputBorder.none,
        ),
        style: const TextStyle(
          color: AppColors.gray800,
          fontSize: AppSizes.s04,
          fontFamily: "NotoSans",
        ),
        isExpanded: true,
        hint: Text(
          widget.hint,
          style: const TextStyle(
            fontWeight: FontWeight.w400,
            color: AppColors.gray300,
            fontSize: AppSizes.s04,
          ),
        ),
        onChanged: widget.onChanged,
        items: widget.values.isNotEmpty
            ? widget.values.map<DropdownMenuItem<T>>((e) {
                return DropdownMenuItem(
                  value: e.value,
                  child: Text(e.text),
                );
              }).toList()
            : [
                DropdownMenuItem(
                  enabled: false,
                  child: Text(
                    widget.emptyPlaceholder,
                    style: const TextStyle(color: AppColors.gray300),
                  ),
                )
              ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (widget.label != null)
          Padding(
            padding: const EdgeInsets.only(bottom: AppSizes.s01),
            child: Text(
              widget.label!,
              style: const TextStyle(fontFamily: "NotoSans", fontSize: AppSizes.s03, color: AppColors.gray800),
            ),
          ),
        AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.ease,
          //
          // Estilo
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(
              width: 2,
              color: AppColors.gray200,
            ),
            borderRadius: const BorderRadius.all(Radius.circular(AppSizes.s02_5)),
          ),

          // Input
          child: renderContent(),
        ),
      ],
    );
    // return
  }
}
