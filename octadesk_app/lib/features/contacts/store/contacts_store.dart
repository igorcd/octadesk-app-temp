import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:octadesk_app/features/contacts/providers/contact_detail_provider.dart';
import 'package:octadesk_app/query/users_query_builder.dart';
import 'package:octadesk_core/models/index.dart';
import 'package:octadesk_services/octadesk_services.dart';
import 'package:rxdart/subjects.dart';

class ContactsStore extends ChangeNotifier {
  bool _paginating = false;
  bool get paginating => _paginating;

  String _selectedConversationId = "";
  String get selectedConversationId => _selectedConversationId;

  /// Stream da lista de contatos
  BehaviorSubject<List<ContactListModel>?>? _contactsStreamController;
  Stream<List<ContactListModel>?>? get contactsStream => _contactsStreamController?.stream;

  /// Future do detalhe do contato
  Future<ContactDetailProvider?>? _contactDetailFuture;
  Future<ContactDetailProvider?>? get contactDetailFuture => _contactDetailFuture;

  ///
  /// Query de contatos
  ///
  final UsersQueryBuilder _query = UsersQueryBuilder();

  ///
  /// Carregar contatos
  ///
  Future<List<ContactListModel>> _loadContacts() async {
    var resp = await PersonService.getPersons(_query.toMap());
    return resp.map((e) => ContactListModel.fromDTO(e)).toList();
  }

  ///
  /// Inicializar
  ///
  void _initialize() {
    // Instanciar o controller
    _contactsStreamController = BehaviorSubject();
    _contactsStreamController!.onListen = () => WidgetsBinding.instance.addPostFrameCallback((timeStamp) => refreshContacts());
    _contactsStreamController!.onCancel = () => _contactsStreamController!.close();
  }

  CancelToken? _detailCancelToken;
  Future<ContactDetailProvider?> _loadContactDetail(String contactId) async {
    try {
      _detailCancelToken?.cancel();
      _detailCancelToken = CancelToken();
      var resp = await PersonService.getContactDetail(contactId, cancelToken: _detailCancelToken);
      return ContactDetailProvider(resp);
    }
    // Cancelar
    on DioError catch (e) {
      if (e.type == DioErrorType.cancel) {
        return null;
      }
      return Future.error(e);
    }
    // error
    catch (e) {
      return Future.error(e);
    }
  }

  ContactsStore() {
    _initialize();
  }

  ///
  /// Carregar dados iniciais
  ///
  void refreshContacts() async {
    try {
      _contactsStreamController!.add(null);
      var resp = await _loadContacts();
      _contactsStreamController!.add(resp);
    } catch (e) {
      _contactsStreamController!.addError(e);
    }
  }

  ///
  /// Paginar
  ///
  void paginate() {}

  ///
  /// Selecioanr contato
  ///
  void selectContact(String id) {
    _selectedConversationId = id;
    _contactDetailFuture = null;
    notifyListeners();

    _contactDetailFuture = _loadContactDetail(id);
    notifyListeners();
  }
}
