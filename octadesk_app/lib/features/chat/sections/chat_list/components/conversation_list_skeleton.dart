import 'package:flutter/material.dart';
import 'package:octadesk_app/components/octa_pulse_animation.dart';
import 'package:octadesk_app/features/chat/sections/chat_list/components/conversation_skeleton_tile.dart';

class ConversationListSkeleton extends StatelessWidget {
  const ConversationListSkeleton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OctaPulseAnimation(
      child: ListView.separated(
        padding: EdgeInsets.zero,
        itemCount: 10,
        separatorBuilder: (context, index) => const Divider(height: 1, thickness: 1),
        itemBuilder: (context, index) {
          return const ConversationSkeletonTile();
        },
      ),
    );
  }
}
