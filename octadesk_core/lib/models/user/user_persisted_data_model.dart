class PersistedAuthenticationDataModel {
  final String jwt;
  final String accessToken;
  final Map<String, String> apis;

  PersistedAuthenticationDataModel({required this.jwt, required this.accessToken, required this.apis});

  Map<String, dynamic> toMap() {
    return {
      "jwt": jwt,
      "accessToken": accessToken,
      "apis": apis,
    };
  }

  factory PersistedAuthenticationDataModel.fromMap(Map<String, dynamic> map) {
    return PersistedAuthenticationDataModel(
      jwt: map["jwt"],
      accessToken: map["accessToken"],
      apis: Map.from(map["apis"]).map((key, value) => MapEntry(key, value.toString())),
    );
  }
}
