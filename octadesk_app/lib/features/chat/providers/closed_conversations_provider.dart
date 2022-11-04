import 'package:flutter/material.dart';
import 'package:octadesk_app/query/rooms_query_builder.dart';
import 'package:octadesk_core/octadesk_core.dart';
import 'package:octadesk_services/octadesk_services.dart';
import 'package:rxdart/rxdart.dart';

class ClosedConversationsProvider extends ChangeNotifier {
  ///
  /// Carregando
  ///
  bool _loading = false;
  bool get loading => _loading;

  ///
  /// Paginando
  ///
  bool _paginating = false;
  bool get paginating => _paginating;

  ///
  /// Controller
  ///
  late BehaviorSubject<List<RoomListModel>?> _roomsStreamController;
  Stream<List<RoomListModel>?> get closedRoomsStream => _roomsStreamController.stream;

  ///
  /// Tem mais páginas
  ///
  bool _hasMorePages = false;

  // ====== Filtros ======
  final RoomsQueryBuilder _queryBuilder = RoomsQueryBuilder(status: RoomStatusQueryEnum.closed);

  ///
  /// Carregar usuários
  ///
  Future<List<RoomListModel>> _getConversations() async {
    _loading = true;
    notifyListeners();

    try {
      var resp = await ChatService.getRooms(_queryBuilder.toMap());
      var paginator = RoomPaginationModel.fromDTO(resp);

      _hasMorePages = paginator.hasMorePages;
      return paginator.rooms;
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  ///
  /// Inicializar
  ///
  void _initialize() {
    _roomsStreamController = BehaviorSubject();
    _roomsStreamController.onListen = () => WidgetsBinding.instance.addPostFrameCallback((timeStamp) => refresh());
    _roomsStreamController.onCancel = () => _roomsStreamController.close();
  }

  ClosedConversationsProvider() {
    _initialize();
  }

  ///
  /// Atualizar
  ///
  Future refresh({bool clearStream = false}) async {
    try {
      _queryBuilder.page = 1;
      if (clearStream) {
        _roomsStreamController.add(null);
      }
      var rooms = await _getConversations();
      _roomsStreamController.add(rooms);
    } catch (e) {
      if (!_roomsStreamController.isClosed) {
        _roomsStreamController.addError(e);
      }
    }
  }

  ///
  /// Realizar a paginação
  ///
  void paginate() async {
    if (_hasMorePages && !_loading) {
      _queryBuilder.page += 1;
      try {
        _paginating = true;
        notifyListeners();
        // Realizar a requisição
        var resp = await _getConversations();

        // Contatenar com os dados atuais
        var newUsersList = [..._roomsStreamController.value!, ...resp];

        // Atualizar stream
        _roomsStreamController.add(newUsersList);
      } catch (e) {
        _roomsStreamController.addError(e);
      } finally {
        _paginating = false;
        notifyListeners();
      }
    }
  }

  ///
  /// Limpar paginação quando chegar no início da listagem
  ///
  void clearPagination() {
    if (_queryBuilder.page > 1) {
      refresh();
    }
  }
}
