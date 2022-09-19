import 'package:flutter/material.dart';
import 'package:octadesk_app/components/index.dart';
import 'package:octadesk_app/components/octa_radio_list_tile.dart';
import 'package:octadesk_app/query/rooms_query_builder.dart';
import 'package:octadesk_app/resources/index.dart';
import 'package:octadesk_app/utils/helper_functions.dart';
import 'package:octadesk_app/utils/tuple.dart';

class FilterDateDialog extends StatefulWidget {
  final Tuple<DateRangeEnum?, DateTimeRange?>? initialPeriod;
  const FilterDateDialog(this.initialPeriod, {Key? key}) : super(key: key);

  @override
  State<FilterDateDialog> createState() => _FilterDateDialogState();
}

class _FilterDateDialogState extends State<FilterDateDialog> {
  DateRangeEnum? _selectedDateRangeTypeTemp;
  DateTimeRange? _selectedDateTimeRangeTemp;

  void _filter() {
    var result = _selectedDateRangeTypeTemp != null ? Tuple(item1: _selectedDateRangeTypeTemp!, item2: _selectedDateTimeRangeTemp) : null;
    Navigator.of(context).pop(result);
  }

  void _setPeriodTemp(DateRangeEnum? selectedDateType) {
    setState(() {
      _selectedDateRangeTypeTemp = selectedDateType;
      _selectedDateTimeRangeTemp = null;
    });
  }

  void _selectCustomDate(DateRangeEnum? selectedDateType) async {
    var result = await showDateRangePicker(
      context: context,
      firstDate: DateTime.fromMillisecondsSinceEpoch(0),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppColors.blue.shade400,
              onPrimary: Colors.white,
              onSurface: Colors.black45,
            ),
          ),
          child: SizedBox(width: 300, height: 300, child: child!),
        );
      },
    );

    if (result is DateTimeRange) {
      setState(() {
        _selectedDateTimeRangeTemp = DateTimeRange(start: result.start, end: DateTime(result.end.year, result.end.month, result.end.day, 23, 59, 59));
        _selectedDateRangeTypeTemp = selectedDateType;
      });
    }
  }

  @override
  initState() {
    super.initState();
    if (widget.initialPeriod != null) {
      setState(() {
        _selectedDateRangeTypeTemp = widget.initialPeriod!.item1;
        _selectedDateTimeRangeTemp = widget.initialPeriod!.item2;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Column(
            children: [
              // Hoje
              OctaRadioListTile(
                label: "Hoje",
                groupValue: _selectedDateRangeTypeTemp,
                value: DateRangeEnum.today,
                onSelect: _setPeriodTemp,
              ),
              const Divider(height: 1, thickness: 1),

              // Ontem
              OctaRadioListTile(
                label: "Ontem",
                groupValue: _selectedDateRangeTypeTemp,
                value: DateRangeEnum.yesterday,
                onSelect: _setPeriodTemp,
              ),
              const Divider(height: 1, thickness: 1),

              // Últimos sete dias
              OctaRadioListTile(
                label: "Últimos 7 dias",
                groupValue: _selectedDateRangeTypeTemp,
                value: DateRangeEnum.lastWeek,
                onSelect: _setPeriodTemp,
              ),
              const Divider(height: 1, thickness: 1),

              // Este mês
              OctaRadioListTile(
                label: "Este mês",
                groupValue: _selectedDateRangeTypeTemp,
                value: DateRangeEnum.thisMonth,
                onSelect: _setPeriodTemp,
              ),
              const Divider(height: 1, thickness: 1),

              // Último mês
              OctaRadioListTile(
                label: "Ultimos mês",
                groupValue: _selectedDateRangeTypeTemp,
                value: DateRangeEnum.lastMonth,
                onSelect: _setPeriodTemp,
              ),
              const Divider(height: 1, thickness: 1),

              // Personalizado
              OctaRadioListTile(
                groupValue: _selectedDateRangeTypeTemp,
                value: DateRangeEnum.custom,
                onSelect: _selectCustomDate,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    OctaText.bodyLarge(
                      "Personalizado",
                    ),
                    if (_selectedDateTimeRangeTemp != null)
                      OctaText(
                        formatPeriod(_selectedDateTimeRangeTemp!),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const Divider(height: 1, thickness: 1),
        Padding(
          padding: const EdgeInsets.all(AppSizes.s04),
          child: OctaButton(text: "Filtrar", onTap: _filter),
        )
      ],
    );
  }
}
