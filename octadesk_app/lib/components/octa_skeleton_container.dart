import 'package:flutter/material.dart';
import 'package:octadesk_app/resources/index.dart';

class OctaSkeletonContainer extends StatelessWidget {
  final double width;
  final double height;
  final double borderRadius;

  const OctaSkeletonContainer({
    required this.width,
    required this.height,
    this.borderRadius = AppSizes.s02_5,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: AppColors.info.shade200,
        borderRadius: BorderRadius.all(
          Radius.circular(borderRadius),
        ),
      ),
    );
  }
}
