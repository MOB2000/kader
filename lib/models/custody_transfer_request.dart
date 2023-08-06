import 'package:kader/constants/keys.dart';

class CustodyTransferRequest {
  String? id;
  final String custodyId;
  final String custodyName;
  final String fromUserId;
  final String fromUserName;
  final String toUserId;
  final String toUserName;

  CustodyTransferRequest({
    this.id,
    required this.custodyId,
    required this.custodyName,
    required this.fromUserId,
    required this.fromUserName,
    required this.toUserId,
    required this.toUserName,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      Keys.id: id,
      Keys.custodyId: custodyId,
      Keys.custodyName: custodyName,
      Keys.fromUserId: fromUserId,
      Keys.fromUserName: fromUserName,
      Keys.toUserId: toUserId,
      Keys.toUserName: toUserName,
    };
  }

  CustodyTransferRequest.fromMap(Map<String, dynamic> map)
      : id = map[Keys.id],
        custodyId = map[Keys.custodyId],
        custodyName = map[Keys.custodyName],
        fromUserId = map[Keys.fromUserId],
        fromUserName = map[Keys.fromUserName],
        toUserId = map[Keys.toUserId],
        toUserName = map[Keys.toUserName];
}
