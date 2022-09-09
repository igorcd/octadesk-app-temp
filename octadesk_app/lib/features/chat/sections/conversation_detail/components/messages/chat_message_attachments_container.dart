import 'package:flutter/material.dart';
import 'package:octadesk_app/features/chat/sections/conversation_detail/components/media/media_audio_container.dart';
import 'package:octadesk_app/features/chat/sections/conversation_detail/components/media/media_container.dart';
import 'package:octadesk_app/features/chat/sections/conversation_detail/components/media/media_document_container.dart';
import 'package:octadesk_app/features/chat/sections/conversation_detail/components/media/media_more_attachments._container.dart';
import 'package:octadesk_app/features/chat/sections/conversation_detail/components/media/media_not_supported_container.dart';
import 'package:octadesk_app/features/chat/sections/conversation_detail/components/media/media_picture_container.dart';
import 'package:octadesk_app/features/chat/sections/conversation_detail/components/media/media_video_container.dart';
import 'package:octadesk_app/resources/index.dart';
import 'package:octadesk_core/models/message/message_attachment.dart';
import 'package:octadesk_core/octadesk_core.dart';
import 'dart:math' as math;

class ChatMessageAttachmentsContainer extends StatefulWidget {
  final List<MessageAttachment> attachments;
  const ChatMessageAttachmentsContainer({required this.attachments, Key? key}) : super(key: key);

  @override
  State<ChatMessageAttachmentsContainer> createState() => _ChatMessageAttachmentsContainerState();
}

// TODO - IMPLEMENTAR
class _ChatMessageAttachmentsContainerState extends State<ChatMessageAttachmentsContainer> {
  @override
  Widget build(BuildContext context) {
    // /// Quando selecionar um attachemtn
    // void _onSelectAttachment(int index) {
    //   Navigator.of(context).pushNamed(
    //     PrivateRouter.galleryView,
    //     arguments: GalleryRouterParams(
    //       attachments: widget.attachments,
    //       initialIndex: index,
    //     ),
    //   );
    // }

    // Future<String> _downloadFile(MessageAttachment attachment, String directory, bool checkIfExists) async {
    //   var provider = Provider.of<MediaProvider>(context, listen: false);
    //   return await provider.downloadFile(url: attachment.url, subdirectory: directory, checkIfExists: checkIfExists);
    // }

    // /// Fazer download do arquivo
    // void _onDownload(MessageAttachment attachment, String directory) async {
    //   ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    //     content: Text("Download iniciado"),
    //     duration: Duration(seconds: 1),
    //   ));

    //   try {
    //     var filePath = await _downloadFile(attachment, directory, false);

    //     if (mounted) {
    //       ScaffoldMessenger.of(context).showSnackBar(
    //         SnackBar(
    //           content: Text("Download concluído"),
    //           action: SnackBarAction(
    //             label: "Abrir",
    //             onPressed: () {
    //               OpenFile.open(filePath);
    //             },
    //           ),
    //         ),
    //       );
    //     }
    //   } catch (e) {
    //     if (mounted) {
    //       ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Não foi possível realizar o download, tente novamente em breve")));
    //     }
    //   }
    // }

    // /// Compartilhar arquivo
    // void _onShare(MessageAttachment attachment, String directory) async {
    //   try {
    //     var provider = Provider.of<MediaProvider>(context, listen: false);
    //     provider.shareFile(url: attachment.url, subdirectory: directory);
    //   } catch (e) {
    //     if (mounted) {
    //       ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Não foi possível realizar o download, tente novamente em breve")));
    //     }
    //   }
    // }

    return Container(
      padding: const EdgeInsets.all(AppSizes.s01),
      child: LayoutBuilder(
        builder: (context, constraints) {
          //
          // Limitar total de celulas a quatro
          var totalCells = math.min(widget.attachments.length, 4);

          // Tamanho de uma celula
          var cellSize = ((constraints.maxWidth - AppSizes.s01) / 2).floor().toDouble();

          // Tamanho dos elementos
          var cellsWidth = List.generate(totalCells, (index) {
            return totalCells <= 2 || totalCells == 3 && index + 1 == 3 ? constraints.maxWidth : cellSize;
          });

          return Wrap(
            alignment: WrapAlignment.center,
            spacing: AppSizes.s01,
            runSpacing: AppSizes.s01,
            children: List.generate(
              totalCells,
              (index) {
                final attachment = widget.attachments[index];
                final width = totalCells == 1 ? null : cellsWidth[index];
                final height = totalCells == 1 ? null : cellSize.toDouble();
                final isVertical = width != null;

                // Caso seja o último anexo e possuir mais de 4
                if (widget.attachments.length > 4 && index == 3) {
                  return MediaContainer(
                    width: width,
                    height: height,
                    showDropdown: false,
                    child: const MediaMoreAttachmentsContainer(),
                    onPressed: () {},
                  );
                }

                if (attachment.isUnsupported) {
                  return MediaNotSupportedContainer(attachment: attachment);
                }

                // Caso seja uma imagem
                if (attachment.type == AttachmentTypeEnum.photo) {
                  return MediaContainer(
                    width: width,
                    height: totalCells == 1 ? 300 : height,
                    onDownload: () {},
                    onShare: () {},
                    onPressed: () {},
                    showDropdown: attachment.localFilePath == null,
                    child: MediaPictureContainer(
                      stretchImage: widget.attachments.length > 1,
                      attachment: attachment,
                    ),
                  );
                }

                // Caso seja um áudio
                if (attachment.type == AttachmentTypeEnum.audio) {
                  return MediaContainer(
                    width: width,
                    height: height ?? AppSizes.s18,
                    onDownload: () {},
                    onShare: () {},
                    onPressed: () {},
                    showDropdown: attachment.localFilePath == null,
                    child: MediaAudioContainer(
                      attachment: attachment,
                      isVertical: isVertical,
                    ),
                  );
                }

                // Caso seja um vídeo
                if (attachment.type == AttachmentTypeEnum.video) {
                  return MediaContainer(
                    width: width,
                    height: totalCells == 1 ? null : height,
                    onDownload: () {},
                    onShare: () {},
                    onPressed: () {},
                    showDropdown: attachment.localFilePath == null,
                    child: MediaVideoContainer(
                      stretchImage: widget.attachments.length > 1,
                      attachment: attachment,
                    ),
                  );
                }

                // Caso seja um documento
                return MediaContainer(
                  width: width,
                  height: height ?? AppSizes.s18,
                  onDownload: () {},
                  onShare: () {},
                  onPressed: () {},
                  showDropdown: attachment.localFilePath == null,
                  child: MediaDocumentContainer(
                    attachment: attachment,
                    isVertical: isVertical,
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
