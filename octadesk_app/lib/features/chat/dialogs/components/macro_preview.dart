import 'package:flutter/material.dart';
import 'package:octadesk_app/components/index.dart';
import 'package:octadesk_app/resources/index.dart';
import 'package:octadesk_core/octadesk_core.dart';
import 'package:styled_text/styled_text.dart';
import 'package:transparent_image/transparent_image.dart';

class MacroPreview extends StatelessWidget {
  final MacroDTO macro;
  final Map<String, TextEditingController> variables;
  final void Function() onChanged;
  const MacroPreview(this.macro, {required this.variables, required this.onChanged, Key? key}) : super(key: key);

  List<MacroVariableDTO>? get headerImages => macro.header?.variables.where((element) => element.type == MacroVariableTypeEnum.image).toList();
  List<MacroVariableDTO>? get headerVideos => macro.header?.variables.where((element) => element.type == MacroVariableTypeEnum.video).toList();
  List<MacroVariableDTO>? get headerTexts => macro.header?.variables.where((element) => element.type == MacroVariableTypeEnum.text).toList();

  String transformAttributesInTags(String value) {
    var regex = RegExp("<span(.*?)</span>");

    var replaced = value.replaceAllMapped(regex, (match) {
      var value = match[0]!.split('"');
      return "<${value[1].replaceAll(' ', '_')}/>";
    });
    return replaced;
  }

  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;

    ///
    /// Renderizar imagens do header
    List<Widget> renderHeaderImages() {
      return headerImages!.map(
        (e) {
          var url = e.value;
          return Padding(
            padding: const EdgeInsets.only(bottom: AppSizes.s02),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(AppSizes.s02),
              child: AspectRatio(
                aspectRatio: 16 / 9,
                child: FadeInImage.memoryNetwork(
                  placeholder: kTransparentImage,
                  fit: BoxFit.cover,
                  image: url,
                ),
              ),
            ),
          );
        },
      ).toList();
    }

    /// Renderizar botões
    List<Widget> renderButtons() {
      return macro.buttons!.buttons.map((e) {
        return Container(
          padding: const EdgeInsets.all(AppSizes.s02),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppSizes.s02),
            border: Border.all(color: colorScheme.primary),
          ),
          child: Text(
            e.label,
            style: TextStyle(color: colorScheme.primary, fontWeight: FontWeight.w600, fontSize: AppSizes.s03),
          ),
        );
      }).toList();
    }

    /// Gerar botoões de edição de variáveis
    Map<String, StyledTextWidgetTag> generateTagButtons() {
      return {
        for (var key in variables.keys)
          key.replaceAll(' ', '_'): StyledTextWidgetTag(
            // Menu Flutuante
            PopupMenuButton(
              constraints: const BoxConstraints(maxWidth: 300, minWidth: 300),
              position: PopupMenuPosition.under,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSizes.s04)),

              // Previnir que o menu flutuante abra com um input aberto
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: AppSizes.s01),
                decoration: BoxDecoration(
                  color: variables[key]!.text.isEmpty ? colorScheme.primary.withOpacity(.7) : colorScheme.primary,
                  borderRadius: BorderRadius.circular(AppSizes.s02),
                ),
                child: Text(
                  variables[key]!.text.isEmpty ? key : variables[key]!.text,
                  style: variables[key]!.text.isEmpty ? const TextStyle(color: Colors.white54) : const TextStyle(color: Colors.white),
                ),
              ),
              itemBuilder: (context) {
                return [
                  PopupMenuItem(
                    enabled: false,
                    child: OctaInput(
                      key,
                      hintText: key,
                      validators: const [AppValidators.notEmpty],
                      controller: variables[key],
                      onChanged: (value) => onChanged(),
                    ),
                  )
                ];
              },
            ),
          )
      };
    }

    // Container principal
    return Container(
      margin: const EdgeInsets.all(AppSizes.s04),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppSizes.s05),
        border: Border.all(color: Theme.of(context).colorScheme.outline, width: 2),
      ),
      padding: const EdgeInsets.all(AppSizes.s02_5),

      // Conteúdo
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          //
          // Imagemdo header
          if (headerImages != null) ...renderHeaderImages(),

          // Texto do header
          if (headerTexts != null && headerTexts!.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(bottom: AppSizes.s02),
              child: StyledText(
                text: transformAttributesInTags(macro.header!.message),
                tags: generateTagButtons(),
                style: const TextStyle(fontWeight: FontWeight.bold),
                textAlign: TextAlign.left,
              ),
            ),

          // Mensagem
          StyledText(
            style: const TextStyle(fontFamily: "NotoSans"),
            text: transformAttributesInTags(macro.body.message),
            tags: generateTagButtons(),
          ),

          // Footer
          if (macro.footer != null)
            Padding(
              padding: const EdgeInsets.only(top: AppSizes.s02),
              child: Text(
                macro.footer!.message,
                style: const TextStyle(color: Colors.black38, fontSize: AppSizes.s03_5),
              ),
            ),
          if (macro.buttons != null && macro.buttons!.buttons.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: AppSizes.s03),
              child: Wrap(
                runSpacing: AppSizes.s02,
                spacing: AppSizes.s02,
                direction: Axis.horizontal,
                children: renderButtons(),
              ),
            )
        ],
      ),
    );
  }
}
