import 'package:octadesk_core/dtos/index.dart';

class IntegratorModel {
  final String id;
  final String name;
  final int hoursToAnswer;

  IntegratorModel({required this.id, required this.name, required this.hoursToAnswer});

  factory IntegratorModel.fromDTO(IntegratorDTO dto) {
    return IntegratorModel(
      id: dto.id,
      name: dto.name,
      hoursToAnswer: dto.hoursToAnswer,
    );
  }
}
