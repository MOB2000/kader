import 'package:kader/constants/keys.dart';

enum RequestStatus {
  pending,
  accepted,
  rejected;

  @override
  String toString() {
    return this == pending
        ? Keys.pending
        : this == accepted
            ? Keys.accepted
            : Keys.rejected;
  }

  static RequestStatus fromString(String string) {
    return string == Keys.pending
        ? pending
        : string == Keys.accepted
            ? accepted
            : rejected;
  }
}
