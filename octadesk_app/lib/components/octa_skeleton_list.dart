import 'package:flutter/material.dart';
import 'package:octadesk_app/components/octa_pulse_animation.dart';
import 'package:octadesk_app/components/octa_skeleton_container.dart';
import 'package:octadesk_app/resources/index.dart';

class OctaSkeletonList extends StatelessWidget {
  const OctaSkeletonList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OctaPulseAnimation(
      child: ListView.separated(
        separatorBuilder: (context, index) => const Divider(
          indent: AppSizes.s04,
          endIndent: AppSizes.s04,
          height: 0,
        ),
        itemCount: 10,
        itemBuilder: (context, index) {
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: AppSizes.s06),
            height: AppSizes.s18,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                OctaSkeletonContainer(
                  height: AppSizes.s06,
                  width: AppSizes.s60,
                  borderRadius: AppSizes.s01,
                ),
                SizedBox(height: AppSizes.s01),
                OctaSkeletonContainer(
                  height: AppSizes.s04,
                  width: AppSizes.s40,
                  borderRadius: AppSizes.s01,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
