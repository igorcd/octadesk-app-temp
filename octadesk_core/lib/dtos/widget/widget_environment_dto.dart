class WidgetEnvironmentDTO {
  final String? browser;
  final dynamic device;
  final String? language;
  final String? os;

  WidgetEnvironmentDTO({
    required this.browser,
    required this.device,
    required this.language,
    required this.os,
  });

  factory WidgetEnvironmentDTO.fromMap(Map<dynamic, dynamic> data) {
    return WidgetEnvironmentDTO(
      browser: data["browser"],
      device: data["device"],
      language: data["language"],
      os: data["os"],
    );
  }
}
