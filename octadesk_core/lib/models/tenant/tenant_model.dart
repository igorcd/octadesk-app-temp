import 'package:octadesk_core/dtos/index.dart';

class TenantModel {
  final String name;
  final String subdomain;
  final String id;

  TenantModel({
    required this.name,
    required this.id,
    required this.subdomain,
  });

  factory TenantModel.fromDTO(TenantDTO dto) {
    return TenantModel(
      name: dto.name,
      id: dto.id,
      subdomain: dto.subdomain,
    );
  }

  factory TenantModel.fromTenantStatusDTO(TenantStatusDTO dto) {
    return TenantModel(
      name: dto.subDomain,
      id: dto.tenantId,
      subdomain: dto.subDomain,
    );
  }

  TenantModel clone() {
    return TenantModel(name: name, id: id, subdomain: subdomain);
  }
}
