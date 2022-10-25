import 'package:flutter/material.dart';
import 'package:octadesk_app/components/index.dart';
import 'package:octadesk_app/components/octa_chip.dart';
import 'package:octadesk_app/components/octa_select.dart';
import 'package:octadesk_app/features/contacts/providers/contact_detail_provider.dart';
import 'package:octadesk_app/features/contacts/sections/contact_detail/components/contact_select_input.dart';
import 'package:octadesk_app/features/contacts/sections/contact_detail/components/contact_text_input.dart';
import 'package:octadesk_app/resources/app_colors.dart';
import 'package:octadesk_app/resources/app_icons.dart';
import 'package:octadesk_app/resources/app_sizes.dart';
import 'package:octadesk_app/resources/app_validators.dart';
import 'package:octadesk_app/utils/country_seed.dart';
import 'package:collection/collection.dart';

class ContactPhoneInput extends StatefulWidget {
  final GlobalKey<FormFieldState>? inputKey;
  final ContactPhone phone;
  final void Function()? onAdd;
  final void Function()? onRemove;
  final bool isMainPhone;

  const ContactPhoneInput({
    this.inputKey,
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

  void _checkFlag(String phone) {
    var phoneSections = phone.split(" ");
    if (phoneSections.isEmpty) {
      setState(() {
        _flag = "";
      });
      return;
    }
    var countryCode = phoneSections[0];
    var flag = countriesSeed.firstWhereOrNull((element) => element.phoneCode == countryCode)?.cod;

    if (flag == null) {
      setState(() {
        _flag = "";
      });
      return;
    }

    setState(() {
      _flag = flag;
    });
  }

  void _checkIfControllerIsClear() {
    if (widget.phone.phoneController.text.isEmpty) {
      setState(() {
        _flag = "";
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _checkFlag(widget.phone.phoneController.text);
    widget.phone.phoneController.addListener(_checkIfControllerIsClear);
  }

  @override
  void dispose() {
    widget.phone.phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;

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
              ContactTextInput(
                inputKey: widget.inputKey,
                // Bandeira
                prefix: Container(
                  margin: const EdgeInsets.only(right: 5),
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(4), color: colorScheme.background),
                  clipBehavior: Clip.hardEdge,
                  width: 20,
                  height: 14,
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 150),
                    child: _flag.isNotEmpty
                        ? Image.asset(
                            'lib/assets/flags/$_flag.png',
                          )
                        : null,
                  ),
                ),

                controller: widget.phone.phoneController,
                mask: widget.phone.mask,
                placeholder: "Insira o telefone",
                onChange: _checkFlag,
                validators: const [AppValidators.validatePhoneWithCountryCode],
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
