import 'package:flutter/material.dart';
import 'package:octadesk_app/components/index.dart';
import 'package:octadesk_app/resources/app_sizes.dart';
import 'package:octadesk_core/dtos/agent/agent_dto.dart';

class ChatMentionsListItem extends StatelessWidget {
  final AgentDTO agent;
  final void Function() onPressed;

  const ChatMentionsListItem(this.agent, {required this.onPressed, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: AppSizes.s15,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSizes.s04),
            child: Row(
              children: [
                OctaAvatar(
                  name: agent.name,
                  source: agent.thumbUrl,
                  size: AppSizes.s10,
                  fontSize: AppSizes.s03_5,
                ),
                const SizedBox(width: AppSizes.s02_5),
                OctaText.bodyLarge(
                  agent.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
