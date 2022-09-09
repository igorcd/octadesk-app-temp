import 'dart:io';

import 'package:flutter/material.dart';
import 'package:octadesk_app/resources/index.dart';
import 'package:octadesk_core/models/message/message_attachment.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

class MediaVideoContainer extends StatefulWidget {
  final MessageAttachment attachment;
  final bool stretchImage;
  const MediaVideoContainer({required this.attachment, required this.stretchImage, Key? key}) : super(key: key);

  @override
  State<MediaVideoContainer> createState() => _MediaVideoContainerState();
}

class _MediaVideoContainerState extends State<MediaVideoContainer> {
  bool _loading = true;
  File? _file;

  void _loadThumbnail() async {
    var dir = await getTemporaryDirectory();

    // TODO - VERIFICAR QUESTÃO NO WINDOWS
    var fileName = await VideoThumbnail.thumbnailFile(
      video: widget.attachment.localFilePath != null ? widget.attachment.localFilePath! : widget.attachment.url,
      thumbnailPath: dir.path,
      imageFormat: ImageFormat.JPEG,
      maxHeight: 150, // specify the height of the thumbnail, let the width auto-scaled to keep the source aspect ratio
      quality: 75,
    );

    if (fileName != null && mounted) {
      _file = File(fileName);
      setState(() {
        _loading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _loadThumbnail();
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: widget.stretchImage ? 1 : 16 / 9,
      child: Container(
        color: Colors.black87,
        child: Stack(
          children: [
            Positioned.fill(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: _loading
                    ? const SizedBox.shrink()
                    : Image.file(
                        _file!,
                        width: double.infinity,
                        height: double.infinity,
                        alignment: Alignment.center,
                        fit: BoxFit.cover,
                      ),
              ),
            ),
            Center(
              child: Container(
                width: AppSizes.s16,
                height: AppSizes.s16,
                alignment: Alignment.center,
                decoration: const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(AppSizes.s08)), color: Colors.black45),
                child: Image.asset(
                  AppIcons.play,
                  width: AppSizes.s10,
                  color: Colors.white,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
