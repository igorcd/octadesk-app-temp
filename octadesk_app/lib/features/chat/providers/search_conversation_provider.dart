import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:octadesk_app/components/index.dart';
import 'package:octadesk_app/features/chat/dialogs/filter_channel_dialog.dart';
import 'package:octadesk_app/features/chat/dialogs/filter_date_dialog.dart';
import 'package:octadesk_app/features/chat/dialogs/filter_operation_dialog.dart';
import 'package:octadesk_app/features/chat/dialogs/filter_search_by_dialog.dart';
import 'package:octadesk_app/features/chat/dialogs/filter_status_dialog.dart';
import 'package:octadesk_app/features/chat/dialogs/tags_dialog.dart';
import 'package:octadesk_app/query/rooms_query_builder.dart';
import 'package:octadesk_app/resources/app_icons.dart';
import 'package:octadesk_app/utils/helper_functions.dart';
import 'package:octadesk_app/utils/tuple.dart';
import 'package:octadesk_core/octadesk_core.dart';
import 'package:octadesk_services/octadesk_services.dart';
import 'package:rxdart/rxdart.dart';

class SearchConversationProvider extends ChangeNotifier {
  final void Function() backButtonCallback;

  /// Controller do scroll da lista de contatos
  final ScrollController _scrollController = ScrollController();
  ScrollController get scrollController => _scrollController;

  /// Stream de usuários
  BehaviorSubject<List<RoomListModel>>? _roomsStreamController;
  Stream<List<RoomListModel>>? get roomsStream => _roomsStreamController?.stream;

  /// Carregando
  bool _loading = false;
  bool get loading => _loading;

  /// Tem mais áginas
  bool _hasMorePages = false;

  /// Timer de digitação
  Timer? _searchTimer;

  /// Cancelation token da requisição de carregar usuários
  CancelToken? _searchCancelationToken;

  // ====== Filtros ======
  final RoomsQueryBuilder _queryBuilder = RoomsQueryBuilder();

  String get searchByLabel {
    var labels = {
      RoomSeachByEnum.email: "E-mail",
      RoomSeachByEnum.name: "Nome",
      RoomSeachByEnum.phone: "Telefone",
      RoomSeachByEnum.comment: "Conteúdo",
      RoomSeachByEnum.id: "Id da conversa",
    };
    return labels[_queryBuilder.searchBy]!;
  }

  /// Operação
  bool get hasOperationFilter => _queryBuilder.operation != null;
  String get operationLabel {
    switch (_queryBuilder.operation?.item1) {
      case OperationTypeEnum.agent:
        return "Agente: ${_queryBuilder.operation?.item2.name}";
      case OperationTypeEnum.group:
        return "Grupo: ${_queryBuilder.operation?.item2.name}";
      default:
        return "Operação";
    }
  }

  /// Tags selecionadas
  bool get hasTagsFilter => (_queryBuilder.tags ?? []).isNotEmpty;
  String get selectedTagsLabel {
    if (_queryBuilder.tags == null || _queryBuilder.tags!.isEmpty) {
      return "Tags";
    }

    if (_queryBuilder.tags!.length == 1) {
      return "Uma tag";
    }

    return "${_queryBuilder.tags!.length} tags";
  }

  /// Canal selecionado
  bool get hasChannelFilter => _queryBuilder.channel != null;
  String get selectedChannelLabel {
    switch (_queryBuilder.channel) {
      // Web
      case ChatChannelEnum.web:
        return "Canal: Chat Web";

      // Facebook
      case ChatChannelEnum.facebookMessenger:
        return "Canal: Messenger";

      // Instagram
      case ChatChannelEnum.instagram:
        return "Canal: Instagram";

      // WhatsApp
      case ChatChannelEnum.whatsapp:
        return "Canal: WhatsApp";
      default:
        return "Canal";
    }
  }

  // Periodo
  bool get hasPeriodFilter => _queryBuilder.dateRange != null;
  String get periodLabel {
    var type = _queryBuilder.dateRange?.item1;
    switch (type) {
      case DateRangeEnum.today:
        return "Hoje";
      case DateRangeEnum.yesterday:
        return "Ontem";
      case DateRangeEnum.custom:
        return formatPeriod(_queryBuilder.dateRange!.item2!);
      case DateRangeEnum.lastMonth:
        return "Último mês";
      case DateRangeEnum.thisMonth:
        return "Este mês";
      case DateRangeEnum.lastWeek:
        return "Últimos 7 dias";
      default:
        return "Período";
    }
  }

  /// Status
  String get statusLabel => _queryBuilder.status == RoomStatusQueryEnum.open ? "Abertas" : "Encerradas";

  ///
  /// Carregar usuários
  ///
  Future<List<RoomListModel>> _getConversations() async {
    _loading = true;

    notifyListeners();
    try {
      // Cancelar requisição anterior
      _searchCancelationToken?.cancel();
      _searchCancelationToken = CancelToken();

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
  /// Carregar dados iniciais
  ///
  void _makeRequest() async {
    try {
      var rooms = await _getConversations();
      _roomsStreamController!.add(rooms);
    } catch (e) {
      _roomsStreamController!.addError(e);
    }
  }

  ///
  /// Inicializar
  ///
  void _initialize() {
    _roomsStreamController = BehaviorSubject();
    _roomsStreamController!.onListen = () => WidgetsBinding.instance.addPostFrameCallback((timeStamp) => _makeRequest());
    _roomsStreamController!.onCancel = () => _roomsStreamController!.close();
  }

  SearchConversationProvider({required this.backButtonCallback}) {
    _initialize();
  }

  ///
  /// Abrir dialog de buscar por:
  ///
  void openSearchByDialog(BuildContext context) async {
    var resp = await showOctaBottomSheet(
      context,
      title: "Buscar por",

      // Botão de limpar
      action: OctaBottomSheetAction(
        icon: AppIcons.clearFilter,
        onTap: () {
          _queryBuilder.searchBy = RoomSeachByEnum.name;
          notifyListeners();
          _makeRequest();
        },
      ),

      // Conteúdo
      child: SearchByDialog(_queryBuilder.searchBy),
    );
    if (resp is RoomSeachByEnum) {
      _queryBuilder.searchBy = resp;
      notifyListeners();
      _makeRequest();
    }
  }

  ///
  /// Abrir dialog de buscar por:
  ///
  void openStatusDialog(BuildContext context) async {
    var resp = await showOctaBottomSheet(
      context,
      title: "Status",

      // Botão de limpar
      action: OctaBottomSheetAction(
        icon: AppIcons.clearFilter,
        onTap: () {
          _queryBuilder.status = RoomStatusQueryEnum.open;
          notifyListeners();
          _makeRequest();
        },
      ),

      // Conteúdo
      child: FilterStatusDialog(_queryBuilder.status),
    );

    if (resp is RoomStatusQueryEnum) {
      _queryBuilder.status = resp;
      notifyListeners();
      _makeRequest();
    }
  }

  ///
  /// Mostrar dialog de tags
  ///
  void openTagsDialog(BuildContext context) async {
    var resp = await showOctaBottomSheet(
      context,
      title: "Tags",

      // Botão de limpar
      action: OctaBottomSheetAction(
        icon: AppIcons.clearFilter,
        onTap: () {
          _queryBuilder.tags = null;
          notifyListeners();
          _makeRequest();
        },
      ),

      // Conteúdo
      child: TagsDialog(_queryBuilder.tags ?? []),
    );

    if (resp is List<TagModel>) {
      _queryBuilder.tags = [...resp];
      notifyListeners();
      _makeRequest();
    }
  }

  ///
  /// Abrir modal de canais
  ///
  void openChannelsDialog(BuildContext context) async {
    var resp = await showOctaBottomSheet(
      context,
      title: "Canal",

      // Botão de limpar
      action: OctaBottomSheetAction(
        icon: AppIcons.clearFilter,
        onTap: () {
          _queryBuilder.channel = null;
          notifyListeners();
          _makeRequest();
        },
      ),

      // Conteúdo
      child: FilterChannelDialog(initialChannel: _queryBuilder.channel),
    );
    if (resp is ChatChannelEnum) {
      _queryBuilder.channel = resp;
      notifyListeners();
      _makeRequest();
    }
  }

  ///
  /// Abri modal de datas
  ///
  void openDateDialog(BuildContext context) async {
    var resp = await showOctaBottomSheet(
      context,
      title: "Período",

      // Botão de limpar
      action: OctaBottomSheetAction(
        icon: AppIcons.clearFilter,
        onTap: () {
          _queryBuilder.dateRange = null;
          notifyListeners();
          _makeRequest();
        },
      ),

      // Conteúdo
      child: FilterDateDialog(_queryBuilder.dateRange),
    );
    if (resp is Tuple<DateRangeEnum, DateTimeRange?>) {
      _queryBuilder.dateRange = resp;
      notifyListeners();
      _makeRequest();
    }
  }

  ///
  /// Abrir modal de operação
  ///
  void openOperationModal(BuildContext context) async {
    var resp = await showOctaBottomSheet(
      context,
      title: "Operação",

      // Botão de limpar
      action: OctaBottomSheetAction(
        icon: AppIcons.clearFilter,
        onTap: () {
          _queryBuilder.operation = null;
          notifyListeners();
          _makeRequest();
        },
      ),

      // Conteúdo
      child: FilterOperationDialog(_queryBuilder.operation?.item1),
    );

    if (resp is Tuple<OperationTypeEnum, GroupListModel>) {
      _queryBuilder.operation = resp;
      notifyListeners();
      _makeRequest();
    }
  }

  ///
  /// Realizar uma busca
  ///
  void search(String value) {
    _searchTimer?.cancel();
    _searchTimer = Timer(const Duration(seconds: 1), () {
      _queryBuilder.query = value;
      _queryBuilder.page = 1;
      _makeRequest();
    });
  }

  ///
  /// Paginar
  ///
  void paginate() async {
    if (_hasMorePages) {
      _queryBuilder.page += 1;

      try {
        var currentRooms = [..._roomsStreamController!.value];
        var newRooms = await _getConversations();
        _roomsStreamController!.add([...currentRooms, ...newRooms]);
      } catch (e) {
        _roomsStreamController!.addError(e);
      }
    }
  }
}
