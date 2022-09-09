import 'package:flutter/material.dart';
import 'package:octadesk_app/components/index.dart';
import 'package:octadesk_app/resources/index.dart';
import 'package:octadesk_core/models/index.dart';
import 'package:octadesk_services/octadesk_services.dart';
import 'package:collection/collection.dart';

class TagsDialog extends StatefulWidget {
  final List<TagModel> initialTags;
  final bool showCancelButton;

  const TagsDialog(this.initialTags, {this.showCancelButton = true, Key? key}) : super(key: key);

  @override
  State<TagsDialog> createState() => _TagsDialogState();
}

class _TagsDialogState extends State<TagsDialog> {
  // ======= Estado =====-=
  List<TagModel> _tags = [];
  final List<TagModel> _selectedTags = [];
  String _query = "";
  bool _loading = true;

  // ======= Métodos ======

  /// Selecionar macro
  void _selectTag(TagModel tag) {
    setState(() {
      _selectedTags.contains(tag) ? _selectedTags.remove(tag) : _selectedTags.add(tag);
    });
  }

  /// Carregar tags
  void _loadTags() async {
    try {
      var resp = await ChatService.getTags(query: "");
      setState(() {
        _tags = resp.map((e) => TagModel.fromDTO(e)).toList();
        _selectedTags.addAll(widget.initialTags);
      });
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _loadTags();
  }

  @override
  Widget build(BuildContext context) {
    // Tags disponíveis
    var avaiableTags = _tags.where((e) => _selectedTags.firstWhereOrNull((element) => element.id == e.id) == null);

    // Tags filtradas
    var filteredTags = _query.isEmpty
        ? avaiableTags.toList()
        : avaiableTags.where((e) {
            return e.name.toLowerCase().contains(_query.toLowerCase()) || e.name.toLowerCase().contains(_query.toLowerCase());
          }).toList();

    /// Conteúdo
    Widget renderContent() {
      //
      // Loading
      if (_loading) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      }

      // Vazio
      if (filteredTags.isEmpty) {
        return Container(
          padding: const EdgeInsets.only(top: AppSizes.s10),
          height: double.infinity,
          child: const OctaText("Nenhuma tag disponível"),
        );
      }

      // Lista de tags
      return ListView.separated(
        itemCount: filteredTags.length,

        // Divisória
        separatorBuilder: (c, i) => const Divider(
          endIndent: AppSizes.s04,
          height: 1,
          indent: AppSizes.s04,
        ),

        // Items da lista
        itemBuilder: (c, i) => Material(
          color: Colors.transparent,
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(vertical: AppSizes.s02, horizontal: AppSizes.s04),
            title: OctaText.bodyLarge(filteredTags[i].name),
            trailing: Image.asset(AppIcons.angleRight, width: AppSizes.s06),
            onTap: () => _selectTag(filteredTags[i]),
          ),
        ),
      );
    }

    return Column(
      children: [
        // Header
        Padding(
          padding: const EdgeInsets.only(top: AppSizes.s04, right: AppSizes.s04, left: AppSizes.s04),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Input de Busca
              OctaSearchInput(onTextChange: (value) => setState(() => _query = value)),

              const SizedBox(height: AppSizes.s03),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 150),
                child: _selectedTags.isEmpty

                    // Nenhuma tag
                    ? Container(
                        alignment: Alignment.center,
                        height: AppSizes.s08,
                        child: const Text("Nenhuma tag selecionada"),
                      )

                    // Tags Selecionadas
                    : SizedBox(
                        width: double.infinity,
                        child: Wrap(
                          direction: Axis.horizontal,
                          runSpacing: AppSizes.s02,
                          spacing: AppSizes.s02,
                          crossAxisAlignment: WrapCrossAlignment.start,
                          children: _selectedTags.map((e) {
                            return OctaTag(
                              onPressed: () => _selectTag(e),
                              placeholder: e.name,
                              active: true,
                              icon: AppIcons.times,
                            );
                          }).toList(),
                        ),
                      ),
              ),
              const SizedBox(height: AppSizes.s04),
              const Divider(height: 1, thickness: 1),
            ],
          ),
        ),

        // Conteúdo
        Expanded(
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 150),
            child: renderContent(),
          ),
        ),
        const Divider(height: 1, thickness: 1),
        Padding(
          padding: const EdgeInsets.all(AppSizes.s04),
          child: OctaButton(text: "Concluir", onPressed: () => Navigator.of(context).pop(_selectedTags)),
        )
      ],
    );
  }
}
