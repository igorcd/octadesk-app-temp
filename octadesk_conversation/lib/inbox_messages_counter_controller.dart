import 'dart:async';
import 'package:octadesk_core/octadesk_core.dart';
import 'package:octadesk_services/octadesk_services.dart';
import 'package:rxdart/rxdart.dart';

class InboxMessagesCounterController {
  /// Filtros do inbox
  final List<RoomFilterModel> filters;

  /// Controlador da stream
  late final BehaviorSubject<Map<RoomFilterEnum, int>> _inboxFiltersMessagesCountStreamController;

  Stream<Map<RoomFilterEnum, int>> get inboxFiltersMessagesStream => _inboxFiltersMessagesCountStreamController.stream;

  /// Timer do inbox filter
  Timer? inboxFiltersUpdateTimer;

  // ====== Métodos privados ======

  /// Carregar valor atual do counter
  Future<Map<RoomFilterEnum, int>> _getInboxMessagesCount(List<RoomFilterModel> filters) async {
    var resp = await ChatService.getRoomsCount(filters.map((e) => e.rule).toList());

    Map<RoomFilterEnum, int> values = {
      for (var i = 0; i < resp.length; i++) //
        filters[i].descriptor: resp[i]
    };

    return values;
  }

  /// Inicializar stream
  void _initializeStream() {
    Map<RoomFilterEnum, int> initialValues = {for (var filter in filters) filter.descriptor: 0};

    // Instanciar a stream
    _inboxFiltersMessagesCountStreamController = BehaviorSubject<Map<RoomFilterEnum, int>>.seeded(initialValues);

    // Quando começar a escutar a stream
    _inboxFiltersMessagesCountStreamController.onListen = () async {
      // Carregar contador inicial
      refresh();

      // Adicionar timer para atualizar o count de mensagens
      inboxFiltersUpdateTimer = Timer.periodic(Duration(minutes: 2, seconds: 30), (timer) async {
        refresh();
      });
    };

    _inboxFiltersMessagesCountStreamController.onCancel = () => inboxFiltersUpdateTimer?.cancel();
  }

  /// Construtor
  InboxMessagesCounterController(this.filters) {
    _initializeStream();
  }

  /// Atualizar valores
  Future<void> refresh() async {
    // Carregar contador inicial
    try {
      var count = await _getInboxMessagesCount(filters);
      _inboxFiltersMessagesCountStreamController.add(count);
    } catch (e) {
      // ignore: avoid_print
      print("Não foi possível atualizar o contador de mensagens");
    }
  }
}
