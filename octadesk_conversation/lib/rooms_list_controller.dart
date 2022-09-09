import 'package:octadesk_core/octadesk_core.dart';
import 'package:rxdart/rxdart.dart';

class RoomsListController {
  late final BehaviorSubject<RoomPaginationModel?> _roomsListStreamController;

  RoomsListController({required BehaviorSubject<RoomPaginationModel?> roomsListStreamController}) {
    _roomsListStreamController = roomsListStreamController;
  }
}
