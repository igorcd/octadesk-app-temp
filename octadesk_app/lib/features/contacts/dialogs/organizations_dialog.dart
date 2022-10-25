import 'package:flutter/material.dart';
import 'package:octadesk_app/components/index.dart';
import 'package:octadesk_services/octadesk_services.dart';

class OrganizationsDialog extends StatefulWidget {
  const OrganizationsDialog({super.key});

  @override
  State<OrganizationsDialog> createState() => _OrganizationsDialogState();
}

class _OrganizationsDialogState extends State<OrganizationsDialog> {
  void _loadOrganizations(String text) async {
    var resp = await PersonService.getOrganizations();
    print(resp);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<String>>(
      builder: (context, snapshot) {
        return CustomScrollView(
          slivers: [
            // Busca
            OctaSearchSliver(onTextChange: _loadOrganizations),

            // Em caso de error
            if (snapshot.hasError)
              const SliverToBoxAdapter(
                child: OctaErrorContainer(
                  subtitle: "Não foi possível carregar as organizações, tente novamente em breve",
                ),
              ),

            // Nenhum resultado encontrado
            if (snapshot.hasData && snapshot.data!.isEmpty) const OctaEmptySliver(text: "Não foi encontrada nenhuma organização"),

            // Lista de elementos
            SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
                return OctaListItem(
                  leading: OctaAvatar(name: "Teste"),
                  title: "Teste",
                  onPressed: () {},
                );
              }, childCount: 2),
            ),
          ],
        );
      },
    );
  }
}
