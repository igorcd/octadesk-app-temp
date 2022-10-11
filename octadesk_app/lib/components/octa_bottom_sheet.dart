import 'package:flutter/material.dart';
import 'package:octadesk_app/components/index.dart';
import 'package:octadesk_app/components/responsive/responsive_widgets.dart';
import 'package:octadesk_app/resources/app_icons.dart';
import 'package:octadesk_app/resources/app_sizes.dart';

class OctaBottomSheetAction {
  final String icon;
  final void Function() onTap;

  OctaBottomSheetAction({required this.icon, required this.onTap});
}

class OctaBottomSheet extends StatelessWidget {
  final Animation<double> animation;
  final int stackPosition;
  final int currentPosition;
  final String title;
  final Widget child;
  final OctaBottomSheetAction? action;

  const OctaBottomSheet({required this.currentPosition, required this.animation, required this.title, required this.child, this.stackPosition = 0, this.action, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;
    var isMobile = MediaQuery.of(context).size.width < ScreenSize.md;

    Widget transition(Widget child) {
      if (isMobile) {
        return SlideTransition(
          position: Tween<Offset>(begin: const Offset(0, 1), end: const Offset(0, 0)).animate(animation),
          child: child,
        );
      }

      return FadeTransition(opacity: animation, child: ScaleTransition(scale: Tween<double>(begin: 0.9, end: 1).animate(animation), child: child));
    }

    return AnimatedSlide(
      duration: const Duration(milliseconds: 200),
      offset: stackPosition > currentPosition ? const Offset(0, -.07) : const Offset(0, 0),
      child: AnimatedScale(
        duration: const Duration(milliseconds: 200),
        scale: stackPosition > currentPosition ? .92 : 1,
        child: Dialog(
          elevation: 0,
          backgroundColor: Colors.transparent,
          insetPadding: EdgeInsets.zero,
          child: transition(
            Padding(
              padding: isMobile ? const EdgeInsets.only(top: AppSizes.s18) : EdgeInsets.zero,

              // Container principal
              child: Container(
                clipBehavior: Clip.hardEdge,
                constraints: isMobile ? null : const BoxConstraints(maxWidth: 500, maxHeight: 600),
                decoration: BoxDecoration(
                  color: colorScheme.surface,
                  borderRadius: isMobile
                      ? const BorderRadius.vertical(
                          top: Radius.circular(AppSizes.s03),
                        )
                      : BorderRadius.circular(AppSizes.s03),
                  boxShadow: [
                    BoxShadow(
                      offset: isMobile ? const Offset(0, -10) : Offset.zero,
                      color: isMobile ? Colors.black12 : Colors.black38,
                      blurRadius: 20,
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // Header
                    SizedBox(
                      height: AppSizes.s14,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          //
                          // Trailing
                          Container(
                            padding: const EdgeInsets.only(left: AppSizes.s02),
                            width: AppSizes.s12,
                            child: Center(
                              child: OctaIconButton(
                                size: AppSizes.s10,
                                icon: AppIcons.angleDown,
                                onPressed: () => Navigator.of(context).pop(),
                              ),
                            ),
                          ),

                          // Titulo
                          Expanded(
                            child: Center(child: OctaText.titleLarge(title)),
                          ),

                          // Actions
                          Container(
                            padding: const EdgeInsets.only(right: AppSizes.s02),
                            width: AppSizes.s12,
                            child: action != null
                                ? Center(
                                    child: OctaIconButton(
                                      size: AppSizes.s10,
                                      icon: action!.icon,
                                      iconSize: AppSizes.s06,
                                      onPressed: () async {
                                        Navigator.of(context).pop();
                                        action!.onTap();
                                      },
                                    ),
                                  )
                                : const SizedBox.shrink(),
                          ),
                        ],
                      ),
                    ),
                    const Divider(thickness: 1, height: 1),
                    Expanded(child: child),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
