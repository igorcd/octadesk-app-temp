import 'package:flutter/material.dart';
import 'package:octadesk_core/models/message/message_attachment.dart';

class ChatMessageAttachmentsContainer extends StatelessWidget {
  final List<MessageAttachment> attachments;
  const ChatMessageAttachmentsContainer({required this.attachments, Key? key}) : super(key: key);

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

    return Wrap(
      direction: Axis.horizontal,
      runSpacing: 6,
      spacing: 6,
      children: [
        SizedBox(width: 147, child: AspectRatio(aspectRatio: 1, child: Container(color: Colors.red))),
        SizedBox(width: 147, child: AspectRatio(aspectRatio: 1, child: Container(color: Colors.blue))),
        SizedBox(width: 300, child: AspectRatio(aspectRatio: 2, child: Container(color: Colors.blue))),
      ],
    );

    // return LayoutBuilder(
    //   builder: (context, constraints) {
    //     //
    //     // Limitar total de celulas a quatro
    //     var totalCells = math.min(attachments.length, 4);

    //     // Tamanho de uma celula
    //     var cellSize = ((constraints.maxWidth - AppSizes.s01) / 2).floor().toDouble();

    //     // Tamanho dos elementos
    //     var cellsWidth = List.generate(totalCells, (index) {
    //       return totalCells <= 2 || totalCells == 3 && index + 1 == 3 ? constraints.maxWidth : cellSize;
    //     });

    //     return Wrap(
    //       alignment: WrapAlignment.center,
    //       spacing: AppSizes.s01,
    //       runSpacing: AppSizes.s01,
    //       children: List.generate(
    //         totalCells,
    //         (index) {
    //           final attachment = attachments[index];
    //           final width = totalCells == 1 ? null : cellsWidth[index];
    //           final height = totalCells == 1 ? null : cellSize.toDouble();
    //           final isVertical = width != null;

    //           // Caso seja o último anexo e possuir mais de 4
    //           if (attachments.length > 4 && index == 3) {
    //             return MediaContainer(
    //               width: width,
    //               height: height,
    //               showDropdown: false,
    //               child: const MediaMoreAttachmentsContainer(),
    //               onPressed: () {},
    //             );
    //           }

    //           if (attachment.isUnsupported) {
    //             return MediaNotSupportedContainer(attachment: attachment);
    //           }

    //           // Caso seja uma imagem
    //           if (attachment.type == AttachmentTypeEnum.photo) {
    //             return MediaContainer(
    //               width: width,
    //               height: totalCells == 1 ? 300 : height,
    //               onDownload: () {},
    //               onShare: () {},
    //               onPressed: () {},
    //               showDropdown: attachment.localFilePath == null,
    //               child: MediaPictureContainer(
    //                 stretchImage: attachments.length > 1,
    //                 attachment: attachment,
    //               ),
    //             );
    //           }

    //           // Caso seja um áudio
    //           if (attachment.type == AttachmentTypeEnum.audio) {
    //             return MediaContainer(
    //               width: width,
    //               height: height ?? AppSizes.s18,
    //               showDropdown: attachment.localFilePath == null,
    //               child: MediaAudioContainer(
    //                 attachment: attachment,
    //                 isVertical: isVertical,
    //               ),
    //             );
    //           }

    //           // Caso seja um vídeo
    //           if (attachment.type == AttachmentTypeEnum.video) {
    //             return MediaContainer(
    //               width: width,
    //               height: totalCells == 1 ? null : height,
    //               onDownload: () {},
    //               onShare: () {},
    //               onPressed: () {},
    //               showDropdown: attachment.localFilePath == null,
    //               child: MediaVideoContainer(
    //                 stretchImage: attachments.length > 1,
    //                 attachment: attachment,
    //               ),
    //             );
    //           }

    //           // Caso seja um documento
    //           return MediaContainer(
    //             width: width,
    //             height: height ?? AppSizes.s18,
    //             onDownload: () {},
    //             onShare: () {},
    //             onPressed: () {},
    //             showDropdown: attachment.localFilePath == null,
    //             child: MediaDocumentContainer(
    //               attachment: attachment,
    //               isVertical: isVertical,
    //             ),
    //           );
    //         },
    //       ),
    //     );
    // },
    // );
  }
}
