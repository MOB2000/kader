import 'package:kader/constants/keys.dart';

class MeetingEmployee {
  String? id;
  final String meetId;
  final String ownerId;
  final String ownerName;
  bool? reply;

  MeetingEmployee({
    this.id,
    required this.meetId,
    this.reply,
    required this.ownerName,
    required this.ownerId,
  });

  bool get hasReply => reply != true;

  MeetingEmployee.fromMap(Map<String, dynamic> map)
      : meetId = map[Keys.meetId],
        ownerId = map[Keys.ownerId],
        ownerName = map[Keys.ownerName],
        reply = map[Keys.reply],
        id = map[Keys.id];

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      Keys.meetId: meetId,
      Keys.ownerId: ownerId,
      Keys.ownerName: ownerName,
      Keys.reply: reply,
      Keys.id: id,
    };
  }
}
