class RoomIntegratorModel {
  final String from;
  final String to;
  final String integratorName;

  RoomIntegratorModel({required this.from, required this.to, required this.integratorName});

  factory RoomIntegratorModel.fromMap(Map<String, dynamic> map) {
    return RoomIntegratorModel(
      from: map["from"]?["number"] ?? "",
      to: map["to"]?["number"] ?? "",
      integratorName: map["integrator"] ?? "",
    );
  }
}
