import 'package:flutter/material.dart';
import 'package:octadesk_app/components/index.dart';
import 'package:octadesk_app/components/octa_skeleton_list.dart';
import 'package:octadesk_app/components/octa_sliver_header.dart';
import 'package:octadesk_app/utils/tuple.dart';
import 'package:octadesk_core/octadesk_core.dart';
import 'package:collection/collection.dart';
import 'package:octadesk_services/octadesk_services.dart';

class TransferDialog extends StatefulWidget {
  final String? currentGroupId;
  final String? currentAgentId;

  const TransferDialog({this.currentAgentId, this.currentGroupId, super.key});

  @override
  State<TransferDialog> createState() => _TransferDialogState();
}

class _TransferDialogState extends State<TransferDialog> {
  // Lista de agentes
  String _searchText = "";
  Future<Tuple<List<GroupListModel>, List<AgentModel>>>? _agentsFuture;

  Future<Tuple<List<GroupListModel>, List<AgentModel>>> _loadAgents() async {
    try {
      // Carregar dados (necessário carregar os agentes pelo endpoint pois o connectionStatus do get de grupos é desatualizado)
      var data = await Future.wait([ChatService.getGroups(), ChatService.getAgents()]);

      // Mapear grupos
      var groups = (data[0] as List<GroupDTO>).map((e) => GroupListModel.fromDTO(e)).toList();

      groups.sort(((a, b) => a.name.compareTo(b.name)));

      // Mapear agentes
      var agents = (data[1] as List<AgentDTO>) //
          .where((element) => element.connectionStatus == 0)
          .map((e) {
        var group = groups.firstWhereOrNull((element) => element.agents.firstWhereOrNull((element) => element.id == e.id) != null);
        return AgentModel.fromAgentDTO(e, group: group?.name);
      }).toList();

      agents.sort(((a, b) => a.name.compareTo(b.name)));

      Tuple<List<GroupListModel>, List<AgentModel>> result = Tuple(item1: groups, item2: agents);
      return result;
    } catch (e) {
      return Future.error(e);
    }
  }

  void _setAgentsFuture() {
    setState(() {
      _agentsFuture = _loadAgents();
    });
  }

  @override
  void initState() {
    super.initState();
    _setAgentsFuture();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Tuple<List<GroupListModel>, List<AgentModel>>>(
      future: _agentsFuture,
      builder: (context, snapshot) {
        Widget child;

        // Erro
        if (snapshot.hasError) {
          child = OctaErrorContainer(subtitle: snapshot.error.toString());
        }

        // Carregando
        else if (snapshot.connectionState == ConnectionState.waiting) {
          child = const OctaSkeletonList();
        }

        // Conteúdo
        else {
          // Grupos
          var groups = snapshot.data!.item1;
          var filteredGroups = _searchText.isEmpty ? groups : groups.where((element) => element.name.toLowerCase().contains(_searchText.toLowerCase())).toList();

          var agents = snapshot.data!.item2;
          var filteredAgents = _searchText.isEmpty ? agents : agents.where((element) => element.name.toLowerCase().contains(_searchText.toLowerCase())).toList();

          // Ordenar agentes
          child = CustomScrollView(
            slivers: [
              OctaSearchSliver(onTextChange: (value) => setState(() => _searchText = value)),
              const OctaSliverHeader(title: "Grupos"),

              // Lista de grupos
              filteredGroups.isNotEmpty
                  ? SliverList(
                      delegate: SliverChildBuilderDelegate((context, index) {
                        var group = filteredGroups[index];
                        return OctaListItem(
                          title: group.name,
                          onPressed: () => Navigator.of(context).pop(group),
                          selected: group.id == widget.currentGroupId,
                          leading: OctaAvatar(
                            name: group.name,
                          ),
                        );
                      }, childCount: filteredGroups.length),
                    )

                  // Nenhum grupo encontrado
                  : const OctaEmptySliver(text: "Não foram encontrados grupos"),
              const OctaSliverHeader(
                title: "Agentes",
                pinned: true,
              ),

              // Lista de Agentes
              filteredAgents.isNotEmpty
                  ? SliverList(
                      delegate: SliverChildBuilderDelegate((context, index) {
                        var agent = filteredAgents[index];
                        return OctaListItem(
                          onPressed: () => Navigator.of(context).pop(agent),
                          title: agent.name,
                          subtitle: "${agent.group} - ${agent.email}",
                          leading: OctaAvatar(
                            source: agent.thumbUrl,
                            name: agent.name,
                          ),
                          selected: agent.id == widget.currentAgentId,
                        );
                      }, childCount: filteredAgents.length),
                    )

                  // Nenhum grupo encontrado
                  : const OctaEmptySliver(text: "Não foram encontrados agentes"),
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
