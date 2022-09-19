import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:octadesk_app/features/chat/providers/conversation_detail_provider.dart';
import 'package:octadesk_app/utils/helper_functions.dart';
import 'package:octadesk_conversation/inbox_messages_counter_controller.dart';
import 'package:octadesk_conversation/octadesk_conversation.dart';
import 'package:octadesk_conversation/rooms_list_controller.dart';
import 'package:octadesk_core/enums/room_filter_enum.dart';
import 'package:octadesk_core/models/index.dart';

class ConversationsProvider extends ChangeNotifier {
  // ====== Propriedades ======

  // Stream da quantidade de inbox
  InboxMessagesCounterController? _inboxMessagesCountController;
  Stream<Map<RoomFilterEnum, int>>? get inboxMessagesCountStream => _inboxMessagesCountController?.inboxFiltersMessagesStream;

  RoomsListController? _roomsListController;
  Stream<RoomPaginationModel?>? get roomsListStream => _roomsListController?.roomsStream;

  // ====== Variáveis =======

  // Verifica se existe uma conversa aberta para realização da animação no mobile
  bool _currentConversationOpened = false;
  bool get currentConversationOpened => _currentConversationOpened;

  // Verifica se o painel de informações está aberto
  bool _conversationInformationsOpened = false;
  bool get conversationInformationsOpened => _conversationInformationsOpened;

  // Container de iniciar nova conversa está aberto
  bool _newConversationPanelOpened = false;
  bool get newConversationPanelOpened => _newConversationPanelOpened;
  set newConversationPanelOpened(value) {
    _newConversationPanelOpened = value;
    notifyListeners();
  }

  // Container de buscar conversas está aberto
  bool _searchConversationsPanelOpened = false;
  bool get searchConversationsPanelOpened => _searchConversationsPanelOpened;
  set searchConversationsPanelOpened(value) {
    _searchConversationsPanelOpened = value;
    notifyListeners();
  }

  ///
  /// Current inbox
  ///
  RoomFilterEnum? _currentInbox;
  RoomFilterEnum? get currentInbox => _currentInbox;

  // Conversa atual
  ConversationDetailProvider? currentConversation;

  // Pode abrir uma nova conversa
  bool _canChangeConversation = true;

  void _initialize() async {
    _currentInbox = await getPersistedInboxFilter(OctadeskConversation.instance.agent!.id);
    _inboxMessagesCountController = OctadeskConversation.instance.getInboxFiltersMessagesCountController();
    _roomsListController = OctadeskConversation.instance.getRoomsListStreamController(inboxFilter: _currentInbox!);
    notifyListeners();
  }

  /// Construtor
  ConversationsProvider() {
    _initialize();
  }

  /// Mudar o inbox
  void changeInbox(RoomFilterEnum filter) async {
    if (_roomsListController != null) {
      _currentInbox = filter;
      notifyListeners();
      _roomsListController!.changeInbox(_currentInbox!);
    }
  }

  /// Selecionar uma conversa
  void selectConversation(RoomListModel room) async {
    _newConversationPanelOpened = false;
    notifyListeners();

    if (_canChangeConversation && currentConversation?.roomKey != room.key) {
      _canChangeConversation = false;

      try {
        // Instanciar provider do detalhe da sala
        await currentConversation?.dispose();
        currentConversation = null;

        notifyListeners();

        currentConversation = ConversationDetailProvider(
          roomKey: room.key,
          userAvatar: room.user.thumbUrl,
          userName: room.user.name,
          userId: room.user.id,
        );
        _currentConversationOpened = true;
        _canChangeConversation = true;

        notifyListeners();
      }

      // Injetar erro caso não seja possível
      catch (e) {
        _canChangeConversation = true;
      }
    }
  }

  /// Fechar conversa atual (Utilizado apenas no mobile)
  void closeConversation() async {
    // Fechar dialog
    _canChangeConversation = false;
    _currentConversationOpened = false;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 550));

    // Finalizar as streams
    await currentConversation?.dispose();
    currentConversation = null;
    _canChangeConversation = true;
    notifyListeners();
  }

  /// Abrir informações da conversa atual
  void openConversationInformations() {
    _conversationInformationsOpened = true;
    notifyListeners();
  }

  /// Fechar informações da conversa
  void closeConversationInformations() {
    _conversationInformationsOpened = false;
    notifyListeners();
  }

  @override
  void dispose() {
    OctadeskConversation.instance.dispose();
    super.dispose();
  }
}