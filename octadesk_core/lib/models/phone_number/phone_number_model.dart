import 'package:octadesk_core/dtos/integrator/integrator_number_dto.dart';
import 'package:octadesk_core/dtos/number/number_dto.dart';

class PhoneNumberModel {
  final String name;
  final String number;
  final String id;
  final String integrator;

  PhoneNumberModel({
    required this.name,
    required this.number,
    required this.id,
    required this.integrator,
  });

  factory PhoneNumberModel.fromWhatsAppNumber(NumberDTO dto) {
    return PhoneNumberModel(
      name: dto.name,
      number: "+${dto.number}",
      id: dto.id,
      integrator: 'octadesk',
    );
  }

  factory PhoneNumberModel.fromIntegratorNumber(IntegratorNumberDTO dto) {
    return PhoneNumberModel(
      name: dto.name,
      number: dto.number,
      id: dto.id,
      integrator: dto.integrator,
    );
  }
}
