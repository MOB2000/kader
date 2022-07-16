class Custody {
  String? id;
  final String ownerId;
  final String name;
  final String reason;
  final String ownerName;
  DateTime? dateSendRequest;
  bool reply;
  DateTime? dateRequestAccept;

  Custody({
    this.id,
    required this.ownerId,
    required this.name,
    required this.reason,
    required this.ownerName,
    this.dateSendRequest,
    this.dateRequestAccept,
    this.reply = false,
  });

  bool get hasReply => reply != true;

  Custody.fromMap(Map<String, dynamic> map)
      : ownerId = map['ownerId'],
        name = map['name'],
        ownerName = map['ownerName'],
        reason = map['reason'],
        reply = map['reply'] ?? false,
        id = map['ID'],
        dateSendRequest = DateTime.parse(map['dateSendRequest']),
        dateRequestAccept = DateTime.parse(map['dateRequestAccept']);

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'ownerId': ownerId,
      'name': name,
      'reason': reason,
      'ownerName': ownerName,
      'reply': reply,
      'ID': id,
      'dateRequestAccept': dateRequestAccept?.toIso8601String(),
      'dateSendRequest': dateSendRequest?.toIso8601String()
    };
  }
}
