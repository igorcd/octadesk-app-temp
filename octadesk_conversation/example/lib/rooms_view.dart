import 'package:flutter/material.dart';
import 'package:octadesk_conversation/octadesk_conversation.dart';
import 'package:octadesk_core/models/room/room_pagination_model.dart';

class RoomsView extends StatelessWidget {
  final void Function(String key) onSelectRoom;
  const RoomsView({required this.onSelectRoom, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<RoomPaginationModel?>(
      stream: OctadeskConversation.instance.getRoomsListStream(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Text("Carregando");
        }

        return ListView.separated(
          separatorBuilder: (c, i) => Divider(height: 1, thickness: 1),
          itemCount: snapshot.data!.rooms.length,
          itemBuilder: (context, index) {
            var room = snapshot.data!.rooms[index];
            return ListTile(
              onTap: () => onSelectRoom(room.key),
              title: Text(room.user.name),
              subtitle: Text(room.lastMessage, maxLines: 1, overflow: TextOverflow.ellipsis),
            );
          },
        );
      },
    );
  }
}
