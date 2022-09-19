import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:octadesk_app/components/index.dart';
import 'package:octadesk_app/resources/index.dart';

class OctaSearchSliver extends StatefulWidget {
  final void Function(String text) onTextChange;
  final List<OctaTag>? filters;
  final bool loading;

  const OctaSearchSliver({required this.onTextChange, this.filters, this.loading = false, Key? key}) : super(key: key);

  @override
  State<OctaSearchSliver> createState() => _OctaSearchSliverState();
}

class _OctaSearchSliverState extends State<OctaSearchSliver> {
  final ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      elevation: 0,
      floating: true,
      backgroundColor: Colors.white,
      leading: null,
      automaticallyImplyLeading: false,
      toolbarHeight: widget.filters != null ? 112 : 76,
      primary: false,
      flexibleSpace: Column(
        children: [
          //
          // Search Input
          Padding(
            padding: const EdgeInsets.only(top: AppSizes.s04, right: AppSizes.s04, left: AppSizes.s04),
            child: OctaSearchInput(onTextChange: widget.onTextChange),
          ),

          // Filtros
          if (widget.filters != null)
            Container(
              margin: const EdgeInsets.only(top: AppSizes.s01),
              height: AppSizes.s12,

              // Barra de Scroll
              child: ScrollConfiguration(
                behavior: ScrollConfiguration.of(context).copyWith(
                  dragDevices: {
                    PointerDeviceKind.mouse,
                    PointerDeviceKind.touch,
                  },
                ),
                child: ListView.separated(
                  controller: scrollController,
                  padding: const EdgeInsets.symmetric(horizontal: AppSizes.s04),
                  scrollDirection: Axis.horizontal,
                  separatorBuilder: (context, index) => const SizedBox(width: AppSizes.s02),
                  itemBuilder: (context, index) => widget.filters![index],
                  itemCount: widget.filters!.length,
                ),
              ),
            )
          else
            const SizedBox(height: AppSizes.s04),

          // Loading
          SizedBox(
            height: 2,
            child: LinearProgressIndicator(
              value: widget.loading ? null : 0,
              backgroundColor: AppColors.info.shade100,
              minHeight: 2,
              color: AppColors.blue.shade400,
            ),
          )
        ],
      ),
    );
  }
}
