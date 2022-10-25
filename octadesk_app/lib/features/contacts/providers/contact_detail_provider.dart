import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:octadesk_app/utils/helper_functions.dart';
import 'package:octadesk_conversation/octadesk_conversation.dart';
import 'package:octadesk_core/dtos/contact/contact_detail_dto.dart';

enum PhoneTypeEnum { home, work, cell }

enum TicketsVisualizationMode { requested, all }

class ContactPhone {
  PhoneTypeEnum type;
  final MaskTextInputFormatter mask;
  final TextEditingController phoneController;

  ContactPhone({required this.type, required this.phoneController, required this.mask});
}

class ContactDetailProvider extends ChangeNotifier {
  final ContactDetailDTO contact;

  final GlobalKey<FormState> _form = GlobalKey();
  GlobalKey<FormState> get form => _form;

  // Keys
  final GlobalKey<FormFieldState> _newContactPhoneKey = GlobalKey();
  GlobalKey<FormFieldState> get newContactPhoneKey => _newContactPhoneKey;

  // Formulário

  ///
  /// Nome
  ///
  late final TextEditingController _nameController;
  TextEditingController get nameController => _nameController;

  ///
  /// Email
  ///
  late final TextEditingController _emailController;
  TextEditingController get emailController => _emailController;

  ///
  /// Telewfones
  ///
  late List<ContactPhone> _phones;
  List<ContactPhone> get phones => _phones;

  ///
  /// Organizações
  ///
  late List<String> _organizations;
  List<String> get organizations => _organizations;

  ///
  /// Status do Funil de vendas
  late String _salesFunnelStatus;
  String get salesFunnelStatus => _salesFunnelStatus;

  ///
  /// Modo de visualização
  ///
  TicketsVisualizationMode _ticketsVisualizationMode = TicketsVisualizationMode.requested;
  TicketsVisualizationMode get ticketsVisualizationMode => _ticketsVisualizationMode;
  set ticketsVisualizationMode(value) {
    _ticketsVisualizationMode = value;
    notifyListeners();
  }

  late ContactPhone _newContactPhone;
  ContactPhone get newContactPhone => _newContactPhone;

  /// Gerar máscara de Input
  MaskTextInputFormatter _generatePhoneMast([String? phoneNumber]) {
    return MaskTextInputFormatter(
      mask: "+## (##) #####-####",
      initialText: phoneNumber != null ? setPhoneMaskHelper(phoneNumber) : null,
    );
  }

  ///
  /// Inicializar
  ///
  void _initialize() async {
    // Mapear nomes
    _nameController = TextEditingController(text: contact.name);

    // Mepar emails
    _emailController = TextEditingController(text: contact.email);

    // Mapear telefones
    _phones = contact.phoneContacts.map((e) {
      return ContactPhone(
        type: PhoneTypeEnum.values[e.type],
        phoneController: TextEditingController(text: setPhoneMaskHelper(e.phoneNumber)),
        mask: _generatePhoneMast(e.phoneNumber),
      );
    }).toList();

    _newContactPhone = ContactPhone(type: PhoneTypeEnum.cell, phoneController: TextEditingController(), mask: _generatePhoneMast());

    // Mapear organizações
    _organizations = contact.organizations.map((e) => e.name ?? "").toList();

    // Mapear funil de vendsas
    _salesFunnelStatus = OctadeskConversation.instance.contactTypes
        .firstWhere(
          (element) => element.id == contact.idContactStatus,
          orElse: () => OctadeskConversation.instance.contactTypes[0],
        )
        .id;

    // Mapear visualização  de tickets
    _ticketsVisualizationMode = TicketsVisualizationMode.values[contact.permissionView - 1];
  }

  /// Adicionar número
  void addPhoneNumber() async {
    var isValid = newContactPhoneKey.currentState?.validate() ?? false;

    if (isValid) {
      _phones.add(
        ContactPhone(
          type: newContactPhone.type,
          phoneController: TextEditingController(text: newContactPhone.phoneController.text),
          mask: MaskTextInputFormatter(mask: "+## (##) #####-####"),
        ),
      );
      newContactPhone.type = PhoneTypeEnum.cell;
      newContactPhone.phoneController.text = "";
      newContactPhone.mask.clear();

      await Future.delayed(const Duration(milliseconds: 300));
      notifyListeners();
    }
  }

  void removePhone(int index) {
    _phones.removeAt(index);
    notifyListeners();
  }

  ContactDetailProvider(this.contact) {
    _initialize();
  }
}
