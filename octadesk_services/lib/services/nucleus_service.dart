import 'package:dio/dio.dart';
import 'package:octadesk_core/octadesk_core.dart';
import 'package:octadesk_services/http_clients/nucleus_client.dart';
import 'package:octadesk_services/enums/authentication_provider_enum.dart';

class NucleusService {
  static Future<AuthResponseDTO> _handleAuth(Future<Response> request) async {
    var resp = await request;
    return AuthResponseDTO.fromMap(resp.data);
  }

  /// Realizar o login com credenciais
  static Future<AuthResponseDTO> auth(AuthDTO data, AuthenticationProviderEnum provider) async {
    Future<Response<dynamic>> request;

    // Caso seja um login do google
    if (provider == AuthenticationProviderEnum.google) {
      request = NucleusClient.client.get('/auth/google', queryParameters: {'SocialToken': data.openIdToken, 'tenantId': data.tenantId});
    }

    // Caso seja uma login do iOS
    else if (provider == AuthenticationProviderEnum.apple) {
      throw "Ainda não implementado";
    }

    // Caso seja um login por email e senha
    else {
      request = NucleusClient.client.post('/auth', data: data.toMap());
    }

    return _handleAuth(request);
  }

  /// Verificar status da tenant
  static Future<TenantStatusDTO> checkTenantStatus(String tenantId) async {
    var resp = await NucleusClient.client.get('/Tenants/$tenantId/status');
    return TenantStatusDTO.fromMap(resp.data);
  }

  static Future<UserDTO> getUser({required String tenantId, required String userId}) async {
    var resp = await NucleusClient.client.get('/Tenants/$tenantId/users/$userId');
    return UserDTO.fromMap(resp.data);
  }
}
