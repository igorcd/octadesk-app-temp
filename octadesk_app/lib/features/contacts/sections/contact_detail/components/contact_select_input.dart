import 'package:flutter/material.dart';
import 'package:octadesk_app/components/octa_select.dart';
import 'package:octadesk_app/resources/index.dart';

// class ContactSelectInput<T> extends StatelessElement {
//   final String placeholder;
//   final List<OctaSelectItem<T>> values;
//   final FocusNode? focusNode;
//   final T? value;
//   final List<String? Function(String value)>? validators;
//   final void Function(T? value) onChanged;

//   const ContactSelectInput({
//     this.placeholder = "Nenhum valor disponível",
//     this.validators,
//     required this.values,
//     this.focusNode,
//     required this.value,
//     required this.onChanged,
//     super.key,
//   });

// }

class ContactSelectInput<T> extends StatelessWidget {
  final String placeholder;
  final List<OctaSelectItem<T>> values;
  final FocusNode? focusNode;
  final T? value;
  final List<String? Function(String value)>? validators;
  final void Function(T? value) onChanged;

  const ContactSelectInput({
    this.placeholder = "Nenhum valor disponível",
    this.validators,
    required this.values,
    this.focusNode,
    required this.value,
    required this.onChanged,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;

    return SizedBox(
      height: 20,
      child: DropdownButtonHideUnderline(
        child: DropdownButton<T>(
          value: value,
          onChanged: onChanged,
          style: TextStyle(
            height: 0,
            fontSize: AppSizes.s04,
            color: colorScheme.onBackground,
            fontWeight: FontWeight.w500,
            fontFamily: "Poppins",
          ),
          hint: const Text("Selecione"),
          icon: const SizedBox.shrink(),
          items: values.map((e) {
            return DropdownMenuItem<T>(
              value: e.value,
              child: Text(e.text),
            );
          }).toList(),
        ),
      ),
    );
  }
}
