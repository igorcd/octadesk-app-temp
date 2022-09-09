import 'dart:convert';

import 'package:octadesk_core/dtos/auth/octa_authenticated_dto.dart';

class AuthResponseDTO {
  final String accessToken;
  final Map<String, String> apis;
  final String jwToken;
  final OctaAuthenticatedDTO octaAuthenticated;
  final String? roles;
  final bool socialSignedUp;
  final String userLogged;

  /// Elemento construtor
  AuthResponseDTO({
    required this.accessToken,
    required this.apis,
    required this.jwToken,
    required this.octaAuthenticated,
    this.roles,
    required this.socialSignedUp,
    required this.userLogged,
  });

  factory AuthResponseDTO.clone(AuthResponseDTO data) {
    String encodedMap = json.encode(data.toMap());
    return AuthResponseDTO.fromMap(json.decode(encodedMap));
  }

  factory AuthResponseDTO.fromMap(Map<String, dynamic> data) {
    return AuthResponseDTO(
      accessToken: data["access_token"],
      apis: Map.from(data["apis"]),
      jwToken: data["jwtoken"],
      octaAuthenticated: OctaAuthenticatedDTO.fromMap(data["octaAuthenticated"]),
      socialSignedUp: data["socialSignedUp"],
      userLogged: data["userlogged"],
      roles: data["roles"],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "access_token": accessToken,
      "apis": apis,
      "jwtoken": jwToken,
      "octaAuthenticated": octaAuthenticated.toMap(),
      "socialSignedUp": socialSignedUp,
      "userlogged": userLogged,
      "roles": roles,
    };
  }
}
