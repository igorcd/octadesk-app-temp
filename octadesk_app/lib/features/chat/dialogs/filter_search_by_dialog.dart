import 'package:flutter/material.dart';
import 'package:octadesk_app/components/octa_button.dart';
import 'package:octadesk_app/components/octa_radio_list_tile.dart';
import 'package:octadesk_app/query/rooms_query_builder.dart';
import 'package:octadesk_app/resources/index.dart';

class SearchByDialog extends StatefulWidget {
  final RoomSeachByEnum initialValue;
  const SearchByDialog(this.initialValue, {super.key});

  @override
  State<SearchByDialog> createState() => _SearchByDialogState();
}

class _SearchByDialogState extends State<SearchByDialog> {
  RoomSeachByEnum _searchByTemp = RoomSeachByEnum.name;

  void _setSearchByTemp(RoomSeachByEnum value) {
    setState(() => _searchByTemp = value);
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      _searchByTemp = widget.initialValue;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView(
            children: [
              // Nome
              OctaRadioListTile<RoomSeachByEnum>(
                groupValue: _searchByTemp,
                value: RoomSeachByEnum.name,
                onSelect: _setSearchByTemp,
                label: "Nome",
              ),
              const Divider(height: 1, thickness: 1),
              // E-mail
              OctaRadioListTile<RoomSeachByEnum>(
                groupValue: _searchByTemp,
                value: RoomSeachByEnum.email,
                onSelect: _setSearchByTemp,
                label: "E-mail",
              ),
              const Divider(height: 1, thickness: 1),

              // Telefone
              OctaRadioListTile<RoomSeachByEnum>(
                groupValue: _searchByTemp,
                value: RoomSeachByEnum.phone,
                onSelect: _setSearchByTemp,
                label: "Telefone",
              ),
              const Divider(height: 1, thickness: 1),

              // Conteúdo
              OctaRadioListTile<RoomSeachByEnum>(
                groupValue: _searchByTemp,
                value: RoomSeachByEnum.comment,
                onSelect: _setSearchByTemp,
                label: "Conteúdo",
              ),
              const Divider(height: 1, thickness: 1),

              // Id da conversa
              OctaRadioListTile<RoomSeachByEnum>(
                groupValue: _searchByTemp,
                value: RoomSeachByEnum.id,
                onSelect: _setSearchByTemp,
                label: "Id da conversa",
              ),
            ],
          ),
        ),
        const Divider(height: 1, thickness: 1),
        Padding(
          padding: EdgeInsets.only(
            top: AppSizes.s04,
            left: AppSizes.s04,
            right: AppSizes.s04,
            bottom: AppSizes.s04 + MediaQuery.of(context).padding.bottom,
          ),
          child: OctaButton(
            onPressed: () => Navigator.of(context).pop(_searchByTemp),
            text: "Filtrar",
          ),
        )
      ],
    );
  }
}
