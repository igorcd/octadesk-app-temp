import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:octadesk_app/utils/helper_functions.dart';
import 'package:octadesk_app/utils/tuple.dart';
import 'package:octadesk_core/enums/chat_channel_enum.dart';
import 'package:octadesk_core/models/index.dart';

enum RoomSeachByEnum {
  email,
  name,
  phone,
  id,
  comment,
}

enum DateRangeEnum {
  today,
  yesterday,
  lastWeek,
  lastMonth,
  thisMonth,
  custom,
}

enum OperationTypeEnum {
  agent,
  group,
}

enum RoomStatusQueryEnum {
  open,
  closed,
}

class RoomsQueryBuilder {
  int page;
  int limit;

  // Buscar por
  RoomSeachByEnum searchBy;

  // Status
  RoomStatusQueryEnum status;

  // Busca
  String query;

  // Canal
  ChatChannelEnum? channel;

  // Tags
  List<TagModel>? tags;

  // Operação
  Tuple<OperationTypeEnum, GroupListModel>? operation; // <Id, Nome>

  // Data
  Tuple<DateRangeEnum, DateTimeRange?>? dateRange;

  RoomsQueryBuilder({
    this.page = 1,
    this.limit = 20,
    this.status = RoomStatusQueryEnum.open,
    this.searchBy = RoomSeachByEnum.name,
    this.channel,
    this.tags,
    this.query = "",
    this.operation,
    this.dateRange,
  });

  /// Gerar a busca
  Map<dynamic, dynamic> _generateSearch(RoomSeachByEnum type, String value) {
    var types = {
      RoomSeachByEnum.email: {
        "property": "createdBy.email",
        "operator": "contains",
        "value": value,
      },
      RoomSeachByEnum.name: {
        "operator": "regex-contains",
        "property": "createdBy.name",
        "value": value,
      },
      RoomSeachByEnum.phone: {
        "property": "createdBy.phoneContacts.number",
        "onlyNumbers": true,
        "operator": "contains",
        "value": removePhoneMaskHelper(value),
      },
      RoomSeachByEnum.id: {
        "property": "number",
        "onlyNumbers": true,
        "operator": "equals",
        "value": value,
      },
      RoomSeachByEnum.comment: {
        "property": "messages.comment",
        "operator": "regex-contains",
        "value": value,
      },
    };

    return types[type]!;
  }

  /// Pegar o range de datas
  DateTimeRange? _getDateRange() {
    var now = DateTime.now();
    var todayEnd = DateTime(now.year, now.month, now.day, 23, 59, 59);
    var todayStart = DateUtils.dateOnly(now);
    var firstDayOfMonth = DateTime(now.year, now.month);

    var lastMonthStart = now.month == 1 ? DateTime(now.year - 1, 12) : DateTime(now.year, now.month - 1);
    var lastMonthEnd = DateTime(lastMonthStart.year, lastMonthStart.month, DateUtils.getDaysInMonth(lastMonthStart.year, lastMonthStart.month), 23, 59, 59);

    switch (dateRange?.item1) {
      // Hoje
      case DateRangeEnum.today:
        return DateTimeRange(start: todayStart, end: todayEnd);

      // Ontem
      case DateRangeEnum.yesterday:
        return DateTimeRange(start: todayStart.subtract(const Duration(days: 1)), end: todayEnd.subtract(const Duration(days: 1)));

      // Última semana
      case DateRangeEnum.lastWeek:
        return DateTimeRange(start: todayStart.subtract(const Duration(days: 7)), end: todayEnd);

      // Último mês
      case DateRangeEnum.lastMonth:
        return DateTimeRange(start: lastMonthStart, end: lastMonthEnd);

      // Este mês
      case DateRangeEnum.thisMonth:
        return DateTimeRange(start: firstDayOfMonth, end: todayEnd);

      // Customizado
      case DateRangeEnum.custom:
        return dateRange?.item2;

      default:
        return null;
    }
  }

  /// Gerar o mapa
  Map<String, dynamic> toMap() {
    // Query inicial
    Map<String, dynamic> dataToSend = {"page": page, "limit": limit};

    // Status
    if (status == RoomStatusQueryEnum.open) {
      dataToSend.addAll({
        "status": [0, 1, 3]
      });
    } else if (status == RoomStatusQueryEnum.closed) {
      dataToSend.addAll({
        "status": [2, 5, 7]
      });
    }

    // Query de busca
    if (query.isNotEmpty) {
      dataToSend.addAll(
        {
          "searches": [_generateSearch(searchBy, query)],
        },
      );
    }

    // Query de tags
    if ((tags ?? []).isNotEmpty) {
      dataToSend.addAll({"publicTags._id": tags!.map((e) => e.id).toList()});
    }

    // Query de canal
    if (channel != null) {
      dataToSend.addAll({"channel": channel!.name});
    }

    // Range de data
    var range = _getDateRange();
    if (range != null) {
      var formatter = DateFormat("yyyy-MM-ddTHH:mm:ss");
      var timeZone = DateTime.now().timeZoneOffset;
      var timeZoneString = timeZone.isNegative ? "-0${timeZone.inHours.abs()}:00" : "+0${timeZone.inHours.abs()}:00";

      dataToSend.addAll({
        "created": {
          "\$gte": formatter.format(range.start) + timeZoneString,
          "\$lte": formatter.format(range.end) + timeZoneString,
        }
      });
    }

    // Operação
    if (operation != null) {
      var propertyName = operation!.item1 == OperationTypeEnum.agent ? "agent._id" : "group._id";
      dataToSend.addAll({
        propertyName: operation!.item2.id,
      });
    }

    return dataToSend;
  }
}
