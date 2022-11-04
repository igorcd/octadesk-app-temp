import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:octadesk_app/features/contacts/providers/contact_detail_provider.dart';
import 'package:octadesk_app/utils/helper_functions.dart';
import 'package:octadesk_services/octadesk_services.dart';

class ContactsStore extends ChangeNotifier {
  /// Id da conversa selecionada
  String _selectedContactId = "";
  String get selectedContactId => _selectedContactId;

  /// Future do detalhe do contato
  Future<ContactDetailProvider?>? _contactDetailFuture;
  Future<ContactDetailProvider?>? get contactDetailFuture => _contactDetailFuture;

  /// Carregar detalhe de contato
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

  ///
  /// Fechar contato (apenas mobile)
  ///
  void closeContact() {
    showNavigationbar();
    _selectedContactId = "";
    _contactDetailFuture = null;
    notifyListeners();
  }

  ///
  /// Selecioanr contato
  ///
  void selectContact(String id) {
    hideNavigationBar();
    _selectedContactId = "";
    _contactDetailFuture = null;
    notifyListeners();

    _contactDetailFuture = _loadContactDetail(id);
    notifyListeners();
  }
}
