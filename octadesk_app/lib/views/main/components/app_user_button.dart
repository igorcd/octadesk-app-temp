import 'package:flutter/material.dart';
import 'package:octadesk_app/providers/authentication_provider.dart';
import 'package:octadesk_app/resources/index.dart';
import 'package:octadesk_core/octadesk_core.dart';
import 'package:provider/provider.dart';

import '../../../components/index.dart';

class AppUserButton extends StatelessWidget {
  const AppUserButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var authenticationProvider = Provider.of<AuthenticationProvider>(context);

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

    /// Informações do usuário
    Widget userInformation(UserModel user) {
      return OctaAvatar(
        name: user.name,
        source: user.avatar,
        // size: AppSizes.s13,
        size: AppSizes.s13,
        badge: Container(
          width: AppSizes.s05,
          height: AppSizes.s05,
          decoration: BoxDecoration(
            color: connectionStatusColor(ConnectionStatusEnum.offline),
            borderRadius: const BorderRadius.all(Radius.circular(AppSizes.s04)),
            border: Border.all(color: Colors.white, width: 2),
          ),
        ),
      );
    }

    /// Botão de mudar o status da conexão
    PopupMenuItem statusChangeButton(ConnectionStatusEnum status) {
      return PopupMenuItem(
        height: 40,
        padding: const EdgeInsets.symmetric(horizontal: AppSizes.s06),
        child: Row(
          children: [
            Container(
              margin: const EdgeInsets.only(right: AppSizes.s04),
              width: AppSizes.s04,
              height: AppSizes.s04,
              decoration: BoxDecoration(color: connectionStatusColor(status), borderRadius: BorderRadius.circular(AppSizes.s04)),
            ),
            OctaText.bodySmall(connectionStatusEnumParser(status))
          ],
        ),
      );
    }

    /// Menu item
    PopupMenuItem popupMenuOption({required String text, required void Function() onTap}) {
      return PopupMenuItem(
        onTap: onTap,
        padding: const EdgeInsets.symmetric(horizontal: AppSizes.s06),
        height: 40,
        child: Row(
          children: [OctaText.bodySmall(text)],
        ),
      );
    }

    return OctaAvatar(
      name: "João Silva",
      // name: authenticationProvider.user!.name,
      // source: authenticationProvider.user!.avatar,
      // size: AppSizes.s13,
      size: AppSizes.s13,
      badge: Container(
        width: AppSizes.s05,
        height: AppSizes.s05,
        decoration: BoxDecoration(
          color: connectionStatusColor(ConnectionStatusEnum.offline),
          borderRadius: const BorderRadius.all(Radius.circular(AppSizes.s04)),
          border: Border.all(color: Colors.white, width: 2),
        ),
      ),
    );

    // return Container(
    //   padding: const EdgeInsets.all(AppSizes.s02),
    //   height: 75,
    //   child: PopupMenuButton(
    //     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSizes.s02)),
    //     constraints: const BoxConstraints(minWidth: 300),
    //     itemBuilder: (context) {
    //       return [
    //         // Informações do usuário
    //         PopupMenuItem(
    //           padding: const EdgeInsets.only(left: AppSizes.s04, right: AppSizes.s04, top: AppSizes.s02, bottom: AppSizes.s04),
    //           enabled: false,
    //           child: userInformation(authenticationProvider.user!),
    //         ),

    //         // Status da conexão
    //         statusChangeButton(ConnectionStatusEnum.online),
    //         statusChangeButton(ConnectionStatusEnum.busy),
    //         statusChangeButton(ConnectionStatusEnum.offline),

    //         // Divisória
    //         PopupMenuItem(
    //           padding: EdgeInsets.zero,
    //           enabled: false,
    //           height: AppSizes.s03,
    //           child: Divider(
    //             height: 1,
    //             color: AppColors.info.shade200,
    //           ),
    //         ),
    //         popupMenuOption(text: "Desconectar", onTap: () => authenticationProvider.logout(context)),
    //       ];
    //     },
    //     child: Padding(
    //       padding: const EdgeInsets.all(AppSizes.s00_5),
    //       child: userInformation(authenticationProvider.user!),
    //     ),
    //   ),
    // );
  }
}
