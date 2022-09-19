import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:octadesk_app/components/index.dart';
import 'package:octadesk_app/utils/helper_functions.dart';
import 'package:octadesk_conversation/octadesk_conversation.dart';
import 'package:octadesk_core/dtos/auth/user_dto.dart';
import 'package:octadesk_core/dtos/tenant/tenant_status_dto.dart';
import 'package:octadesk_core/models/index.dart';
import 'package:octadesk_core/models/user/user_persisted_data_model.dart';
import 'package:octadesk_app/resources/app_constants.dart';
import 'package:octadesk_app/resources/index.dart';
import 'package:octadesk_app/router/public_router.dart';
import 'package:octadesk_core/dtos/auth/auth_dto.dart';
import 'package:octadesk_services/enums/authentication_provider_enum.dart';
import 'package:octadesk_services/http_clients/octa_client.dart';
import 'package:octadesk_services/octadesk_services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthenticationProvider with ChangeNotifier {
  /// Dados de autenticação
  UserModel? _user;
  UserModel? get user => _user?.clone();

  TenantModel? _tenant;
  TenantModel? get tenant => _tenant?.clone();

  Future<void>? _initializationFuture;
  Future<void>? get initializationFuture => _initializationFuture;

  /// Carregar dados do usuário do Nucleus
  Future _loadUserData({required String accessToken, required String jwt}) async {
    var decodedAccessToken = JwtDecoder.decode(accessToken);

    String id = decodedAccessToken["nameid"];
    String tenantId = decodedAccessToken["tnt_id"];

    var resp = await Future.wait([
      NucleusService.getUser(tenantId: tenantId, userId: id),
      NucleusService.checkTenantStatus(tenantId),
    ]);

    // Usuário
    var user = resp[0] as UserDTO;
    var decodedJwtMap = JwtDecoder.decode(jwt);

    _user = UserModel(
      id: id,
      agentId: decodedJwtMap["id"],
      avatar: user.avatarURL,
      email: user.email,
      name: user.lastName != null && user.lastName!.isNotEmpty ? "${user.firstName} ${user.lastName}" : user.firstName,
    );

    _tenant = TenantModel.fromTenantStatusDTO(resp[1] as TenantStatusDTO);
    notifyListeners();
  }

  /// Limpar dados persistidos
  Future<void> _clearUserData() async {
    _user = null;
    _tenant = null;
    disposeHttpClients();
    final storage = await SharedPreferences.getInstance();
    await storage.clear();
  }

  /// Checar se o usuário possui dados persistidos
  Future<bool> _checkIfHasUserDataPersisted() async {
    final storage = await SharedPreferences.getInstance();
    var hasJwt = storage.containsKey(AppConstants.persistedAuthenticationData);

    if (hasJwt) {
      var data = storage.get(AppConstants.persistedAuthenticationData);
      return data != null;
    }

    return hasJwt;
  }

  /// Inicializar cliente HTTP
  Future<void> _initializeOctaHttpClient() async {
    // Inicializar secure storage
    final storage = await SharedPreferences.getInstance();
    var data = storage.getString(AppConstants.persistedAuthenticationData);

    try {
      // Caso tenha dados inválidos armazenados
      if (data == null || data.isEmpty) {
        throw Error();
      }

      var decodedMap = json.decode(data);
      var persistedData = PersistedAuthenticationDataModel.fromMap(decodedMap);

      // Setar as apis
      initializeHttpClients(
        accessToken: persistedData.accessToken,
        apis: persistedData.apis,
        jwt: persistedData.jwt,
      );

      await _loadUserData(
        accessToken: persistedData.accessToken,
        jwt: persistedData.jwt,
      );
    } catch (e) {
      await storage.clear();
      rethrow;
    }
  }

  /// Checar status do agente
  Future<void> _checkUserStatusAndInitializeChat() async {
    var resp = await NucleusService.checkTenantStatus(_tenant!.id);
    if (resp.trialExpired) {
      throw "Seu período gratuito de testes terminou";
    }
    if (resp.isBlocked) {
      throw "Parece que você possui algumas pendências, por favor, entre em contato com nosso suporte";
    }

    // Inicializar chat
    await OctadeskConversation.instance.initialize(
      agentId: user!.agentId,
      socketUrl: OctaClient.getSocketUrl(),
      subDomain: tenant!.subdomain,
    );
  }

  // Checar status da tenant e inicializar o chat
  Future<void> checkUserStatusAndInitializeChat() {
    if (_initializationFuture != null) {
      return _initializationFuture!;
    }

    _initializationFuture = _checkUserStatusAndInitializeChat();
    return _initializationFuture!;
  }

  /// Autenticar
  Future authenticate(AuthDTO data, AuthenticationProviderEnum authenticationMode) async {
    var user = await NucleusService.auth(data, authenticationMode);

    // Armazenar os dados do Usuário no Secure Storage
    final storage = await SharedPreferences.getInstance();
    final persistedData = PersistedAuthenticationDataModel(jwt: user.jwToken, accessToken: user.accessToken, apis: user.apis);

    await storage.setString(AppConstants.persistedAuthenticationData, jsonEncode(persistedData.toMap()));

    initializeHttpClients(
      accessToken: persistedData.accessToken,
      apis: persistedData.apis,
      jwt: persistedData.jwt,
    );

    await _loadUserData(
      accessToken: persistedData.accessToken,
      jwt: persistedData.jwt,
    );
  }

  /// Inicializar a aplicação
  Future initializeApplication(BuildContext context) async {
    var navigator = Navigator.of(context);
    // Verificar se existe usuário persistido
    try {
      bool hasUser = await _checkIfHasUserDataPersisted();

      if (!hasUser) {
        navigator.pushNamedAndRemoveUntil(PublicRouter.onboardingView, (route) => false);
        return;
      }

      // Setar os dados das APIs e JWTs
      await _initializeOctaHttpClient();

      // Setar usuário do Crash Analytics
      navigator.pushNamedAndRemoveUntil(PublicRouter.mainView, (route) => false);
    } catch (e) {
      // Enviar erro para o Firebase
      navigator.pushNamedAndRemoveUntil(PublicRouter.onboardingView, (route) => false);
    }
  }

  /// Logout
  Future logout(BuildContext context) async {
    displayAlertHelper(context, title: "Atenção", subtitle: "Tem certeza que deseja sair do sistema?", actions: [
      OctaAlertDialogAction(primary: false, action: () {}, text: "Voltar"),
      OctaAlertDialogAction(
        primary: true,
        action: () async {
          PublicRouter.navigator.currentState!.pushNamedAndRemoveUntil(PublicRouter.authenticationView, (route) => false);
          await _clearUserData();
        },
        text: "Sair",
      ),
    ]);
  }
}
