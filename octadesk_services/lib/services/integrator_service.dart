import 'package:octadesk_core/dtos/index.dart';
import 'package:octadesk_services/http_clients/octa_client.dart';

class IntegratorService {
  static Future<List<IntegratorDTO>> getIntegrators() async {
    var resp = await OctaClient.chatIntegratorUrl.get('/');
    return List.from(resp.data).map((e) => IntegratorDTO.fromMap(e)).toList();
  }

  static Future<List<IntegratorNumberDTO>> getIntegratorNumbers() async {
    var resp = await OctaClient.chatIntegratorUrl.get('/whatsapp/numbers');
    return List.from(resp.data).map((e) => IntegratorNumberDTO.fromMap(e)).toList();
  }
}
