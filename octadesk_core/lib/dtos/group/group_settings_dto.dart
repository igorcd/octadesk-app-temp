class GroupSettingsDTO {
  final bool enabled;
  final bool canShare;

  GroupSettingsDTO({required this.enabled, required this.canShare});

  factory GroupSettingsDTO.fromMap(Map<String, dynamic> map) {
    return GroupSettingsDTO(
      enabled: map["enabled"],
      canShare: map["canShare"],
    );
  }
}
