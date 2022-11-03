import 'package:flutter/material.dart';
import 'package:octadesk_app/features/contacts/dialogs/organizations_dialog.dart';
import 'package:octadesk_app/utils/helper_functions.dart';
import 'package:octadesk_conversation/octadesk_conversation.dart';
import 'dart:math' as math;

import 'package:octadesk_core/dtos/index.dart';
import 'package:octadesk_services/octadesk_services.dart';

enum PhoneTypeEnum { home, work, cell }

enum TicketsVisualizationMode { requested, all }

class ContactPhone {
  PhoneTypeEnum type;
  final TextEditingController contryCodeController;
  final TextEditingController phoneController;

  ContactPhone({required this.type, required this.phoneController, required this.contryCodeController});
}

class ContactDetailProvider extends ChangeNotifier {
  final ContactDetailDTO contact;

  final GlobalKey<FormState> _form = GlobalKey();
  GlobalKey<FormState> get form => _form;

  // Keys
  final GlobalKey<FormFieldState> _newContactPhoneKey = GlobalKey();
  GlobalKey<FormFieldState> get newContactPhoneKey => _newContactPhoneKey;

  final GlobalKey<FormFieldState> _newContactContryKey = GlobalKey();
  GlobalKey<FormFieldState> get newContactContryKey => _newContactContryKey;

  // Formulário

  ///
  /// Ativo
  ///
  late bool _contactActive;
  bool get contactActive => _contactActive;
  set contactActive(bool value) {
    _contactActive = value;
    notifyListeners();
  }

  ///
  /// Nome
  ///
  final TextEditingController _nameController = TextEditingController();
  TextEditingController get nameController => _nameController;

  ///
  /// Email
  ///
  final TextEditingController _emailController = TextEditingController();
  TextEditingController get emailController => _emailController;

  ///
  /// Telefones
  ///
  List<ContactPhone> _phones = [];
  List<ContactPhone> get phones => _phones;

  ///
  /// Organizações
  ///
  List<OrganizationDTO> _organizations = [];
  List<OrganizationDTO> get organizations => _organizations;

  ///
  /// Status do Funil de vendas
  String _salesFunnelStatus = "";
  String get salesFunnelStatus => _salesFunnelStatus;
  set salesFunnelStatus(String newValue) {
    _salesFunnelStatus = newValue;
    notifyListeners();
  }

  ///
  /// Modo de visualização
  ///
  TicketsVisualizationMode _ticketsVisualizationMode = TicketsVisualizationMode.requested;
  TicketsVisualizationMode get ticketsVisualizationMode => _ticketsVisualizationMode;
  set ticketsVisualizationMode(value) {
    _ticketsVisualizationMode = value;
    notifyListeners();
  }

  final ContactPhone _newContactPhone = ContactPhone(
    type: PhoneTypeEnum.cell,
    phoneController: TextEditingController(),
    contryCodeController: TextEditingController(text: "55"),
  );
  ContactPhone get newContactPhone => _newContactPhone;

  bool _loading = false;
  bool get loading => _loading;

  bool _autoValidateForm = false;
  bool get autovalidateForm => _autoValidateForm;

  ///
  /// Inicializar
  ///
  void _initialize() async {
    _contactActive = contact.isEnabled;

    // Mapear nomes
    _nameController.text = contact.name;

    // Mepar emails
    _emailController.text = contact.email;

    // Mapear telefones
    _phones = contact.phoneContacts.map((e) {
      var phone = setPhoneMaskHelper(e.number);
      return ContactPhone(
        type: PhoneTypeEnum.values[e.type - 1],
        phoneController: TextEditingController(text: phone),
        contryCodeController: TextEditingController(text: e.countryCode.replaceAll("+", "")),
      );
    }).toList();

    // Mapear organizações
    _organizations = contact.organizations.map((e) => e.clone()).toList();

    // Mapear funil de vendsas
    _salesFunnelStatus = OctadeskConversation.instance.contactTypes
        .firstWhere(
          (element) => element.id == contact.idContactStatus,
          orElse: () => OctadeskConversation.instance.contactTypes[0],
        )
        .id;

    // Mapear visualização  de tickets
    _ticketsVisualizationMode = TicketsVisualizationMode.values[math.max(contact.permissionView - 1, 0)];
  }

  ///
  /// dicionar número
  ///
  void addPhoneNumber() async {
    var validContryCode = newContactContryKey.currentState?.validate() ?? false;
    if (!validContryCode) {
      return;
    }

    var validPhone = newContactPhoneKey.currentState?.validate() ?? false;
    if (!validPhone) {
      return;
    }

    _phones.add(
      ContactPhone(
          type: newContactPhone.type,
          phoneController: TextEditingController(text: newContactPhone.phoneController.text),
          contryCodeController: TextEditingController(text: newContactPhone.contryCodeController.text)),
    );
    newContactPhone.type = PhoneTypeEnum.cell;
    newContactPhone.phoneController.text = "";
    newContactPhone.contryCodeController.text = "55";

    await Future.delayed(const Duration(milliseconds: 300));
    notifyListeners();
  }

  ///
  /// Remover telefonre
  ///
  void removePhone(int index) {
    _phones.removeAt(index);
    notifyListeners();
  }

  ///
  /// Adicionar organização
  ///
  void addOrganization(BuildContext context) async {
    var resp = await showOctaBottomSheet(
      context,
      title: "Organizações",
      child: const OrganizationsDialog(),
    );
    if (resp is OrganizationDTO) {
      _organizations.add(resp);
      notifyListeners();
    }
  }

  ///
  /// Remover organização
  ///
  void removeOrganization(int index) {
    _organizations.removeAt(index);
    notifyListeners();
  }

  ///
  /// Voltar ao status inicial
  ///
  void clear() {
    _initialize();
    notifyListeners();
  }

  ///
  /// Submeter
  ///
  void submit(BuildContext context) async {
    _autoValidateForm = true;
    notifyListeners();

    // Validar formulário
    var isValid = _form.currentState?.validate() ?? false;
    if (!isValid || _loading) {
      return;
    }

    // Setar o loading
    _loading = true;
    notifyListeners();

    var newContact = contact.clone();
    // Nome
    newContact.name = _nameController.text;

    // Email
    newContact.email = _emailController.text;

    // Ativo
    newContact.isEnabled = _contactActive;

    // Telefones
    newContact.phoneContacts = _phones.map((e) {
      return ContactPhoneDTO(
        countryCode: e.contryCodeController.text,
        number: removePhoneMaskHelper(e.phoneController.text),
        type: e.type.index + 1,
        isDefault: _phones.indexOf(e) == 0,
      );
    }).toList();

    // Organizações
    newContact.organizations = _organizations.map((e) {
      e.isDefault = _organizations.indexOf(e) == 0;
      return e;
    }).toList();

    // Status do funil de venda
    newContact.idContactStatus = _salesFunnelStatus;

    // Status dos tickets
    newContact.permissionView = _ticketsVisualizationMode.index + 1;

    try {
      await ChatService.updateContact(newContact);
      displayAlertHelper(context, subtitle: "Contato atualizado com sucesso", title: "Sucesso!");
    } catch (e) {
      displayAlertHelper(context, subtitle: "Não foi possível atualizar o usuário");
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  ContactDetailProvider(this.contact) {
    _initialize();
  }
}
