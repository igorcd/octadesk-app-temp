import 'package:flutter/material.dart';
import 'package:octadesk_app/resources/index.dart';

class OctaPaginationIndication extends StatelessWidget {
  final bool loading;
  const OctaPaginationIndication({required this.loading, super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: AnimatedSwitcher(
        switchInCurve: Curves.ease,
        switchOutCurve: Curves.ease,
        duration: const Duration(milliseconds: 300),

        // Transição
        transitionBuilder: (child, animation) {
          return FadeTransition(
            opacity: animation,
            child: SlideTransition(
              position: Tween<Offset>(begin: const Offset(0, .5), end: const Offset(0, 0)).animate(animation),
              child: child,
            ),
          );
        },
        child: loading
            ? Container(
                margin: const EdgeInsets.all(AppSizes.s06),
                width: AppSizes.s12,
                height: AppSizes.s12,
                padding: const EdgeInsets.all(AppSizes.s03),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(54),
                  boxShadow: const [AppShadows.s100],
                ),
                child: const CircularProgressIndicator(
                  color: AppColors.blue,
                ),
              )
            : null,
      ),
    );
  }
}
