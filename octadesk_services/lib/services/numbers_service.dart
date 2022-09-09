import 'package:octadesk_core/dtos/number/number_dto.dart';
import 'package:octadesk_services/http_clients/octa_client.dart';

class NumbersService {
  static Future<List<NumberDTO>> getWhatsAppNumbers() async {
    var resp = await OctaClient.whatsApp.get('/numbers');
    return List.from(resp.data).map((e) => NumberDTO.fromMap(e)).toList();
  }
}
