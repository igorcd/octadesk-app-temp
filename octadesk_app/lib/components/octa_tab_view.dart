import 'package:flutter/material.dart';
import 'package:octadesk_app/resources/index.dart';

class OctaTabView extends StatelessWidget {
  final List<Widget> children;
  final List<String> tabs;

  const OctaTabView({required this.children, required this.tabs, super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: tabs.length,
      child: Column(
        children: [
          //
          // TabBar
          Material(
            color: Colors.transparent,
            child: TabBar(
              indicatorWeight: 3,
              indicatorColor: AppColors.info.shade800,
              labelColor: AppColors.info.shade800,
              unselectedLabelColor: AppColors.info.shade800.withOpacity(.6),
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
          ),
          Divider(
            height: 1,
            thickness: 1,
            color: Colors.grey.shade300,
          ),
          Expanded(
            child: TabBarView(
              children: children,
            ),
          )
        ],
      ),
    );
  }
}
