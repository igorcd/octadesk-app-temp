import 'dart:ui';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:octadesk_app/features/chat/sections/conversation_detail/components/macros/chat_macros_list_item.dart';
import 'package:octadesk_app/features/chat/sections/conversation_detail/components/mentions/chat_mentions_empty.dart';
import 'package:octadesk_app/features/chat/providers/conversation_detail_provider.dart';
import 'package:octadesk_app/resources/index.dart';
import 'package:octadesk_core/octadesk_core.dart';
import 'package:provider/provider.dart';

class ChatMacrosContainer extends StatelessWidget {
  const ChatMacrosContainer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: AppSizes.s04,
      left: AppSizes.s06,
      right: AppSizes.s06,
      child: Consumer<ConversationDetailProvider>(
        builder: (context, value, child) {
          return AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: value.macrosFuture != null
                ? PhysicalModel(
                    color: Colors.transparent,
                    borderRadius: const BorderRadius.all(Radius.circular(AppSizes.s03)),
                    elevation: 8,
                    shadowColor: const Color.fromRGBO(0, 0, 0, .55),

                    // Clip do efeito de backdrop
                    child: ClipRRect(
                      borderRadius: const BorderRadius.all(
                        Radius.circular(AppSizes.s03),
                      ),
                      child: BackdropFilter(
                        //
                        // Efeito Blur
                        filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),

                        // Container principal
                        child: FutureBuilder<List<MacroDTO>>(
                          future: value.macrosFuture,
                          builder: (context, snapshot) {
                            Widget child;
                            List<MacroDTO> filteredMacros = [];

                            // Carregando
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              child = const ChatMacrosListItem(title: "Carregando...");
                            }

                            // Em caso de erro
                            else if (snapshot.hasError) {
                              child = const ChatMacrosListItem(title: "Não conseguimoos carregar as mensagens rápidas, tente novamente em breve");
                            }

                            // Em caso de não possuir macros
                            else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                              child = const ChatMacrosListItem(title: "Não foram encontradas mensagens rápidas");
                            }

                            // Lista de macros
                            else {
                              filteredMacros = value.macrosFilter.isNotEmpty
                                  ? snapshot.data!.where((e) {
                                      return e.getComment().toLowerCase().contains(value.macrosFilter) || e.name.toLowerCase().contains(value.macrosFilter);
                                    }).toList()
                                  : snapshot.data!;
                              // Caso não encontre nenhuma mensagem rápida
                              if (filteredMacros.isEmpty) {
                                child = const ChatMentionsEmpty("Não foram encontradas mensagens rápdias");
                              }

                              // Lista ge mensagens rápidas
                              else {
                                child = ListView.separated(
                                  controller: ScrollController(),
                                  itemCount: filteredMacros.length,
                                  reverse: true,
                                  separatorBuilder: (context, index) => const Divider(thickness: 2, height: 2),
                                  itemBuilder: (context, index) {
                                    var macro = filteredMacros[index];
                                    return ChatMacrosListItem(
                                      title: macro.name,
                                      content: macro.getComment(),
                                      onPressed: () => value.selectMacro(macro),
                                    );
                                  },
                                );
                              }
                            }

                            return AnimatedContainer(
                              duration: const Duration(milliseconds: 150),
                              // Altura do conainer
                              height: (AppSizes.s15 + 2) * math.min(math.max(filteredMacros.length, 1), 3),

                              // Estilização
                              decoration: BoxDecoration(
                                border: Border.all(color: AppColors.gray100),
                                borderRadius: const BorderRadius.all(Radius.circular(AppSizes.s03)),
                                color: const Color.fromRGBO(255, 255, 255, .9),
                              ),
                              //
                              // Lista de macros
                              child: child,
                            );
                          },
                        ),
                      ),
                    ),
                  )
                : const SizedBox.shrink(),
          );
        },
      ),
    );
  }
}
