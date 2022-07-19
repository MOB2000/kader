import 'package:kader/constants/keys.dart';

class Custody {
  String? id;
  final String name;
  String ownerId;
  String ownerName;
  final String reason;
  DateTime? dateSendRequest;
  DateTime? dateRequestAccept;
  bool hasReply;
  bool hasRequestToTransfer;

  Custody({
    this.id,
    required this.ownerId,
    required this.name,
    required this.reason,
    required this.ownerName,
    this.dateSendRequest,
    this.dateRequestAccept,
    this.hasReply = false,
    this.hasRequestToTransfer = false,
  });

  Custody.fromMap(Map<String, dynamic> map)
      : ownerId = map[Keys.ownerId],
        name = map[Keys.name],
        ownerName = map[Keys.ownerName],
        reason = map[Keys.reason],
        hasReply = map[Keys.reply] ?? false,
        hasRequestToTransfer = map[Keys.hasRequestToTransfer] ?? false,
        id = map[Keys.id],
        dateSendRequest = DateTime.parse(map[Keys.dateSendRequest]),
        dateRequestAccept = DateTime.parse(map[Keys.dateRequestAccept]);

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      Keys.ownerId: ownerId,
      Keys.name: name,
      Keys.reason: reason,
      Keys.ownerName: ownerName,
      Keys.reply: hasReply,
      Keys.hasRequestToTransfer: hasRequestToTransfer,
      Keys.id: id,
      Keys.dateRequestAccept: dateRequestAccept?.toIso8601String(),
      Keys.dateSendRequest: dateSendRequest?.toIso8601String()
    };
  }
}
