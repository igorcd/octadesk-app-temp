import 'package:flutter/material.dart';
import 'package:octadesk_app/features/chat/menu/chat_module_menu.dart';
import 'package:octadesk_app/features/chat/chat_module_content.dart';
import 'package:octadesk_app/features/chat/providers/conversations_provider.dart';
import 'package:octadesk_app/router/features_router.dart';
import 'package:provider/provider.dart';

import '../base_feature/octa_feature.dart';

class ChatModule extends StatelessWidget {
  const ChatModule({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ConversationsProvider()),
      ],
      child: const OctaFeature(
        selectedMenu: FeaturesRouter.chatModule,

        // Menu
        menu: [
          ChatModuleMenu(),
        ],

        // Conteúdo
        content: ChatModuleContent(),
      ),
    );
  }
}
