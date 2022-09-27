import 'package:flutter/material.dart';
import 'package:octadesk_app/components/index.dart';
import 'package:octadesk_app/components/octa_sliver_header.dart';
import 'package:octadesk_app/features/chat/dialogs/components/macro_preview.dart';
import 'package:octadesk_app/resources/index.dart';
import 'package:octadesk_core/octadesk_core.dart';

class TemplateVariablesDialog extends StatefulWidget {
  final MacroDTO macro;
  final RoomModel room;
  const TemplateVariablesDialog(this.macro, this.room, {Key? key}) : super(key: key);

  @override
  State<TemplateVariablesDialog> createState() => _TemplateVariablesDialogState();
}

class _TemplateVariablesDialogState extends State<TemplateVariablesDialog> {
  // Formulário
  final GlobalKey<FormState> _form = GlobalKey();

  // Validar inputs
  bool _validateOnInput = false;

  // Variáveis do body
  Map<String, TextEditingController> variables = {};

  /// Pegar o valor default de uma propriedade
  String _getDefaultProperty(String segmentString) {
    // Caminho da propriedade
    var propertySegments = segmentString.split('.');
    propertySegments.removeAt(0);

    // Nó atual
    Map<dynamic, dynamic> currentNode = widget.room.getRoomPropertiesAsMap();

    String value = "";

    for (var segment in propertySegments) {
      // Verificar se a propriedade existe
      if (!currentNode.containsKey(segment)) {
        return "";
      }
      var node = currentNode[segment];

      // Caso seja um node
      if (node is Map) {
        currentNode = node;
      }
      // Caso seja um valor
      else {
        value = node.toString();
      }
    }

    return value;
  }

  /// Carregar as variáveis
  void _loadVariables() {
    // Adicionar propriedades do corpo
    for (var v in widget.macro.body.variables) {
      var defaultValue = "";

      // Caso tenha um valor padrão
      if (v.property.isNotEmpty) {
        defaultValue = _getDefaultProperty(v.property);
      }

      variables.putIfAbsent(v.key, () => TextEditingController(text: defaultValue));
    }

    // Criar controllers das variáveis do header
    if (widget.macro.header != null) {
      var nonConstanteVariables = widget.macro.header!.variables.where((element) => !element.constant);
      for (var v in nonConstanteVariables) {
        var defaultValue = "";

        // Caso tenha um valor padrão
        if (v.property.isNotEmpty) {
          defaultValue = _getDefaultProperty(v.property);
        }

        variables.putIfAbsent(v.key, () => TextEditingController(text: defaultValue));
      }
    }
  }

  /// Submeter
  void _submit() {
    setState(() => _validateOnInput = true);
    var isValid = _form.currentState?.validate() ?? false;
    if (isValid) {
      var content = widget.macro.currentContent.clone();
      content.id = widget.macro.id;

      /// Adicionar valor das variáveis
      for (var component in content.components) {
        for (var v in component.variables) {
          if (variables.containsKey(v.key)) {
            v.value = variables[v.key]!.text;
          }
        }
      }

      Navigator.of(context).pop(content);
    }
  }

  @override
  void initState() {
    super.initState();
    _loadVariables();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Form(
            autovalidateMode: _validateOnInput ? AutovalidateMode.onUserInteraction : AutovalidateMode.disabled,
            key: _form,
            child: CustomScrollView(
              slivers: [
                // Header do preview de mensagens
                const OctaSliverHeader(title: "Pré-visualização da mensagem"),

                // Preview da mensagem
                SliverToBoxAdapter(
                  child: MacroPreview(
                    widget.macro,
                    variables: variables,
                    onChanged: () => setState(() {}),
                  ),
                ),

                const OctaSliverHeader(title: "Variáveis", pinned: true),

                // Lista de variáveis
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      var key = variables.keys.toList()[index];

                      return Padding(
                        padding: const EdgeInsets.only(
                          top: AppSizes.s02,
                          left: AppSizes.s04,
                          right: AppSizes.s04,
                          bottom: AppSizes.s02,
                        ),
                        child: OctaInput(
                          key,
                          hintText: key,
                          onChanged: (value) => setState(() {}),
                          validators: const [AppValidators.notEmpty],
                          controller: variables[key],
                        ),
                      );
                    },
                    childCount: variables.keys.length,
                  ),
                ),
                if (variables.isEmpty) const OctaEmptySliver(text: "Essa mensagem não possui variáveis"),
                SliverToBoxAdapter(
                  child: SizedBox(height: MediaQuery.of(context).padding.bottom + AppSizes.s02),
                )
              ],
            ),
          ),
        ),
        const Divider(),
        Padding(
          padding: const EdgeInsets.all(AppSizes.s04),
          child: OctaButton(
            onTap: _submit,
            text: "Enviar",
          ),
        )
      ],
    );
  }
}
