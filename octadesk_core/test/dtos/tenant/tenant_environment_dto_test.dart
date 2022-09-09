import 'package:flutter_test/flutter_test.dart';
import 'package:octadesk_core/dtos/index.dart';
import 'package:octadesk_core/mock/dtos/tenant/tenant_environment_dto.mock.dart' as mock;

void main() {
  test('Mapeamento de json para dto do TenantEnvironmentDTO', () {
    var dto = TenantEnvironmentDTO.fromMap(mock.tenantEnvironmentDtoMock);
    expect(dto.runtimeType, TenantEnvironmentDTO);
  });
}
