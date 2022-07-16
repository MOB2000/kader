class MeetingEmployee {
  String? id;
  final String meetID;
  final String ownerId;
  final String ownerName;
  bool? reply;

  MeetingEmployee({
    this.id,
    required this.meetID,
    this.reply,
    required this.ownerName,
    required this.ownerId,
  });

  bool get hasReply => reply != true;

  MeetingEmployee.fromMap(Map<String, dynamic> map)
      : meetID = map['meetID'],
        ownerId = map['ownerId'],
        ownerName = map['ownerName'],
        reply = map['reply'],
        id = map['ID'];

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'meetID': meetID,
      'ownerId': ownerId,
      'ownerName': ownerName,
      'reply': reply,
      'ID': id,
    };
  }
}
