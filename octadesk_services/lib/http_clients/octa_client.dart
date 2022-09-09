import 'package:dio/dio.dart';

class OctaClient {
  static Map<String, String>? _apis;

  static String getSocketUrl() {
    if (_apis == null) {
      throw "Cliente não inicializado";
    }
    return _apis!["chatSocketBase"]!;
  }

  // Cliente principal
  static final Dio _client = Dio(BaseOptions(
    sendTimeout: 30 * 1000,
    connectTimeout: 30 * 1000,
    receiveTimeout: 30 * 1000,
  ));

  /// Setar APIS
  static void setApis(Map<String, String> apis, String jwt) {
    _client.options.headers['authorization'] = 'Bearer $jwt';
    _apis = apis;
  }

  /// Limpar Credenciais
  static void dispose() {
    _client.options.headers['authorization'] = null;
    _apis = null;
  }

  /// Cliente do Whatsapp
  static Dio get whatsApp {
    if (_apis == null) {
      throw "cliente não inicializado";
    }
    _client.options.baseUrl = _apis!["whatsapp"]!;
    return _client;
  }

  /// Cliente de autenticação
  static Dio get authentication {
    if (_apis == null) {
      throw "cliente não inicializado";
    }
    _client.options.baseUrl = _apis!["authentication"]!;
    return _client;
  }

  /// Cliente de Tenant
  static Dio get tenant {
    if (_apis == null) {
      throw "cliente não inicializado";
    }
    _client.options.baseUrl = _apis!["tenant"]!;
    return _client;
  }

  /// Cliente de Chat
  static Dio get chat {
    if (_apis == null) {
      throw "cliente não inicializado";
    }
    _client.options.baseUrl = _apis!["chatUrl"]!;
    return _client;
  }

  /// Cliente de Persons
  static Dio get personsService {
    if (_apis == null) {
      throw "cliente não inicializado";
    }
    _client.options.baseUrl = _apis!["personsService"]!;
    return _client;
  }

  /// Cliente de Persons
  static Dio get persons {
    if (_apis == null) {
      throw "cliente não inicializado";
    }
    _client.options.baseUrl = _apis!["persons"]!;
    return _client;
  }

  /// Macros
  static Dio get macro {
    if (_apis == null) {
      throw "Cliente não inicializado";
    }
    _client.options.baseUrl = _apis!["macro"]!;
    return _client;
  }

  // Agente
  static Dio get agent {
    if (_apis == null) {
      throw "Cliente não inicializado";
    }
    _client.options.baseUrl = _apis!["chatAgentsUrl"]!;
    return _client;
  }

  // Grupos
  static Dio get groups {
    if (_apis == null) {
      throw "Cliente não inicializado";
    }
    _client.options.baseUrl = _apis!["groups"]!;
    return _client;
  }

  // Chat Integrator
  static Dio get chatIntegratorUrl {
    if (_apis == null) {
      throw "Cliente não inicializado";
    }
    _client.options.baseUrl = _apis!["chatIntegratorUrl"]!;
    return _client;
  }

  // Whatsapp
  static Dio get whatsapp {
    if (_apis == null) {
      throw "Cliente não inicializado";
    }
    _client.options.baseUrl = _apis!["whatsapp"]!;
    return _client;
  }
}
