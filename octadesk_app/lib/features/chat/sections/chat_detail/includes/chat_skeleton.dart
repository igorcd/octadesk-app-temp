import 'package:flutter/material.dart';
import 'package:octadesk_app/components/index.dart';
import 'package:octadesk_app/resources/index.dart';

class ChatSkeleton extends StatelessWidget {
  const ChatSkeleton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints.expand(),
      child: OctaPulseAnimation(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(AppSizes.s06),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: const [
                  OctaSkeletonContainer(width: AppSizes.s60, height: AppSizes.s12),
                  SizedBox(height: AppSizes.s01_5),
                  OctaSkeletonContainer(width: AppSizes.s25, height: AppSizes.s12),
                  SizedBox(height: AppSizes.s01_5),
                  OctaSkeletonContainer(width: AppSizes.s48, height: AppSizes.s12),
                  SizedBox(height: AppSizes.s01_5),
                  OctaSkeletonContainer(width: AppSizes.s25, height: AppSizes.s12),
                ]),
                const SizedBox(height: AppSizes.s03),
                Column(crossAxisAlignment: CrossAxisAlignment.end, children: const [
                  OctaSkeletonContainer(width: AppSizes.s60, height: AppSizes.s12),
                  SizedBox(height: AppSizes.s01_5),
                  OctaSkeletonContainer(width: AppSizes.s25, height: AppSizes.s12),
                  SizedBox(height: AppSizes.s01_5),
                  OctaSkeletonContainer(width: AppSizes.s48, height: AppSizes.s12),
                  SizedBox(height: AppSizes.s01_5),
                ]),
                const SizedBox(height: AppSizes.s03),
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: const [
                  OctaSkeletonContainer(width: AppSizes.s25, height: AppSizes.s12),
                  SizedBox(height: AppSizes.s01_5),
                  OctaSkeletonContainer(width: AppSizes.s34, height: AppSizes.s12),
                ]),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
