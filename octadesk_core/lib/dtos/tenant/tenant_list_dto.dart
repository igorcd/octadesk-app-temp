import 'package:octadesk_core/dtos/tenant/tenant_dto.dart';

class TenantListDTO {
  final List<TenantDTO> tenants;

  TenantListDTO(this.tenants);

  factory TenantListDTO.fromMap(Map<String, dynamic> map) {
    var tenants = List.from(map["tenants"]).map((e) => TenantDTO.fromMap(e)).toList();
    return TenantListDTO(tenants);
  }
}
