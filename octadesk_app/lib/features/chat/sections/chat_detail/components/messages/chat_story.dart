import 'package:flutter/material.dart';
import 'package:octadesk_app/resources/index.dart';
import 'package:octadesk_app/utils/helper_functions.dart';
import 'package:octadesk_core/models/message/message_story.dart';
import 'package:transparent_image/transparent_image.dart';

class ChatStory extends StatelessWidget {
  final MessageStory story;
  const ChatStory(this.story, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.hardEdge,
      margin: const EdgeInsets.only(bottom: AppSizes.s01),
      width: 150,
      height: 268,
      decoration: BoxDecoration(
        color: AppColors.info.shade100,
        borderRadius: BorderRadius.circular(AppSizes.s03),
      ),
      child: GestureDetector(
        onTap: () => openExternalLink(context, story.link),
        child: Stack(
          children: [
            Positioned.fill(
              child: FadeInImage.memoryNetwork(
                placeholder: kTransparentImage,
                image: story.thumbnailUrl,
                imageErrorBuilder: (context, _, __) {
                  return Container(
                    color: AppColors.info.shade100,
                    constraints: const BoxConstraints.expand(),
                    alignment: Alignment.center,
                    child: const Text(
                      "Story não está disponível",
                      textAlign: TextAlign.center,
                    ),
                  );
                },
              ),
            ),
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.only(top: AppSizes.s02, left: AppSizes.s03),
                height: AppSizes.s08,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.black45, Colors.transparent],
                  ),
                ),
                child: const Text(
                  "Story",
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
