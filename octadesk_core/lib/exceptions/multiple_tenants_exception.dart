import 'package:octadesk_core/models/index.dart';

class MultipleTenantsException implements Exception {
  List<TenantModel> tenants;

  MultipleTenantsException(this.tenants);
}
