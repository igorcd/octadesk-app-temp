import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:octadesk_app/features/chat/providers/chat_detail_provider.dart';
import 'package:octadesk_app/features/chat/sections/chat_detail/components/attachments/attachment_list_tile.dart';
import 'package:octadesk_app/resources/index.dart';
import 'package:provider/provider.dart';

class ChatAttachments extends StatelessWidget {
  const ChatAttachments({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: AppSizes.s22_5,
      child: Consumer<ChatDetailProvider>(
        builder: (context, value, child) {
          return ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: AppSizes.s05),
            itemCount: value.attachedFiles.length,
            scrollDirection: Axis.horizontal,
            separatorBuilder: (c, i) => const SizedBox(width: AppSizes.s04),
            itemBuilder: (context, index) => AttachmentListTile(
              file: value.attachedFiles[index],
              onDismissed: () => value.removeAttachment(index),
            ),
          );
        },
      ),
    );
  }
}
