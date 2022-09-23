import 'package:flutter/material.dart';
import 'package:octadesk_app/components/octa_alert_dialog.dart';
import 'package:octadesk_app/features/chat/dialogs/chat_informations_dialog.dart';
import 'package:octadesk_app/features/chat/dialogs/tags_dialog.dart';
import 'package:octadesk_app/features/chat/sections/chat_detail/includes/chat_body.dart';
import 'package:octadesk_app/resources/app_colors.dart';
import 'package:octadesk_app/utils/helper_functions.dart';
import 'package:octadesk_conversation/octadesk_conversation.dart';
import 'package:octadesk_conversation/room_controller.dart';
import 'package:octadesk_core/octadesk_core.dart';
import 'package:octadesk_services/octadesk_services.dart';
import 'package:rich_text_controller/rich_text_controller.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:collection/collection.dart';

class ConversationDetailProvider extends ChangeNotifier {
  final String roomKey;
  final String userName;
  final String? userAvatar;
  final String userId;

  // Posição da stack de dialogs
  final ValueNotifier<int> _dialogStack = ValueNotifier(0);

  // Stream de detalhe da sala
  late final RoomController _roomDetailController;
  Stream<RoomModel?> get roomDetailStream => _roomDetailController.roomStream;

  /// Position listener
  final ItemPositionsListener itemPositionsListener = ItemPositionsListener.create();

  /// Controller do scroll
  final ItemScrollController _scrollController = ItemScrollController();
  ItemScrollController get scrollController => _scrollController;

  /// Controller do Input
  late final RichTextController _inputController;
  RichTextController get inputController => _inputController;

  late final FocusNode _inputFocusNode;
  FocusNode get inputFocusNode => _inputFocusNode;

  /// Lista de últimas conversas
  Future<List<RoomModel>>? _lastConversationsFuture;
  Future<List<RoomModel>> get lastConversationsFuture {
    _lastConversationsFuture ??= _getLastConversations();
    return _lastConversationsFuture!;
  }

  /// Anotação ativa
  bool _annotationActive = false;
  bool get annotationActive => _annotationActive;
  set annotationActive(value) {
    if (_annotationActive != value) {
      _inputController.clear();
      _annotationActive = value;
      notifyListeners();
    }
  }

  // Input em foco
  bool _inputInFocus = false;
  bool get inputInFocus => _inputInFocus;
  set inputInFocus(value) {
    _inputInFocus = value;
    notifyListeners();
  }

  /// Future de carregamento dos macros
  Future<List<MacroDTO>>? _macrosFuture;
  Future<List<MacroDTO>>? get macrosFuture => _macrosFuture;

  /// Filtro dos macros
  String _macrosFilter = "";
  String get macrosFilter => _macrosFilter;

  /// Filtro de menções
  String _mentionFilter = "";
  String get mentionFilter => _mentionFilter;

  ///  Callback para selecionar um agente
  void Function(String value)? _selectAgentInMentionsCallback;
  void Function(String value)? get selectAgentInMentionsCallback => _selectAgentInMentionsCallback;

  /// Carregar macros
  Future<List<MacroDTO>> _loadMacros() async {
    try {
      var resp = await ChatService.getAvaiableMacros(roomKey);
      return resp;
    } catch (e) {
      return Future.error(e);
    }
  }

  /// Carregar últimas conversas
  Future<List<RoomModel>> _getLastConversations() async {
    try {
      var resp = await ChatService.getContactConversations(contactId: userId, page: 1);
      return resp.rooms.map((e) => RoomModel.fromDTO(e)).toList();
    } catch (e) {
      return Future.error(e);
    }
  }

  /// Rotina de verificação de macros
  void _checkIfIsSearchingMacro() {
    // Abrir macros
    if (_macrosFuture == null && _inputController.text.startsWith('/')) {
      _macrosFuture = _loadMacros();
      notifyListeners();
    }

    // Fechar macros
    else if (_macrosFuture != null && !_inputController.text.startsWith('/')) {
      _macrosFuture = null;
      _macrosFilter = "";
      notifyListeners();
    }

    // Caso os macros estejam abertos, aplicar filtro
    if (_macrosFuture != null) {
      _macrosFilter = _inputController.text.replaceFirst('/', '').toLowerCase();
      notifyListeners();
    }
  }

  /// Atualizar uma palavra ao selecionar uma menção
  void _updateWordAfterSelectMentionAgent(int index, String newWord, int wordStartPosition) {
    var words = _inputController.text.split(' ');
    words[index] = "@$newWord ";
    _inputFocusNode.requestFocus();
    _inputController.text = words.join(' ');
    _mentionFilter = "";
    notifyListeners();

    var newCursorPosition = wordStartPosition + words[index].length;

    _inputController.selection = TextSelection.fromPosition(TextPosition(offset: newCursorPosition));
  }

  /// Verificar se está fazendo uma menção
  void _checkIfIsMentioning() {
    // Palavras
    var words = _inputController.text.split(' ');

    // Posições das palavras
    var positions = words
        .asMap()
        .map((index, element) {
          var start = index > 0 ? words.sublist(0, index).join(' ').length + 1 : 0;
          var end = start + element.length;
          return MapEntry(index, {'start': start, 'end': end});
        })
        .values
        .toList();

    // Posição atual do cursor
    var position = _inputController.selection.start;

    // Palavra atual
    var currentWord = positions.firstWhereOrNull((element) {
      return element['start']! <= position && element['end']! >= position;
    });

    // Caso a palavra atual não seja válida
    if (currentWord == null) {
      _mentionFilter = "";
      notifyListeners();
      return;
    }

    // Indice da palavra atual
    var currentWordIndex = positions.indexOf(currentWord);
    var word = words[currentWordIndex];

    // Caso seja uma menção
    if (word.startsWith("@") && _macrosFilter.isEmpty) {
      _mentionFilter = word;

      // Mapear callback para seleção do usuário
      _selectAgentInMentionsCallback = (newWord) => _updateWordAfterSelectMentionAgent(currentWordIndex, newWord, currentWord['start']!);
      notifyListeners();
      return;
    }
    // Caso contrário
    else if (_selectAgentInMentionsCallback != null) {
      _mentionFilter = "";
      _selectAgentInMentionsCallback = null;
      notifyListeners();
    }
  }

  /// Inicializar o provider
  void _initialize() {
    _inputFocusNode = FocusNode();
    // Instanciar controle da sala
    _roomDetailController = OctadeskConversation.instance.getRoomDetailController(roomKey);

    // Instanciar controller de texto
    _inputController = RichTextController(
      patternMatchMap: {
        RegExp("\\B@(?:${OctadeskConversation.instance.agents.map((el) {
          // Adicionar character literals para os parenteses
          return el.name.replaceAll("(", "\\(").replaceAll(")", "\\)");

          // Estilização das citações
        }).join("|")})+\\b"): TextStyle(
          fontWeight: FontWeight.bold,
          color: AppColors.warning.shade800,
          fontFamily: "NotoSans",
        ),
      },
      deleteOnBack: true,
      onMatch: (match) {
        WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
          _annotationActive = true;
          notifyListeners();
        });
      },
    );

    // Adicionar listeners do controller de input
    _inputController.addListener(() {
      _checkIfIsSearchingMacro();
      _checkIfIsMentioning();
      notifyListeners();
    });
  }

  /// Fechar sala atual
  void _closeCurrentConversation(BuildContext context) async {
    try {
      await _roomDetailController.close();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Não foi possível finalizar a conversa, tente novamente em breve")));
    }
  }

  // Construtor
  ConversationDetailProvider({
    required this.roomKey,
    required this.userAvatar,
    required this.userName,
    required this.userId,
  }) {
    _initialize();
  }

  /// Enviar mensagem
  void sendMessage() {
    if (inputController.text.isNotEmpty) {
      // Verificar se existe alguma menção
      List<AgentDTO> agents = OctadeskConversation.instance.agents.where((element) {
        return _inputController.text.contains("@${element.name}");
      }).toList();

      // Enviar a mensagem
      _roomDetailController.sendMessage(
        message: inputController.text,
        attachments: [],
        mentions: agents,
        quotedMessage: null,
        isInternal: annotationActive,
        template: null,
      );

      _inputController.clear();
      _annotationActive = false;
      notifyListeners();
    }
  }

  /// Gerenciar tags
  void manageTags(BuildContext context) async {
    if (_roomDetailController.room != null) {
      var scaffoldMessenger = ScaffoldMessenger.of(context);
      var selectedTags = [..._roomDetailController.room!.tags];

      var result = await showOctaBottomSheet(
        context,
        title: "Gerenciar tags",
        stack: _dialogStack,
        child: TagsDialog(selectedTags),
      );

      if (result is List<TagModel>) {
        var removedTags = selectedTags.where((tag) => !result.contains(tag)).map((tag) => tag.id).toList();
        var addedTags = result.where((tag) => !selectedTags.contains(tag)).toList();

        try {
          if (removedTags.isNotEmpty) {
            await ChatService.deleteTags(tags: removedTags, roomId: roomKey);
          }
          if (addedTags.isNotEmpty) {
            await ChatService.addTags(tags: addedTags.map((e) => TagPostDTO.fromModel(e)).toList(), roomId: roomKey);
          }
        } catch (e) {
          scaffoldMessenger.showSnackBar(
            const SnackBar(
              content: Text("Não foi possível atulizar as tags, por favor, tente novamente"),
            ),
          );
        }
      }
    }
  }

  /// Excluir uma tag
  void deleteTag(String id, BuildContext context) async {
    // Reference ao scaffold
    var scaffoldMessenger = ScaffoldMessenger.of(context);

    // atualizar lista de tags;
    var oldTagsList = [..._roomDetailController.room!.tags];
    var newTagsList = oldTagsList.where((element) => element.id != id).toList();

    _roomDetailController.updateTags(newTagsList);

    // Realizar a requisição
    try {
      await ChatService.deleteTags(tags: [id], roomId: roomKey);
    }
    // Em caso de erro
    catch (e) {
      scaffoldMessenger.showSnackBar(
        const SnackBar(
          content: Text("Não foi possível atulizar as tags, por favor, tente novamente"),
        ),
      );
      _roomDetailController.updateTags(oldTagsList);
    }
  }

  /// Selecionar o Macro
  void selectMacro(MacroDTO macro) {
    _inputController.text = macro.currentContent.components.firstWhere((element) => element.type == MacroComponentTypeEnum.body).message;
    _inputController.selection = TextSelection.fromPosition(TextPosition(offset: _inputController.text.length));
  }

  /// Abrir modal de finalização de conversa
  void openFinishConversationDialog(BuildContext context) async {
    displayAlertHelper(
      context,
      title: "Atenção!",
      subtitle: "Tem certeza que deseja finalizar esse atendimento?",
      actions: [
        OctaAlertDialogAction(primary: false, action: () {}, text: "Voltar"),
        OctaAlertDialogAction(primary: true, action: () => _closeCurrentConversation(context), text: "Finalizar"),
      ],
    );
    await _roomDetailController.close();
  }

  /// Mostrar dialog de histórico de conversa
  void openHistoryConversation(BuildContext context, RoomModel room) async {
    notifyListeners();

    await showOctaBottomSheet(
      context,
      title: room.createdBy.name,
      stack: _dialogStack,
      child: ChatBody(
        room: room,
        scrollController: ItemScrollController(),
      ),
    );

    notifyListeners();
  }

  /// Mostrar dialog de detalhes da conversa
  void showConversationInformations(BuildContext context) {
    showOctaBottomSheet(
      context,
      title: "Detalhes da conversa",
      stack: _dialogStack,
      child: ChatInformationsDialog(this),
    );
  }

  @override
  Future<void> dispose() async {
    await _roomDetailController.dispose();
    _inputController.dispose();
    _inputFocusNode.dispose();
    super.dispose();
  }
}
