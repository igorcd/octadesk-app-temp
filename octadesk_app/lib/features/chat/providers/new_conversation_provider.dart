// ignore_for_file: use_build_context_synchronously

import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:octadesk_app/features/chat/sections/new_conversation/components/contact_phone_list.dart';
import 'package:octadesk_app/features/chat/sections/new_conversation/components/origin_phone_list.dart';
import 'package:octadesk_app/utils/helper_functions.dart';
import 'package:octadesk_conversation/octadesk_conversation.dart';
import 'package:octadesk_core/dtos/contact/contact_list_dto.dart';
import 'package:octadesk_core/octadesk_core.dart';
import 'package:octadesk_services/octadesk_services.dart';
import 'package:rxdart/rxdart.dart';
import 'package:dio/dio.dart';

class NewConversationProvider extends ChangeNotifier {
  final void Function(RoomListModel room) roomCreationCallback;
  final void Function() backButtonCallback;

  /// Controller do scroll da lista de contatos
  final ScrollController _scrollController = ScrollController();
  ScrollController get scrollController => _scrollController;

  /// Carregando
  bool _loading = false;
  bool get loading => _loading;

  /// Carregando
  bool _creatingConversation = false;
  bool get creatingConversation => _creatingConversation;

  /// Página atual
  int _currentPage = 1;

  /// Tem mais áginas
  bool _hasMorePages = false;

  /// Busca
  String _search = "";

  /// Timer de digitação
  Timer? _searchTimer;

  /// Cancelation token da requisição de carregar usuários
  CancelToken? _searchCancelationToken;

  /// Stream de usuários
  BehaviorSubject<List<ContactListDTO>>? _usersStreamController;
  Stream<List<ContactListDTO>>? get usersStream => _usersStreamController?.stream;

  ///
  /// Carregar usuários
  ///
  Future<List<ContactListDTO>> _getUsers() async {
    _loading = true;

    notifyListeners();
    try {
      // Cancelar requisição anterior
      _searchCancelationToken?.cancel();
      _searchCancelationToken = CancelToken();

      // Realizar requisição
      var resp = await PersonService.getPersonsToStartNewConversation(
        page: _currentPage,
        search: _search,
        cancelToken: _searchCancelationToken,
      );
      _hasMorePages = resp.length == 10;
      return resp;
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  ///
  /// Carregar dados iniciais
  ///
  void _loadInitialData() async {
    try {
      var users = await _getUsers();
      _usersStreamController!.add(users);
    } catch (e) {
      _usersStreamController!.addError(e);
    }
  }

  ///
  /// Inicializar
  ///
  void _initialize() {
    // Instanciar o controller
    _usersStreamController = BehaviorSubject();
    _usersStreamController!.onListen = () => WidgetsBinding.instance.addPostFrameCallback((timeStamp) => _loadInitialData());
    _usersStreamController!.onCancel = () => _usersStreamController!.close();
  }

  ///
  /// Selecionar telefone do usuário
  ///
  Future<ContactPhoneDTO?> _selectUserContact(ContactListDTO contact, BuildContext context) async {
    // Caso o contato só tenha um número
    if (contact.phoneContacts.length == 1) {
      return contact.phoneContacts[0];
    }

    // Caso tenha vários, selecionar
    else {
      var selectedContact = await showOctaBottomSheet(
        context,
        title: "Contatos de ${contact.name}",
        child: ContactPhoneList(contact.phoneContacts),
      );

      if (selectedContact is ContactPhoneDTO) {
        return selectedContact;
      }

      return null;
    }
  }

  ///
  /// Selecionar telefone de origem
  ///
  Future<PhoneNumberModel?> _selectOriginPhone(BuildContext context) async {
    var phones = [...OctadeskConversation.instance.phoneNumbers];

    // Caso só tenha um telefone de atendimento
    if (phones.length == 1) {
      return phones[0];
    }

    // caso contrário, selecionar um telefone de origem
    var originPhone = await showOctaBottomSheet(
      context,
      title: "Selecione a origem",
      child: OriginPhoneList(phones),
    );
    if (originPhone is PhoneNumberModel) {
      return originPhone;
    }

    return null;
  }

  NewConversationProvider({required this.roomCreationCallback, required this.backButtonCallback}) {
    _initialize();
  }

  ///
  /// Realizar a paginação
  ///
  void paginate() async {
    if (_hasMorePages && !_loading) {
      _currentPage += 1;
      try {
        // Realizar a requisição
        var resp = await _getUsers();

        // Contatenar com os dados atuais
        var newUsersList = [..._usersStreamController!.value, ...resp];

        // Atualizar stream
        _usersStreamController!.add(newUsersList);
      } catch (e) {
        _usersStreamController!.addError(e);
      }
    }
  }

  ///
  /// Realizar uma busca
  ///
  void search(String value) {
    _searchTimer?.cancel();
    _searchTimer = Timer(const Duration(seconds: 1), () {
      _search = value;
      _currentPage = 1;
      _loadInitialData();
    });
  }

  ///
  /// Selecionar usuário
  ///
  void selectUser(ContactListDTO contact, BuildContext context) async {
    FocusScope.of(context).unfocus();
    // ContactPostDTO contactPost = ContactPostDTO.fromContactListDTO(contact);

    // selecionar contato do usuário
    ContactPhoneDTO? contactPhone = await _selectUserContact(contact, context);
    if (contactPhone == null) {
      return;
    }

    // Selecionar o integrator
    PhoneNumberModel? originPhone = await _selectOriginPhone(context);
    if (originPhone == null) {
      return;
    }

    _creatingConversation = true;
    notifyListeners();

    // Iniciar novo atendimento

    try {
      ContactPostDTO contactPost = ContactPostDTO.fromContactListDTO(contact);
      var room = await ChatService.startNewConversation(
        attendancePhone: originPhone.number,
        integrator: originPhone.integrator,
        clientPhone: contactPhone.toPhoneNumber(),
        user: contactPost,
      );

      roomCreationCallback(RoomListModel.fromRoomDetailDTO(room));
    } catch (e) {
      displayAlertHelper(context, subtitle: "Não foi possível iniciar a conversa, teve novamente em breve");
    } finally {
      _creatingConversation = false;
      notifyListeners();
    }
  }

  ///
  /// Voltar
  ///
  void back() {
    if (!_creatingConversation) {
      backButtonCallback();
    }
  }

  @override
  void dispose() {
    _usersStreamController?.close();
    _scrollController.dispose();
    _searchCancelationToken?.cancel();
    _searchTimer?.cancel();
    super.dispose();
  }
}
