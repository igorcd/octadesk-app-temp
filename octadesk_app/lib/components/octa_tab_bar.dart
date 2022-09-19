import 'package:flutter/material.dart';
import 'package:octadesk_app/resources/index.dart';

class OctaTabBar extends StatelessWidget {
  final List<String> tabs;
  const OctaTabBar({required this.tabs, super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: TabBar(
        indicatorWeight: 3,
        indicatorColor: AppColors.info.shade800,
        labelColor: AppColors.info.shade800,
        unselectedLabelColor: AppColors.info.shade800.withOpacity(.4),
        labelStyle: const TextStyle(fontSize: AppSizes.s04, fontWeight: FontWeight.bold, fontFamily: "WorkSans"),
        tabs: tabs
            .map(
              (e) => Tab(
                height: AppSizes.s12,
                child: Text(e),
              ),
            )
            .toList(),
      ),
    );
  }
}
