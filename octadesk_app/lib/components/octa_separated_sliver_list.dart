import 'package:flutter/material.dart';
import 'dart:math' as math;

class OctaSeparatedSliverList extends StatelessWidget {
  final Widget Function(BuildContext context, int index) separatorBuilder;
  final Widget Function(BuildContext context, int index) itemBuilder;
  final int itemCount;
  const OctaSeparatedSliverList({required this.separatorBuilder, required this.itemBuilder, required this.itemCount, super.key});

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int index) {
          final int itemIndex = index ~/ 2;
          if (index.isEven) {
            return itemBuilder(context, itemIndex);
          }

          return separatorBuilder(context, itemIndex);
        },
        semanticIndexCallback: (Widget widget, int localIndex) {
          if (localIndex.isEven) {
            return localIndex ~/ 2;
          }
          return null;
        },
        childCount: math.max(0, itemCount * 2 - 1),
      ),
    );
  }
}
