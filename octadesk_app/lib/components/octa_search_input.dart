import 'package:flutter/material.dart';
import 'package:octadesk_app/resources/index.dart';

class OctaSearchInput extends StatefulWidget {
  final void Function(String value) onTextChange;
  final TextEditingController? controller;

  const OctaSearchInput({required this.onTextChange, this.controller, Key? key}) : super(key: key);

  @override
  State<OctaSearchInput> createState() => _OctaSearchInputState();
}

class _OctaSearchInputState extends State<OctaSearchInput> {
  final TextEditingController _searchController = TextEditingController();
  bool _inFocus = false;
  String prevValue = "";

  Color _renderBorderColor() {
    if (_inFocus) {
      return AppColors.blue;
    }

    return AppColors.info.shade200;
  }

  /// Tratar digitação da busca
  void _handleSearchInput() {
    var controller = widget.controller ?? _searchController;
    prevValue = controller.text;

    controller.addListener(() {
      if (prevValue != controller.text) {
        setState(() {
          widget.onTextChange(controller.text);
        });
        prevValue = controller.text;
      }
    });
  }

  @override
  void initState() {
    _handleSearchInput();
    super.initState();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Tratamento do foco
    return Focus(
      onFocusChange: (hasFocus) => setState(() {
        _inFocus = hasFocus;
      }),

      // Container principal
      child: AnimatedContainer(
        height: 42,
        duration: const Duration(milliseconds: 300),
        curve: Curves.ease,
        padding: const EdgeInsets.symmetric(horizontal: AppSizes.s03),
        //
        // Estilo
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
            width: 2,
            color: _renderBorderColor(),
          ),
          borderRadius: const BorderRadius.all(Radius.circular(AppSizes.s02_5)),
          boxShadow: [
            BoxShadow(
              color: _inFocus ? AppColors.blue.shade400 : Colors.transparent,
              blurRadius: 3,
              offset: const Offset(0, 0),
            ),
          ],
        ),

        // Input
        child: Row(
          children: [
            // Ícone
            AnimatedOpacity(
              duration: const Duration(milliseconds: 150),
              opacity: _inFocus ? 1 : .5,
              child: Image.asset(AppIcons.search, width: AppSizes.s05),
            ),

            // Texto
            Expanded(
              child: TextField(
                controller: widget.controller ?? _searchController,
                style: TextStyle(
                  fontFamily: "NotoSans",
                  fontWeight: FontWeight.normal,
                  fontSize: AppSizes.s04,
                  color: AppColors.info.shade800,
                ),
                decoration: InputDecoration(
                  // Estilo do placeholder
                  hintStyle: TextStyle(
                    fontWeight: FontWeight.w300,
                    fontFamily: 'NotoSans',
                    color: AppColors.info.shade300,
                  ),

                  errorStyle: const TextStyle(height: 0),
                  border: InputBorder.none,
                  hintText: "Buscar...",
                  isDense: true,
                  contentPadding: const EdgeInsets.symmetric(horizontal: AppSizes.s02),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
