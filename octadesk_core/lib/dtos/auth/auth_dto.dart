class AuthDTO {
  final String? userName;
  final String? password;
  final String? tenantId;
  final String? openIdToken;

  AuthDTO({this.userName, this.password, this.tenantId, this.openIdToken}) : assert((userName != null && password != null) || openIdToken != null);

  Map<String, dynamic> toMap() {
    return {
      'userName': userName?.trim(),
      'password': password?.trim(),
      'tenantId': tenantId?.trim(),
    };
  }

  AuthDTO setTenantId(String newTenantId) {
    return AuthDTO(
      userName: userName,
      password: password,
      tenantId: newTenantId,
      openIdToken: openIdToken,
    );
  }
}
