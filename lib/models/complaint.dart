import 'package:kader/constants/keys.dart';

class Complaint {
  String? id;
  final String ownerId;
  final String ownerName;
  final String title;
  final String body;
  final bool showOwner;
  String? reply;
  final DateTime dateTime;

  Complaint({
    required this.ownerId,
    required this.ownerName,
    required this.title,
    required this.body,
    required this.showOwner,
    required this.reply,
    required this.dateTime,
    this.id,
  });

  bool get hasReply => reply != null;

  Complaint.fromMap(Map<String, dynamic> map)
      : ownerId = map[Keys.ownerId],
        ownerName = map[Keys.ownerName],
        title = map[Keys.title],
        body = map[Keys.body],
        reply = map[Keys.reply],
        showOwner = map[Keys.showOwner],
        id = map[Keys.id],
        dateTime = DateTime.parse(map[Keys.date]);

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      Keys.ownerId: ownerId,
      Keys.ownerName: ownerName,
      Keys.title: title,
      Keys.body: body,
      Keys.showOwner: showOwner,
      Keys.reply: reply,
      Keys.id: id,
      Keys.date: dateTime.toIso8601String(),
    };
  }
}
