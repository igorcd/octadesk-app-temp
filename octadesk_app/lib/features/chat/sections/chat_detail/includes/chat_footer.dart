import 'package:flutter/material.dart';
import 'package:octadesk_app/components/index.dart';
import 'package:octadesk_app/features/chat/sections/chat_detail/components/input/chat_input_tab.dart';
import 'package:octadesk_app/features/chat/sections/chat_detail/components/input/chat_input_textfield.dart';
import 'package:octadesk_app/features/chat/providers/chat_detail_provider.dart';
import 'package:octadesk_app/resources/index.dart';
import 'package:provider/provider.dart';

class ChatFooter extends StatelessWidget {
  const ChatFooter({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;
    var isMobile = MediaQuery.of(context).size.width < 640;

    return Consumer<ChatDetailProvider>(
      builder: (context, value, child) {
        // Cor de foco
        Color focusColor = value.annotationActive ? colorScheme.tertiary : colorScheme.primary;

        return Padding(
          padding: isMobile
              ? const EdgeInsets.only(top: AppSizes.s02, left: AppSizes.s04, right: AppSizes.s04, bottom: AppSizes.s04)
              : const EdgeInsets.only(top: AppSizes.s02, left: AppSizes.s06, right: AppSizes.s06, bottom: AppSizes.s06),

          // Container principal
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            decoration: BoxDecoration(
              border: Border.all(color: value.inputInFocus ? focusColor : colorScheme.outline),
              borderRadius: BorderRadius.circular(AppSizes.s04),
              color: value.annotationActive ? colorScheme.tertiaryContainer : colorScheme.surface,
              boxShadow: [
                BoxShadow(
                  color: colorScheme.primaryContainer,
                  blurRadius: value.inputInFocus ? 10 : 0,
                )
              ],
            ),
            child: Column(
              children: [
                //
                // Header
                Container(
                  padding: const EdgeInsets.only(left: AppSizes.s03),
                  height: AppSizes.s10,
                  child: Row(
                    children: [
                      //
                      // Tab de mensagem
                      ChatInputTab(text: "Mensagem", selected: !value.annotationActive, onTap: () => value.annotationActive = false),

                      // Tab de anotações internas
                      ChatInputTab(text: "Anotações internas", selected: value.annotationActive, onTap: () => value.annotationActive = true),
                    ],
                  ),
                ),

                // Input de texto
                ChatInputTextField(
                  focusNode: value.inputFocusNode,
                  controller: value.inputController,
                  onSubmit: () => value.sendMessage(),
                ),
                const Divider(),

                // Ações
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: AppSizes.s02),
                  height: AppSizes.s09,
                  child: Row(
                    children: [
                      OctaIconButton(
                        onPressed: () => value.openMacrosDialog(context),
                        icon: AppIcons.macro,
                        size: AppSizes.s08,
                        iconSize: AppSizes.s05,
                      ),
                      OctaIconButton(
                        onPressed: () => value.attachFiles(context),
                        icon: AppIcons.attachVertical,
                        size: AppSizes.s08,
                        iconSize: AppSizes.s05,
                      ),
                      OctaIconButton(
                        onPressed: () => value.openVoiceRecorder(context),
                        icon: AppIcons.microphone,
                        size: AppSizes.s08,
                        iconSize: AppSizes.s05,
                      ),
                      // OctaIconButton(
                      //   onPressed: () => value.openCamera(context),
                      //   icon: AppIcons.camera,
                      //   size: AppSizes.s08,
                      //   iconSize: AppSizes.s05,
                      // ),
                      const Spacer(),

                      // Enviar
                      OctaIconButton(
                        onPressed: () => value.sendMessage(),
                        icon: AppIcons.send,
                        size: AppSizes.s08,
                        iconSize: AppSizes.s05,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
