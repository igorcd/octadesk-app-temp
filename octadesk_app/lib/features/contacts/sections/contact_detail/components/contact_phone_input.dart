import 'package:flutter/material.dart';
import 'package:octadesk_app/components/index.dart';
import 'package:octadesk_app/components/octa_chip.dart';
import 'package:octadesk_app/components/octa_flag.dart';
import 'package:octadesk_app/components/octa_select.dart';
import 'package:octadesk_app/components/octa_text_form_field.dart';
import 'package:octadesk_app/features/contacts/providers/contact_detail_provider.dart';
import 'package:octadesk_app/features/contacts/sections/contact_detail/components/contact_select_input.dart';
import 'package:octadesk_app/resources/app_colors.dart';
import 'package:octadesk_app/resources/app_icons.dart';
import 'package:octadesk_app/resources/app_sizes.dart';
import 'package:octadesk_app/resources/app_validators.dart';
import 'package:octadesk_app/utils/country_seed.dart';
import 'package:collection/collection.dart';

class ContactPhoneInput extends StatefulWidget {
  final GlobalKey<FormFieldState>? inputKey;
  final GlobalKey<FormFieldState>? contryCodeKey;
  final ContactPhone phone;
  final void Function()? onAdd;
  final void Function()? onRemove;
  final bool isMainPhone;

  const ContactPhoneInput({
    this.inputKey,
    this.contryCodeKey,
    required this.phone,
    this.onAdd,
    required this.isMainPhone,
    this.onRemove,
    super.key,
  });

  @override
  State<ContactPhoneInput> createState() => _ContactPhoneInputState();
}

class _ContactPhoneInputState extends State<ContactPhoneInput> {
  String _flag = "";
  bool _editActive = false;
  String _error = "";
  final FocusNode _inputFocusNode = FocusNode();

  ///
  /// Verificar bandeira
  ///
  void _checkFlag(String countryCode, {bool requestFocus = true}) {
    var flag = countriesSeed.firstWhereOrNull((element) => element.phoneCode == "+$countryCode")?.cod;

    if (flag == null) {
      setState(() {
        _error = "";
        _flag = "";
      });
      return;
    }

    setState(() {
      _error = "";
      _flag = flag;
    });
    if (requestFocus) {
      _inputFocusNode.requestFocus();
    }
  }

  ///
  /// Verificar se o contro
  ///
  void _checkIfControllerIsClear() {
    if (widget.phone.contryCodeController.text.isEmpty) {
      setState(() {
        _flag = "";
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _checkFlag(widget.phone.contryCodeController.text, requestFocus: false);
    widget.phone.contryCodeController.addListener(_checkIfControllerIsClear);
  }

  @override
  void dispose() {
    widget.phone.contryCodeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;
    var showContainer = _editActive || _error.isNotEmpty;
    var focusColor = _error.isNotEmpty ? colorScheme.error : colorScheme.primary;

    Widget phoneInput() {
      return Focus(
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
          child: Row(
            children: [
              SizedBox(width: 30, child: OctaFlag(flag: _flag)),
              SizedBox(
                width: 50,
                child: OctaTextFormField(
                  inputKey: widget.contryCodeKey,
                  hintText: "Cod",
                  keyboardType: TextInputType.number,
                  prefixText: "+",
                  controller: widget.phone.contryCodeController,
                  onChange: _checkFlag,
                  validators: const [AppValidators.notEmpty],
                  onValidate: (value) {
                    setState(() => _error = value);
                  },
                ),
              ),
              Expanded(
                child: OctaTextFormField(
                  inputKey: widget.inputKey,
                  keyboardType: TextInputType.number,
                  hintText: "Telefone",
                  focusNode: _inputFocusNode,
                  controller: widget.phone.phoneController,
                  masks: _flag == 'BRA' ? ['(99) 99999-9999', '(99) 9999-9999', '99999999999999999'] : ['99999999999999999'],
                  // validators: const [AppValidators.notEmpty],
                  onValidate: (value) => setState(() => _error = value),
                  onChange: (value) => setState(() => _error = ""),
                ),
              )
            ],
          ),
        ),
      );
    }

    // Conteúdo principal
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        //
        // Tipo
        SizedBox(
          width: 130,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              //
              // Tipo Do telefone
              OctaText.labelLarge("Tipo do telefone"),
              ContactSelectInput<PhoneTypeEnum>(
                placeholder: "Selecione",
                values: [
                  OctaSelectItem(value: PhoneTypeEnum.cell, text: "Celular"),
                  OctaSelectItem(value: PhoneTypeEnum.home, text: "Residencial"),
                  OctaSelectItem(value: PhoneTypeEnum.work, text: "Trabalho"),
                ],
                value: widget.phone.type,
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      widget.phone.type = value;
                    });
                  }
                },
              ),
            ],
          ),
        ),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  OctaText.labelLarge("Numero"),
                  const SizedBox(width: AppSizes.s02),
                  if (widget.isMainPhone) const OctaChip(color: AppColors.info, text: "Principal"),
                ],
              ),

              // Telefone
              phoneInput(),
              if (_error.isNotEmpty)
                Text(
                  _error,
                  style: TextStyle(fontSize: AppSizes.s03, color: colorScheme.error),
                ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: AppSizes.s01_5),
          child: OctaIconButton(
            size: AppSizes.s08,
            iconSize: AppSizes.s07,
            onPressed: widget.onAdd ?? widget.onRemove!,
            icon: widget.onAdd != null ? AppIcons.attach : AppIcons.detach,
          ),
        )
      ],
    );
  }
}
