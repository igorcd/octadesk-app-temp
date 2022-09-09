import 'package:flutter/material.dart';
import 'package:octadesk_app/components/index.dart';
import 'package:octadesk_app/resources/app_illustrations.dart';
import 'package:octadesk_app/resources/index.dart';

class OctaAlertDialogAction {
  final String text;
  final bool primary;
  final void Function() action;

  OctaAlertDialogAction({required this.primary, required this.action, required this.text});
}

class OctaAlertDialog extends StatefulWidget {
  final String image;
  final String title;
  final String subtitle;
  final List<OctaAlertDialogAction>? actions;

  const OctaAlertDialog({
    this.image = AppIllustrations.illustrationBox,
    this.title = "Ops...",
    required this.subtitle,
    this.actions,
    Key? key,
  }) : super(key: key);

  @override
  State<OctaAlertDialog> createState() => _OctaAlertDialogState();
}

class _OctaAlertDialogState extends State<OctaAlertDialog> with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 500))..forward(from: 0);
    _animation = CurvedAnimation(parent: _controller, curve: Curves.elasticOut);
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Gerar ação
    Widget generateAction(OctaAlertDialogAction action) {
      return Expanded(
        child: OctaButton(
          type: action.primary ? ButtonStyleEnum.primary : ButtonStyleEnum.secondary,
          text: action.text,
          onPressed: () async {
            Navigator.of(context).pop();
            await Future.delayed(const Duration(milliseconds: 300));
            action.action();
          },
        ),
      );
    }

    // Gerar ações
    List<Widget> generateActions() {
      if (widget.actions == null) {
        return [Expanded(child: OctaButton(onPressed: () => Navigator.of(context).pop(), text: "Ok"))];
      }

      var children = widget.actions!.asMap().entries.map((e) {
        var index = e.key;
        var action = e.value;

        var spacer = index == widget.actions!.length - 1 ? const SizedBox.shrink() : const SizedBox(width: AppSizes.s04);
        return [generateAction(action), spacer];
      });

      return children.reduce((value, element) {
        value.addAll(element);
        return value;
      });
    }

    var width = MediaQuery.of(context).size.width * 0.85;

    return Dialog(
      insetPadding: const EdgeInsets.all(0),
      backgroundColor: Colors.transparent,
      elevation: 0,
      // Container principal
      child: ScaleTransition(
        scale: Tween<double>(begin: 0.8, end: 1).animate(_animation),
        child: Material(
          elevation: 20,
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(AppSizes.s04))),
          color: Colors.white,
          child: Container(
            constraints: const BoxConstraints(maxWidth: 360),
            width: width,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Conteúdo superior
                Padding(
                  padding: const EdgeInsets.all(AppSizes.s05),
                  child: Column(
                    children: [
                      // Ilustração
                      Image.asset(
                        widget.image,
                        height: AppSizes.s40,
                      ),
                      const SizedBox(
                        height: AppSizes.s04,
                      ),

                      // Título
                      OctaText.headlineLarge(
                        widget.title,
                      ),
                      const SizedBox(
                        height: AppSizes.s04,
                      ),

                      // Mensagem
                      OctaText(
                        widget.subtitle,
                        textAlign: TextAlign.center,
                      )
                    ],
                  ),
                ),
                const Divider(height: 1, thickness: 1),
                Padding(
                  padding: const EdgeInsets.all(AppSizes.s04),
                  child: Row(children: generateActions()),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
