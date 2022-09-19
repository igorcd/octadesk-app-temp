import 'package:octadesk_core/enums/room_filter_enum.dart';
import 'package:octadesk_core/models/index.dart';

class RoomFilterModel {
  final String title;
  final RoomFilterEnum descriptor;
  final Map<String, dynamic> rule;
  final bool Function(RoomListModel room) validator;

  RoomFilterModel({required this.title, required this.descriptor, required this.rule, required this.validator});

  RoomFilterModel clone() {
    return RoomFilterModel(
      title: title,
      descriptor: descriptor,
      rule: {...rule},
      validator: validator,
    );
  }
}
