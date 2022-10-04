import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:octadesk_app/components/index.dart';
import 'package:octadesk_app/resources/app_constants.dart';
import 'package:octadesk_core/octadesk_core.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'dart:math';

/// Mostrar um alert
void displayAlertHelper(BuildContext context, {String? title, required String subtitle, List<OctaAlertDialogAction>? actions}) {
  showDialog(
    context: context,
    builder: (context) {
      return OctaAlertDialog(
        title: title ?? "Atenção",
        subtitle: subtitle,
        actions: actions,
      );
    },
  );
}

/// Formatar bytes
String formatBytesHelper(int bytes, int decimals) {
  if (bytes <= 0) return "0 B";

  const suffixes = ["b", "kb", "mb", "gb", "tb", "pb", "eb", "zb", "yb"];
  var i = (log(bytes) / log(1024)).floor();
  return "${(bytes / pow(1024, i)).toStringAsFixed(decimals)} ${suffixes[i]}";
}

AppLocalizations l10n(BuildContext context) {
  return AppLocalizations.of(context)!;
}

Future<T?> showOctaBottomSheet<T>(
  BuildContext context, {
  required String title,
  required Widget child,
  OctaBottomSheetAction? action,
  ValueNotifier<int>? stack,
}) async {
  var positionStack = stack ?? ValueNotifier(0);
  positionStack.value += 1;

  var currentPosition = positionStack.value;

  var resp = await showGeneralDialog<T>(
    context: context,
    pageBuilder: (context, animation, secondaryAnimation) {
      return ValueListenableBuilder<int>(
        valueListenable: stack ?? ValueNotifier(0),
        child: child,
        builder: (context, value, child) {
          return OctaBottomSheet(
            animation: animation,
            title: title,
            stackPosition: value,
            action: action,
            currentPosition: currentPosition,
            child: child!,
          );
        },
      );
    },
  );
  positionStack.value -= 1;
  return resp;
}

void openExternalLink(BuildContext context, String link) {
  if (!link.startsWith("http")) {
    link = "https://$link";
  }
  displayAlertHelper(context, title: "Atenção", subtitle: "Você será redirecionado para um link externo, deseja continuar?", actions: [
    OctaAlertDialogAction(primary: false, action: () {}, text: "Voltar"),
    OctaAlertDialogAction(
        primary: true,
        action: () {
          launchUrlString(link, mode: LaunchMode.externalApplication);
        },
        text: "Sim"),
  ]);
}

String dateFormatterHelper(DateTime date) {
  var difference = DateUtils.dateOnly(DateTime.now()).difference(DateUtils.dateOnly(date)).inDays;

  if (difference == 0) {
    return "Hoje";
  }
  if (difference == 1) {
    return "Ontem";
  }
  if (difference > 1 && difference < 4) {
    var weekDays = ["Domingo", "Segunda", "Terça", "Quarta", "Quinta", "Sexta", "Sábado", "Domingo"];
    return weekDays[date.weekday];
  } else {
    return DateFormat("dd 'de' MMMM 'de' yyyy", "pt_BR").format(date);
  }
}

Future<RoomFilterEnum> getPersistedInboxFilter(String agentId) async {
  // Verificar se tem um inbox salvo
  final storage = await SharedPreferences.getInstance();
  var currentInboxString = storage.getString(AppConstants.currentInboxFilter);
  var currentInboxType = currentInboxString != null
      ? RoomFilterEnum.values.firstWhereOrNull((element) => element.name == currentInboxString) ?? RoomFilterEnum.open //
      : RoomFilterEnum.open;

  return currentInboxType;
}

String getInboxFilterEnumName(RoomFilterEnum filter) {
  if (filter == RoomFilterEnum.open) {
    return "Todas as conversas";
  }
  if (filter == RoomFilterEnum.mine) {
    return "Suas conversas";
  }
  if (filter == RoomFilterEnum.notAnswered) {
    return "Não respondidas";
  }
  if (filter == RoomFilterEnum.mentions) {
    return "Menções";
  }
  if (filter == RoomFilterEnum.participations) {
    return "Participações";
  }
  if (filter == RoomFilterEnum.notAssigned) {
    return "Não atribuídas";
  }
  if (filter == RoomFilterEnum.bot) {
    return "Conversas do bot";
  }
  return "";
}

DateFormat dateTimeFormatterHelper() {
  return DateFormat("dd/MM/yyyy '•' HH:mm", "pt_BR");
}

/// Colocar máscara em um número de telefone
String setPhoneMaskHelper(String phone) {
  var phoneToFormat = phone.replaceAll("+", "");
  if (phoneToFormat.length < 12 || phoneToFormat.length > 13) {
    return phoneToFormat;
  }
  var countryCode = phoneToFormat.substring(0, 2);
  var ddd = phoneToFormat.substring(2, 4);
  var firstPart = phoneToFormat.length == 12 ? phoneToFormat.substring(4, 8) : phoneToFormat.substring(4, 9);
  var secondPart = phoneToFormat.length == 12 ? phoneToFormat.substring(8, 12) : phoneToFormat.substring(9, 13);
  return "+$countryCode ($ddd) $firstPart-$secondPart";
}

/// Remover máscara de telefone
String removePhoneMaskHelper(String phone) {
  return phone.replaceAll(RegExp("[ )(-]"), "");
}

/// Formatar data
DateFormat formatDateHelper() {
  return DateFormat('dd/MM/yyyy');
}

/// Formatar período de data
String formatPeriod(DateTimeRange range) {
  return "${formatDateHelper().format(range.start)} - ${formatDateHelper().format(range.end)}";
}

// Formatar duração
String formatDurationHelper(Duration duration) {
  return "${duration.inMinutes.toString().padLeft(2, "0")}:${duration.inSeconds.toString().padLeft(2, "0")}";
}
