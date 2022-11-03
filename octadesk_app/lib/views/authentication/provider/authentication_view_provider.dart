import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:octadesk_app/providers/authentication_provider.dart';
import 'package:octadesk_app/router/public_router.dart';
import 'package:octadesk_app/utils/helper_functions.dart';
import 'package:octadesk_core/dtos/index.dart';
import 'package:octadesk_core/models/index.dart';
import 'package:octadesk_services/enums/authentication_provider_enum.dart';

class AuthenticationViewProvider extends ChangeNotifier {
  final BuildContext _context;
  // ====== State ======
  final AuthenticationProvider _authenticationProvider;

  AuthenticationViewProvider(this._context, this._authenticationProvider);

  // Autovalidar
  bool _autoValidate = false;
  bool get autoValidate => _autoValidate;

  // Loading
  bool _loading = false;
  bool get loading => _loading;

  // Tenants select opened
  bool _tenantSelectOpened = false;
  bool get tenantSelectOpened => _tenantSelectOpened;

  List<TenantModel> _tenants = [];
  List<TenantModel> get tenants => _tenants;

  // ====== Keys ======
  final _form = GlobalKey<FormState>();
  GlobalKey<FormState> get form => _form;

  // ====== Focus Nodes ======
  final FocusNode _passwordFocusNode = FocusNode();
  FocusNode get passwordFocusNode => _passwordFocusNode;

  // ====== Controllers ======
  final _emailController = TextEditingController();
  TextEditingController get emailController => _emailController;

  final _passwordController = TextEditingController();
  TextEditingController get passwordController => _passwordController;

  // ====== Métodos ======

  /// Autenticar
  void authenticate({String? tenantId, bool skipValidation = false}) async {
    var navigator = GoRouter.of(_context);
    FocusScope.of(_context).unfocus();

    try {
      _autoValidate = true;
      notifyListeners();

      var isValid = _form.currentState?.validate() ?? false;

      if (!_loading && (isValid || skipValidation)) {
        // Verificar conexão com a internet
        var connectivityResult = await (Connectivity().checkConnectivity());
        if (connectivityResult == ConnectivityResult.none) {
          throw "Parece que você está sem acesso a internet";
        }

        _loading = true;
        notifyListeners();
        await _authenticationProvider.authenticate(
          AuthDTO(
            userName: _emailController.text,
            password: _passwordController.text,
            tenantId: tenantId,
          ),
          AuthenticationProviderEnum.email,
        );

        navigator.goNamed(AppRouter.chatFeature);
      }
    }

    // Caso de erro na requsição
    on DioError catch (e) {
      var errorCode = e.response?.statusCode ?? 500;

      // Verificar se é mais de uma tenant
      if (errorCode == 409 && e.response?.data != null) {
        // Mapear tenant para serem selecionadas
        var tenantsList = TenantListDTO.fromMap(e.response!.data);
        var tenants = tenantsList.tenants.map((e) => TenantModel.fromDTO(e)).toList();
        _tenants = tenants;
        _tenantSelectOpened = true;
        notifyListeners();
        return;
      }

      if (errorCode == 403 || errorCode == 404) {
        displayAlertHelper(_context, subtitle: "Seu usuário ou senha estão errados");
        return;
      }

      displayAlertHelper(_context, subtitle: "Não foi possível realizar a requisição, tente novamente em breve");
    }

    // Erro genérico
    catch (e) {
      displayAlertHelper(_context, subtitle: e.toString());
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  /// Fechar o select de tenants
  void closeTenantSelect() {
    _tenantSelectOpened = false;
    notifyListeners();
    Timer(const Duration(milliseconds: 150), () {
      _tenants = [];
      notifyListeners();
    });
  }

  /// Selecionar tenant
  void selectTenant(BuildContext context, String tenantId) {
    closeTenantSelect();
    authenticate(tenantId: tenantId, skipValidation: true);
  }

  @override
  void dispose() {
    _passwordFocusNode.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
