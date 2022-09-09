import 'package:flutter_test/flutter_test.dart';
import 'package:octadesk_core/dtos/tenant/tenant_dto.dart';
import 'package:octadesk_core/mock/dtos/tenant/tenant_dto.mock.dart' as mock;

void main() {
  test('Mapeamento de JSON para DTO do TenantDTO', () {
    var tenantDTO = TenantDTO.fromMap(mock.tenantDtoMock);
    expect(tenantDTO.runtimeType, TenantDTO);
  });
}
