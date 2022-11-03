import 'package:easy_mask/easy_mask.dart';
import 'package:flutter/material.dart';
import 'package:octadesk_app/resources/app_sizes.dart';

class ContactTextInput extends StatefulWidget {
  final GlobalKey<FormFieldState>? inputKey;
  final List<String>? mask;
  final String placeholder;
  final TextEditingController? controller;
  final Widget? prefix;
  final List<String? Function(String value)>? validators;
  final void Function(String value)? onChange;

  const ContactTextInput({
    this.mask,
    required this.placeholder,
    this.controller,
    this.prefix,
    super.key,
    this.validators,
    this.onChange,
    this.inputKey,
  });

  @override
  State<ContactTextInput> createState() => _ContactTextInputState();
}

class _ContactTextInputState extends State<ContactTextInput> {
  bool _editActive = false;
  String _error = "";
  final FocusNode _inputFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;
    var showContainer = _editActive || _error.isNotEmpty;
    var focusColor = _error.isNotEmpty ? colorScheme.error : colorScheme.primary;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Focus(
          onFocusChange: (value) {
            setState(() {
              _editActive = value;
            });
          },
          child: AnimatedContainer(
            margin: const EdgeInsets.only(top: 4),
            duration: const Duration(milliseconds: 150),
            padding: showContainer ? const EdgeInsets.all(AppSizes.s03) : EdgeInsets.zero,
            decoration: BoxDecoration(
              border: Border.all(width: showContainer ? 2 : 0, color: showContainer ? focusColor : Colors.transparent),
              borderRadius: BorderRadius.circular(AppSizes.s02_5),
            ),

            // Input
            child: TextFormField(
              key: widget.inputKey,
              inputFormatters: widget.mask != null ? [TextInputMask(mask: widget.mask)] : null,
              focusNode: _inputFocusNode,
              controller: widget.controller,
              // controller: widget.controller,
              style: TextStyle(
                fontSize: AppSizes.s04,
                color: colorScheme.onBackground,
                fontWeight: FontWeight.w500,
              ),
              decoration: InputDecoration(
                prefixIcon: widget.prefix,
                prefixIconConstraints: const BoxConstraints(minHeight: 0, minWidth: 0),
                contentPadding: EdgeInsets.zero,
                isDense: true,
                hintText: widget.placeholder,
                border: InputBorder.none,
                errorStyle: const TextStyle(height: 0),
              ),
              onChanged: (value) {
                setState(() {
                  _error = "";
                  if (widget.onChange != null) {
                    widget.onChange!(value);
                  }
                });
              },
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
            ),
          ),
        ),
        if (_error.isNotEmpty)
          Text(
            _error,
            style: TextStyle(color: colorScheme.error, fontSize: AppSizes.s03),
          )
      ],
    );
  }
}
