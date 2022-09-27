import 'package:collection/collection.dart';

enum MacroTypeEnum {
  macro,
  template,
}

class MacroDTO {
  final String id;
  final bool? enabled;
  final bool? deleted;
  final String name;
  final MacroTypeEnum type;
  final List<MacroContentDTO> contents;
  final dynamic applicableFor;
  final dynamic permissions;

  /// Content do idioma atual
  MacroContentDTO get currentContent {
    return contents.firstWhereOrNull((element) => element.culture == "pt-BR") ?? MacroContentDTO(culture: "pt-BR", components: []);
  }

  /// Body do template
  MacroComponentDTO get body => currentContent.components.firstWhere((element) => element.type == MacroComponentTypeEnum.body);
  MacroComponentDTO? get header => currentContent.components.firstWhereOrNull((element) => element.type == MacroComponentTypeEnum.header);
  MacroComponentDTO? get footer => currentContent.components.firstWhereOrNull((element) => element.type == MacroComponentTypeEnum.footer);
  MacroComponentDTO? get buttons => currentContent.components.firstWhereOrNull((element) => element.type == MacroComponentTypeEnum.buttons);

  bool get hasVariables => body.variables.isNotEmpty || header?.variables.isNotEmpty == true || footer?.variables.isNotEmpty == true || buttons?.variables.isNotEmpty == true;

  MacroDTO({
    required this.id,
    required this.enabled,
    required this.deleted,
    required this.name,
    required this.type,
    required this.contents,
    required this.applicableFor,
    required this.permissions,
  });

  /// Criar a partir de mapa
  factory MacroDTO.fromMap(Map<String, dynamic> map) {
    return MacroDTO(
      id: map["id"],
      enabled: map["enabled"],
      deleted: map["deleted"],
      name: map["name"],
      type: MacroTypeEnum.values.firstWhere((element) => element.name == map["type"]),
      contents: List.from(map["contents"]).map((e) => MacroContentDTO.fromMap(e)).toList(),
      applicableFor: map["applicableFor"],
      permissions: map["permissions"],
    );
  }

  /// Pegar conteúdo textual
  String getComment() {
    return currentContent.components.fold("", (previousValue, element) {
      if (element.type != MacroComponentTypeEnum.body) {
        return "<${element.type}>${element.message}</${element.type}>";
      } else {
        return element.message;
      }
    });
  }

  /// Transformar em mapa
  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "enabled": enabled,
      "deleted": deleted,
      "name": name,
      "type": type.name,
      "contents": contents.map((e) => e.toMap()).toList(),
      "applicableFor": applicableFor,
      "permissions": permissions,
    };
  }

  /// Criar uma cópia por valor
  MacroDTO clone() {
    var map = toMap();
    return MacroDTO.fromMap(map);
  }
}

/// Conteúdo de um macro
class MacroContentDTO {
  final String culture;
  final List<MacroComponentDTO> components;
  String? id;

  MacroContentDTO({
    required this.culture,
    required this.components,
    this.id,
  });

  factory MacroContentDTO.fromMap(Map<String, dynamic> map) {
    return MacroContentDTO(
      culture: map["culture"],
      components: List.from(map["components"]).map((e) => MacroComponentDTO.fromMap(e)).toList(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "culture": culture,
      "components": components.map((e) => e.toMap()).toList(),
      "id": id,
    };
  }

  MacroContentDTO clone() {
    var map = toMap();
    return MacroContentDTO.fromMap(map);
  }
}

enum MacroComponentTypeEnum {
  header,
  body,
  footer,
  buttons,
}

/// Componentes do macro
class MacroComponentDTO {
  final String message;
  final MacroComponentTypeEnum type;
  final List<MacroVariableDTO> variables;
  final List<MacroButtonDTO> buttons;

  MacroComponentDTO({required this.message, required this.type, required this.variables, required this.buttons});

  factory MacroComponentDTO.fromMap(Map<String, dynamic> map) {
    return MacroComponentDTO(
      message: map["message"] ?? "",
      type: MacroComponentTypeEnum.values.firstWhere((element) => element.name == map["type"]),
      variables: map["variables"] != null ? List.from(map["variables"]).map((e) => MacroVariableDTO.fromMap(e)).toList() : [],
      buttons: map["buttons"] != null ? List.from(map["buttons"]).map((e) => MacroButtonDTO.fromMap(e)).toList() : [],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "message": message,
      "type": type.name,
      "variables": variables.map((e) => e.toMap()).toList(),
      "buttons": buttons.map((e) => e.toMap()).toList(),
    };
  }
}

/// Botão do Macro
class MacroButtonDTO {
  final String label;
  final String url;
  final String value;
  final dynamic variables;

  MacroButtonDTO({required this.label, required this.url, required this.value, required this.variables});

  factory MacroButtonDTO.fromMap(Map<String, dynamic> map) {
    return MacroButtonDTO(
      label: map["label"] ?? "",
      url: map["url"] ?? "",
      value: map["value"] ?? "",
      variables: map["variables"],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "label": label,
      "url": url,
      "value": value,
      "variables": variables,
    };
  }
}

/// Enum de variáveis
enum MacroVariableTypeEnum {
  image,
  video,
  text,
  path,
  document,
}

/// Variáveis do macro
class MacroVariableDTO {
  final bool constant;
  final String key;
  final dynamic metadata;
  final MacroVariableTypeEnum type;
  final String domain;
  final String property;
  String value;

  MacroVariableDTO({
    required this.type,
    required this.domain,
    required this.key,
    required this.property,
    required this.constant,
    required this.metadata,
    required this.value,
  });

  factory MacroVariableDTO.fromMap(Map<String, dynamic> map) {
    return MacroVariableDTO(
      type: MacroVariableTypeEnum.values.firstWhere((element) => element.name == map["type"]),
      domain: map["domain"] ?? "",
      key: map["key"],
      property: map["property"] ?? "",
      constant: map["constant"] ?? false,
      metadata: map["metadata"],
      value: map["value"] ?? "",
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "constant": constant,
      "key": key,
      "metadata": metadata,
      "type": type.name,
      "value": value,
      "domain": domain,
      "property": property,
    };
  }
}
