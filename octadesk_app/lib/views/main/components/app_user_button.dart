import 'package:flutter/material.dart';
import 'package:octadesk_app/providers/authentication_provider.dart';
import 'package:octadesk_app/resources/index.dart';
import 'package:octadesk_conversation/octadesk_conversation.dart';
import 'package:octadesk_core/octadesk_core.dart';
import 'package:provider/provider.dart';

import '../../../components/index.dart';
import '../../../components/responsive/responsive_widgets.dart';

class AppUserButton extends StatelessWidget {
  const AppUserButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var isMd = MediaQuery.of(context).size.width < ScreenSize.md;

    var authenticationProvider = Provider.of<AuthenticationProvider>(context);

    /// Cor do status
    Color connectionStatusColor(ConnectionStatusEnum? status) {
      switch (status) {
        case ConnectionStatusEnum.online:
          return Colors.green;
        case ConnectionStatusEnum.offline:
          return Colors.blueGrey;
        case ConnectionStatusEnum.busy:
          return Colors.yellow;
        default:
          return Colors.transparent;
      }
    }

    Widget userAvatar(ConnectionStatusEnum status) {
      return OctaAvatar(
        name: authenticationProvider.user!.name,
        source: authenticationProvider.user!.avatar,
        size: isMd ? AppSizes.s09 : AppSizes.s13,
        badge: Container(
          width: isMd ? AppSizes.s04 : AppSizes.s05,
          height: isMd ? AppSizes.s04 : AppSizes.s05,
          decoration: BoxDecoration(
            color: connectionStatusColor(status),
            borderRadius: const BorderRadius.all(Radius.circular(AppSizes.s04)),
            border: Border.all(color: Colors.white, width: 2),
          ),
        ),
      );
    }

    /// Parser do enum
    String connectionStatusEnumParser(ConnectionStatusEnum? status) {
      switch (status) {
        case ConnectionStatusEnum.online:
          return "Disponível";
        case ConnectionStatusEnum.offline:
          return "Offline";
        case ConnectionStatusEnum.busy:
          return "Ausente";
        default:
          return "Carregando";
      }
    }

    /// Informações do usuário
    Widget userInformation(ConnectionStatusEnum status) {
      return Row(
        children: [
          userAvatar(status),
          const SizedBox(width: AppSizes.s02),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                OctaText.titleMedium(authenticationProvider.user!.name),
                OctaText.titleSmall(connectionStatusEnumParser(status)),
              ],
            ),
          )
        ],
      );
    }

    /// Botão de mudar o status da conexão
    PopupMenuItem<String> statusChangeButton(ConnectionStatusEnum status) {
      return PopupMenuItem(
        height: 40,
        padding: const EdgeInsets.symmetric(horizontal: AppSizes.s06),
        child: Row(
          children: [
            Container(
              margin: const EdgeInsets.only(right: AppSizes.s04),
              width: AppSizes.s04,
              height: AppSizes.s04,
              decoration: BoxDecoration(
                color: connectionStatusColor(status),
                borderRadius: BorderRadius.circular(AppSizes.s04),
              ),
            ),
            OctaText.bodySmall(connectionStatusEnumParser(status))
          ],
        ),
      );
    }

    /// Menu item
    PopupMenuItem<String> popupMenuOption({required String text}) {
      return PopupMenuItem<String>(
        padding: const EdgeInsets.symmetric(horizontal: AppSizes.s06),
        value: "logout",
        height: 40,
        child: Row(
          children: [OctaText.bodySmall(text)],
        ),
      );
    }

    void onSelectPopupOption(String value) {
      if (value == 'logout') {
        authenticationProvider.logout(context);
      }
    }

    return StreamBuilder<ConnectionStatusEnum?>(
      // Obersvar mudança de status
      stream: OctadeskConversation.instance.getAgentConnectionStatusStream(),
      builder: (context, snapshot) {
        //
        // Status do usuário
        var connectionStatus = snapshot.data ?? ConnectionStatusEnum.offline;

        return PopupMenuButton<String>(
          onSelected: onSelectPopupOption,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSizes.s02)),

          constraints: const BoxConstraints(minWidth: 250),

          // Avatar do usuário
          child: userAvatar(connectionStatus),
          itemBuilder: (context) {
            return [
              // Informações do usuário
              PopupMenuItem(
                padding: const EdgeInsets.only(left: AppSizes.s04, right: AppSizes.s04, top: AppSizes.s02, bottom: AppSizes.s04),
                enabled: false,
                child: userInformation(connectionStatus),
              ),

              // Status da conexão
              statusChangeButton(ConnectionStatusEnum.online),
              statusChangeButton(ConnectionStatusEnum.busy),
              statusChangeButton(ConnectionStatusEnum.offline),

              // Divisória
              PopupMenuItem(
                padding: EdgeInsets.zero,
                enabled: false,
                height: AppSizes.s03,
                child: Divider(
                  height: 1,
                  color: AppColors.info.shade200,
                ),
              ),
              popupMenuOption(text: "Desconectar"),
            ];
          },
        );
      },
    );
  }
}
