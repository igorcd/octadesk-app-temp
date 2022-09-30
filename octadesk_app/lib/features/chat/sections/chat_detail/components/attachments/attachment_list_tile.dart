import 'package:flutter/material.dart';
import 'package:octadesk_app/features/chat/sections/chat_detail/components/attachments/attachment_container.dart';
import 'package:octadesk_app/resources/index.dart';

class AttachmentListTile extends StatelessWidget {
  final String file;
  final void Function() onDismissed;
  const AttachmentListTile({required this.file, required this.onDismissed, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(file),

      // Botão de excluir
      background: Center(
        child: Container(
          width: AppSizes.s12,
          height: AppSizes.s12,
          decoration: BoxDecoration(
            color: AppColors.danger.shade500,
            borderRadius: const BorderRadius.all(Radius.circular(AppSizes.s06)),
          ),
          child: Center(
            child: Image.asset(
              AppIcons.trash,
              width: AppSizes.s08,
              color: Colors.white,
            ),
          ),
        ),
      ),
      direction: DismissDirection.up,

      // Excluir arquivo
      onDismissed: (direction) => onDismissed(),

      // Container
      child: AttachmentContainer(
        fileDirectory: file,
      ),
    );
  }
}
