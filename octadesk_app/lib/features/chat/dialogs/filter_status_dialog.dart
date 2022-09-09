import 'package:flutter/material.dart';
import 'package:octadesk_app/components/octa_button.dart';
import 'package:octadesk_app/components/octa_radio_list_tile.dart';
import 'package:octadesk_app/query/rooms_query_builder.dart';
import 'package:octadesk_app/resources/index.dart';

class FilterStatusDialog extends StatefulWidget {
  final RoomStatusQueryEnum initialValue;
  const FilterStatusDialog(this.initialValue, {super.key});

  @override
  State<FilterStatusDialog> createState() => _FilterStatusDialogState();
}

class _FilterStatusDialogState extends State<FilterStatusDialog> {
  RoomStatusQueryEnum _statusTemp = RoomStatusQueryEnum.open;

  void _setSearchByTemp(RoomStatusQueryEnum value) {
    setState(() => _statusTemp = value);
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      _statusTemp = widget.initialValue;
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
              OctaRadioListTile<RoomStatusQueryEnum>(
                groupValue: _statusTemp,
                value: RoomStatusQueryEnum.open,
                onSelect: _setSearchByTemp,
                label: "Abertas",
              ),
              const Divider(height: 1, thickness: 1),
              // E-mail
              OctaRadioListTile<RoomStatusQueryEnum>(
                groupValue: _statusTemp,
                value: RoomStatusQueryEnum.closed,
                onSelect: _setSearchByTemp,
                label: "Fechadas",
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
            onPressed: () => Navigator.of(context).pop(_statusTemp),
            text: "Filtrar",
          ),
        )
      ],
    );
  }
}
