import 'package:flutter/material.dart';
import 'package:octadesk_app/components/octa_pulse_animation.dart';
import 'package:octadesk_app/components/octa_skeleton_container.dart';
import 'package:octadesk_app/resources/index.dart';

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
          return SizedBox(
            height: AppSizes.s18,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSizes.s03),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  //
                  // Avatar
                  const OctaSkeletonContainer(width: AppSizes.s12, height: AppSizes.s12),
                  const SizedBox(width: AppSizes.s04),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      //
                      // Titulo
                      OctaSkeletonContainer(
                        width: AppSizes.s20,
                        height: AppSizes.s04,
                        borderRadius: AppSizes.s01,
                      ),
                      SizedBox(height: AppSizes.s01),

                      // Subtitulo
                      OctaSkeletonContainer(
                        width: AppSizes.s40,
                        height: AppSizes.s04,
                        borderRadius: AppSizes.s01,
                      ),
                    ],
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
