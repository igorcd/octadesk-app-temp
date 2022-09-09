import 'package:flutter_test/flutter_test.dart';
import 'package:octadesk_core/dtos/tenant/tenant_list_dto.dart';
import 'package:octadesk_core/mock/dtos/tenant/tenant_list_dto.mock.dart' as mock;

void main() {
  testWidgets('Teste do mapeamento de map para o DTO', (tester) async {
    TenantListDTO tenantList = TenantListDTO.fromMap(mock.tenantListDtoMock);
    expect(tenantList.runtimeType, TenantListDTO);
  });
}
