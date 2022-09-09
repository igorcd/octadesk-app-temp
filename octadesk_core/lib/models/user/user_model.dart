import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:octadesk_core/dtos/auth/auth_response_dto.dart';
import 'package:octadesk_core/dtos/auth/decoded_jwt_dto.dart';

class UserModel {
  final String id;
  final String agentId;
  final String name;
  final String email;
  final String? avatar;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.avatar,
    required this.agentId,
  });

  /// Utilizar apenas a nível de testes internos
  factory UserModel.fromAuthenticationDTO(AuthResponseDTO auth) {
    var decodedJwtMap = JwtDecoder.decode(auth.jwToken);
    var decodedJwt = DecodedJwtDTO.fromMap(decodedJwtMap);

    return UserModel(
      id: decodedJwt.id,
      agentId: decodedJwt.id,
      name: decodedJwt.name,
      email: decodedJwt.email,
      avatar: "",
    );
  }

  UserModel clone() {
    return UserModel(
      id: id,
      name: name,
      email: email,
      avatar: avatar,
      agentId: agentId,
    );
  }
}
