import 'package:flutter/material.dart';
import 'package:octadesk_app/components/index.dart';
import 'package:octadesk_app/components/octa_select.dart';
import 'package:octadesk_app/query/rooms_query_builder.dart';
import 'package:octadesk_app/resources/index.dart';
import 'package:octadesk_app/utils/tuple.dart';
import 'package:octadesk_core/octadesk_core.dart';
import 'package:octadesk_services/octadesk_services.dart';
import 'package:octadesk_services/services/agent_service.dart';

class FilterOperationDialog extends StatefulWidget {
  final OperationTypeEnum? initialOperation;
  const FilterOperationDialog(this.initialOperation, {Key? key}) : super(key: key);

  @override
  State<FilterOperationDialog> createState() => _FilterOperationDialogState();
}

class _FilterOperationDialogState extends State<FilterOperationDialog> {
  // Tipo da operação selecionada
  OperationTypeEnum? _operationType;

  // Future de carregamento dos dados
  Future<Tuple<List<AgentModel>, List<GroupListModel>>>? _dataFuture;

  // Query de busca
  String _query = "";

  // ====== Métodos ======

  /// Carregar dados
  Future<Tuple<List<AgentModel>, List<GroupListModel>>> _loadData() async {
    try {
      var resp = await Future.wait([AgentService.getAgents(), ChatService.getGroups()]);
      var agents = resp[0] as List<AgentListDTO>;
      var groups = resp[1] as List<GroupDTO>;

      return Tuple<List<AgentModel>, List<GroupListModel>>(
        item1: agents.map((e) => AgentModel.fromAgentListDTO(e)).toList(),
        item2: groups.map((e) => GroupListModel.fromDTO(e)).toList(),
      );
    } catch (e) {
      return Future.error(e);
    }
  }

  /// Setar o future de carregamento de dados
  Future _setDataFuture() {
    setState(() {
      _dataFuture = _loadData();
    });
    return _dataFuture as Future;
  }

  /// Mudar o tipo da operação
  void _changeOperationType(OperationTypeEnum? value) {
    setState(() {
      _operationType = value;
      _query = "";
    });

    if (_dataFuture == null) {
      _setDataFuture();
    }
  }

  void _selectItem(GroupListModel group) {
    var data = _operationType != null ? Tuple<OperationTypeEnum, GroupListModel>(item1: _operationType!, item2: group) : null;
    Navigator.of(context).pop(data);
  }

  @override
  void initState() {
    super.initState();
    if (widget.initialOperation != null) {
      _changeOperationType(widget.initialOperation);
    }
  }

  @override
  Widget build(BuildContext context) {
    var searchBar = SliverAppBar(
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
        child: OctaSearchInput(onTextChange: (value) => setState(() => _query = value)),
      ),
    );

    var emptyBox = SliverToBoxAdapter(
      child: Container(
        padding: const EdgeInsets.all(AppSizes.s10),
        alignment: Alignment.center,
        child: const Text(
          "Não foi encontrado nenhum resultado",
          style: TextStyle(fontWeight: FontWeight.bold, fontFamily: "NotoSans", fontSize: AppSizes.s03, color: AppColors.gray800),
        ),
      ),
    );

    var query = _query.toLowerCase();

    return Column(
      children: [
        //
        // Tipo da operação
        Padding(
          padding: const EdgeInsets.all(AppSizes.s04),
          child: OctaSelect<OperationTypeEnum>(
            values: [
              OctaSelectItem(value: OperationTypeEnum.agent, text: "Agente"),
              OctaSelectItem(value: OperationTypeEnum.group, text: "Grupo"),
            ],
            value: _operationType,
            onChanged: _changeOperationType,
            hint: "Selecione a operação",
          ),
        ),
        const Divider(height: 1, thickness: 1),

        // Conteúdo
        Expanded(
          child: FutureBuilder<Tuple<List<AgentModel>, List<GroupListModel>>>(
            future: _dataFuture,
            builder: (context, snapshot) {
              Widget child;

              if (snapshot.connectionState == ConnectionState.none) {
                return const SizedBox.shrink();
              }

              // Loading
              if (snapshot.connectionState == ConnectionState.waiting) {
                child = const CircularProgressIndicator();
              }
              // Erro
              else if (snapshot.hasError) {
                child = OctaErrorContainer(
                  showIllustration: false,
                  subtitle: "Não foi possível carregar os dados, por favor, tente novamente em breve",
                  onTryAgain: _setDataFuture,
                );
              }

              // Listar agentes
              else if (_operationType == OperationTypeEnum.agent) {
                var agents = snapshot.data!.item1;
                var filteredAgents = _query.isEmpty ? agents : agents.where((element) => element.name.toLowerCase().contains(query) || element.email.contains(query)).toList();

                child = CustomScrollView(
                  key: const ValueKey("agent"),
                  slivers: [
                    searchBar,
                    filteredAgents.isNotEmpty
                        ? SliverList(
                            delegate: SliverChildBuilderDelegate((context, index) {
                              var agent = filteredAgents[index];

                              return OctaListItem(
                                showDivider: true,
                                onPressed: () => _selectItem(GroupListModel(
                                  enabled: true,
                                  id: agent.id,
                                  name: agent.name,
                                  agents: [],
                                )),
                                title: agent.name,
                              );
                            }, childCount: filteredAgents.length),
                          )
                        : emptyBox
                  ],
                );
              }

              // Listar grupos
              else {
                var groups = snapshot.data!.item2;
                var filteredGroups = _query.isEmpty ? groups : groups.where((element) => element.name.toLowerCase().contains(query)).toList();

                child = CustomScrollView(
                  key: const ValueKey("groups"),
                  slivers: [
                    searchBar,
                    filteredGroups.isNotEmpty
                        ? SliverList(
                            delegate: SliverChildBuilderDelegate((context, index) {
                              return OctaListItem(
                                showDivider: true,
                                onPressed: () => _selectItem(filteredGroups[index]),
                                title: filteredGroups[index].name,
                              );
                            }, childCount: filteredGroups.length),
                          )
                        : emptyBox
                  ],
                );
              }

              return AnimatedSwitcher(
                duration: const Duration(milliseconds: 150),
                child: child,
              );
            },
          ),
        ),
        const Divider(height: 1, thickness: 1),

        // Submeter
        Padding(
          padding: const EdgeInsets.all(AppSizes.s04),
          child: OctaButton(text: "Filtrar", onPressed: () {}),
        )
      ],
    );
  }
}
