import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:octadesk_app/components/index.dart';
import 'package:octadesk_app/resources/app_sizes.dart';
import 'package:octadesk_core/dtos/index.dart';
import 'package:octadesk_services/octadesk_services.dart';

class OrganizationsDialog extends StatefulWidget {
  const OrganizationsDialog({super.key});

  @override
  State<OrganizationsDialog> createState() => _OrganizationsDialogState();
}

class _OrganizationsDialogState extends State<OrganizationsDialog> {
  Future<List<OrganizationDTO>>? _organizationsFuture;
  CancelToken? _cancelToken;
  Timer? typingTimer;

  Future<List<OrganizationDTO>> _loadOrganizations(String text) async {
    try {
      _cancelToken?.cancel();
      _cancelToken = CancelToken();
      var resp = await PersonService.getOrganizations(search: text, cancelToken: _cancelToken);
      return resp;
    } on DioError catch (e) {
      if (e.type == DioErrorType.cancel) {
        return [];
      }
      rethrow;
    } catch (e) {
      return Future.error(e);
    }
  }

  void _setOrganizationsFuture(String text) {
    typingTimer?.cancel();
    typingTimer = Timer(const Duration(milliseconds: 300), () {
      setState(() {
        _organizationsFuture = _loadOrganizations(text);
      });
    });
  }

  @override
  void initState() {
    super.initState();
    _organizationsFuture ??= _loadOrganizations("");
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<OrganizationDTO>>(
      future: _organizationsFuture,
      builder: (context, snapshot) {
        return CustomScrollView(
          slivers: [
            // Busca
            OctaSearchSliver(
              onTextChange: _setOrganizationsFuture,
              loading: !snapshot.hasData || snapshot.connectionState == ConnectionState.waiting,
            ),

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
                var organization = snapshot.data![index];

                return OctaListItem(
                  leading: OctaAvatar(name: organization.name),
                  title: organization.name!,
                  onPressed: () => Navigator.of(context).pop(organization),
                );
              }, childCount: snapshot.data?.length ?? 0),
            ),
            const SliverPadding(padding: EdgeInsets.only(bottom: AppSizes.s02))
          ],
        );
      },
    );
  }
}
