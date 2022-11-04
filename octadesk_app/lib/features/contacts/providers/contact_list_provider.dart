import 'dart:async';
import 'package:flutter/material.dart';
import 'package:octadesk_app/query/users_query_builder.dart';
import 'package:octadesk_core/octadesk_core.dart';
import 'package:octadesk_services/octadesk_services.dart';
import 'package:rxdart/rxdart.dart';

class ContactListProvider extends ChangeNotifier {
  /// Paginando
  bool _paginating = false;
  bool get paginating => _paginating;

  /// Tem mais páginas
  bool _hasMorePages = true;

  /// Stream da lista de contatos
  final BehaviorSubject<List<ContactListModel>?> _contactsStreamController = BehaviorSubject();
  Stream<List<ContactListModel>?> get contactsStream => _contactsStreamController.stream;

  /// Timer de busca
  Timer? _searchTimer;

  ///
  /// Query de contatos
  ///
  final UsersQueryBuilder _query = UsersQueryBuilder();

  ///
  /// Carregar contatos
  ///
  Future<List<ContactListModel>> _loadContacts() async {
    var resp = await PersonService.getPersons(_query.toMap());
    _hasMorePages = resp.length == 20;
    return resp.map((e) => ContactListModel.fromDTO(e)).toList();
  }

  ///
  /// Inicializar
  ///
  void _initialize() {
    // Instanciar o controller
    _contactsStreamController.onListen = () => WidgetsBinding.instance.addPostFrameCallback((timeStamp) => refreshContacts());
    _contactsStreamController.onCancel = () => _contactsStreamController.close();
  }

  ContactListProvider(bool activeContacts) {
    _query.active = activeContacts;
    _initialize();
  }

  ///
  /// Carregar dados iniciais
  ///
  void refreshContacts() async {
    try {
      _contactsStreamController.add(null);
      _query.page = 1;
      var resp = await _loadContacts();
      _contactsStreamController.add(resp);
    } catch (e) {
      _contactsStreamController.addError(e);
    }
  }

  ///
  /// Paginar
  ///
  void paginate() async {
    if (!paginating && _contactsStreamController.value != null && _hasMorePages) {
      _paginating = true;
      notifyListeners();

      try {
        _query.page += 1;
        var newContactList = await _loadContacts();
        var currentContactList = _contactsStreamController.value!;

        _contactsStreamController.sink.add([...currentContactList, ...newContactList]);
      } catch (e) {
        _contactsStreamController.addError(e);
      } finally {
        _paginating = false;
        notifyListeners();
      }
    }
  }

  ///
  /// Buscar contato
  ///
  void searchContact(String text) {
    _searchTimer?.cancel();
    _searchTimer = Timer(const Duration(milliseconds: 300), () async {
      _query.page = 1;
      _query.search = text;
      try {
        var newContactList = await _loadContacts();
        _contactsStreamController.add(newContactList);
      } catch (e) {
        _contactsStreamController.addError(e);
      }
    });
  }
}
