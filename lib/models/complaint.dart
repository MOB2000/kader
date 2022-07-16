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
      : ownerId = map['ownerId'],
        ownerName = map['ownerName'],
        title = map['title'],
        body = map['body'],
        reply = map['reply'],
        showOwner = map['showOwner'],
        id = map['ID'],
        dateTime = DateTime.parse(map['dateTime']);

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'ownerId': ownerId,
      'ownerName': ownerName,
      'title': title,
      'body': body,
      'showOwner': showOwner,
      'reply': reply,
      'ID': id,
      'dateTime': dateTime.toIso8601String(),
    };
  }
}
