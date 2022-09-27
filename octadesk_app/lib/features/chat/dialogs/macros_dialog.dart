import 'package:flutter/material.dart';
import 'package:octadesk_app/components/index.dart';
import 'package:octadesk_app/components/octa_skeleton_list.dart';
import 'package:octadesk_app/resources/index.dart';
import 'package:octadesk_core/octadesk_core.dart';
import 'package:octadesk_services/octadesk_services.dart';

class MacrosDialog extends StatefulWidget {
  final RoomModel room;
  final MacroTypeEnum? filter;
  const MacrosDialog(this.room, {this.filter, Key? key}) : super(key: key);

  @override
  State<MacrosDialog> createState() => _MacrosDialogState();
}

class _MacrosDialogState extends State<MacrosDialog> {
  String _filter = "";
  late Future<List<MacroDTO>> _macrosFuture;

  Future<List<MacroDTO>> _loadMacros() async {
    try {
      var macros = await ChatService.getAvaiableMacros(widget.room.key);
      if (widget.filter != null) {
        return macros.where((element) => element.type == widget.filter).toList();
      }
      return macros;
    } catch (e) {
      return Future.error(e);
    }
  }

  @override
  void initState() {
    super.initState();
    _macrosFuture = _loadMacros();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<MacroDTO>>(
      future: _macrosFuture,
      builder: (context, snapshot) {
        Widget child;

        // Error
        if (snapshot.hasError) {
          child = const OctaErrorContainer(subtitle: "Não foi possível carregar os dados");
        }

        // Carregando
        else if (!snapshot.hasData) {
          child = const OctaSkeletonList();
        }

        // Lista de dados
        else {
          var filteredMacros = _filter.isEmpty
              ? snapshot.data!
              : snapshot.data!.where((e) {
                  return e.name.toLowerCase().contains(_filter.toLowerCase());
                }).toList();

          child = CustomScrollView(
            slivers: [
              //
              // Header
              SliverAppBar(
                elevation: 0,
                floating: true,
                backgroundColor: Colors.white,
                leading: null,
                automaticallyImplyLeading: false,
                toolbarHeight: AppSizes.s17,
                primary: false,
                flexibleSpace: Padding(
                  padding: const EdgeInsets.only(top: AppSizes.s04, right: AppSizes.s04, left: AppSizes.s04),

                  // Input de busca
                  child: OctaSearchInput(onTextChange: (value) => setState(() => _filter = value)),
                ),
              ),

              // Lista de macros
              filteredMacros.isNotEmpty
                  ? SliverList(
                      delegate: SliverChildBuilderDelegate((context, index) {
                        var macro = filteredMacros[index];
                        return OctaListItem(
                          title: macro.name,
                          onPressed: () => Navigator.of(context).pop(macro),
                        );
                      }, childCount: filteredMacros.length),
                    )

                  // Nenhum macro encontrado de acordo com a busca
                  : const OctaEmptySliver(text: "Não foram encontradas menságens rápidas")
            ],
          );
        }
        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: child,
        );
      },
    );
  }
}
