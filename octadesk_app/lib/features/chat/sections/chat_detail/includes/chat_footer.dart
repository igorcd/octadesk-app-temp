import 'package:flutter/material.dart';
import 'package:octadesk_app/features/chat/providers/chat_detail_provider.dart';
import 'package:octadesk_app/features/chat/sections/chat_detail/components/input/chat_input_attachment_buttons.dart';
import 'package:octadesk_app/features/chat/sections/chat_detail/components/input/chat_input_textfield.dart';
import 'package:octadesk_app/features/chat/sections/chat_detail/components/input/chat_input_typing_buttons.dart';
import 'package:octadesk_app/features/chat/sections/chat_detail/components/input/chat_macro_button.dart';
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Texto de digitação
              Container(
                height: AppSizes.s04,
                padding: const EdgeInsets.symmetric(horizontal: AppSizes.s03_5),
                margin: const EdgeInsets.only(bottom: AppSizes.s00_5),
                child: Text(
                  value.annotationActive ? "ANOTAÇÃO INTERNA" : "",
                  style: TextStyle(
                    fontFamily: "Poppins",
                    fontSize: AppSizes.s02_5,
                    fontWeight: FontWeight.w600,
                    color: value.annotationActive ? colorScheme.tertiary : colorScheme.onBackground,
                  ),
                ),
              ),

              // Input
              AnimatedContainer(
                duration: const Duration(microseconds: 150),

                // Estilização
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(AppSizes.s02_5),
                  border: Border.all(color: value.inputInFocus || value.annotationActive ? focusColor : colorScheme.outline, width: 2),
                  color: value.annotationActive ? colorScheme.tertiaryContainer : colorScheme.surface,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    //
                    // Macros
                    ChatMacroButton(
                      active: value.inputController.text.isEmpty,
                      onTap: () => value.openMacrosDialog(context),
                    ),
                    // Mensagem
                    Expanded(
                      child: ChatInputTextField(
                        focusNode: value.inputFocusNode,
                        controller: value.inputController,
                        onSubmit: () => value.sendMessage(),
                      ),
                    ),

                    // Ações
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 150),
                      layoutBuilder: (currentChild, previousChildren) {
                        return Stack(
                          alignment: Alignment.centerRight,
                          children: [
                            ...previousChildren,
                            if (currentChild != null) currentChild,
                          ],
                        );
                      },

                      // Transição entre as ações
                      transitionBuilder: (child, animation) {
                        return FadeTransition(
                          opacity: animation,
                          child: SlideTransition(
                            position: Tween<Offset>(begin: const Offset(0.1, 0), end: const Offset(0, 0)).animate(animation),
                            child: child,
                          ),
                        );
                      },

                      // Conteúdo
                      child: value.inputController.text.isEmpty
                          ? ChatInputAttachmentButtons(
                              onOpenCamera: () => value.openCamera(context),
                              onOpenAttachments: () => value.attachFiles(context),
                              onOpenMicrophone: () => value.openVoiceRecorder(context),
                            )
                          : ChatInputTypingButtons(
                              onSubmit: () => value.sendMessage(),
                              onToogleInternalMessages: () => value.annotationActive = !value.annotationActive,
                              internalMessageActive: value.annotationActive,
                            ),
                    )
                  ],
                ),
              ),
            ],
          ),
        );

        // return Padding(
        //   padding: isMobile
        //       ? const EdgeInsets.only(top: AppSizes.s02, left: AppSizes.s04, right: AppSizes.s04, bottom: AppSizes.s04)
        //       : const EdgeInsets.only(top: AppSizes.s02, left: AppSizes.s06, right: AppSizes.s06, bottom: AppSizes.s06),

        //   // Container principal
        //   child: AnimatedContainer(
        //     duration: const Duration(milliseconds: 150),
        //     decoration: BoxDecoration(
        //       border: Border.all(color: value.inputInFocus ? focusColor : colorScheme.outline),
        //       borderRadius: BorderRadius.circular(AppSizes.s04),
        //       color: value.annotationActive ? colorScheme.tertiaryContainer : colorScheme.surface,
        //       boxShadow: [
        //         BoxShadow(
        //           color: colorScheme.primaryContainer,
        //           blurRadius: value.inputInFocus ? 10 : 0,
        //         )
        //       ],
        //     ),
        //     child: Column(
        //       children: [
        //         //
        //         // Header
        //         Container(
        //           padding: const EdgeInsets.only(left: AppSizes.s03),
        //           height: AppSizes.s10,
        //           child: Row(
        //             children: [
        //               //
        //               // Tab de mensagem
        //               ChatInputTab(text: "Mensagem", selected: !value.annotationActive, onTap: () => value.annotationActive = false),

        //               // Tab de anotações internas
        //               ChatInputTab(text: "Anotações internas", selected: value.annotationActive, onTap: () => value.annotationActive = true),
        //             ],
        //           ),
        //         ),

        //         // Input de texto
        //         ChatInputTextField(
        //           focusNode: value.inputFocusNode,
        //           controller: value.inputController,
        //           onSubmit: () => value.sendMessage(),
        //         ),
        //         const Divider(),

        //         // Ações
        //         Container(
        //           padding: const EdgeInsets.symmetric(horizontal: AppSizes.s02),
        //           height: AppSizes.s09,
        //           child: Row(
        //             children: [
        //               OctaIconButton(
        //                 onPressed: () => value.openMacrosDialog(context),
        //                 icon: AppIcons.macro,
        //                 size: AppSizes.s08,
        //                 iconSize: AppSizes.s05,
        //               ),
        //               OctaIconButton(
        //                 onPressed: () => value.attachFiles(context),
        //                 icon: AppIcons.attachVertical,
        //                 size: AppSizes.s08,
        //                 iconSize: AppSizes.s05,
        //               ),
        //               OctaIconButton(
        //                 onPressed: () => value.openVoiceRecorder(context),
        //                 icon: AppIcons.microphone,
        //                 size: AppSizes.s08,
        //                 iconSize: AppSizes.s05,
        //               ),
        //               // OctaIconButton(
        //               //   onPressed: () => value.openCamera(context),
        //               //   icon: AppIcons.camera,
        //               //   size: AppSizes.s08,
        //               //   iconSize: AppSizes.s05,
        //               // ),
        //               const Spacer(),

        //               // Enviar
        //               OctaIconButton(
        //                 onPressed: () => value.sendMessage(),
        //                 icon: AppIcons.send,
        //                 size: AppSizes.s08,
        //                 iconSize: AppSizes.s05,
        //               ),
        //             ],
        //           ),
        //         ),
        //       ],
        //     ),
        //   ),
        // );
      },
    );
  }
}
