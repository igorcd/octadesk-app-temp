import 'package:flutter/material.dart';
import 'package:octadesk_app/resources/index.dart';

class OctaSliverHeader extends StatelessWidget {
  final String title;
  final bool pinned;
  const OctaSliverHeader({required this.title, this.pinned = false, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      pinned: pinned,
      automaticallyImplyLeading: false,
      elevation: 16,
      shadowColor: Colors.black38,
      toolbarHeight: AppSizes.s13,
      primary: false,
      flexibleSpace: Container(
        height: AppSizes.s13,
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Center(
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: AppSizes.s06),
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: AppSizes.s03_5,
                    ),
                  ),
                ),
              ),
            ),
            const Divider(thickness: 1),
          ],
        ),
      ),
    );
  }
}
