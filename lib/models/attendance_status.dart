import 'package:kader/constants/keys.dart';

enum AttendanceStatus {
  attendance,
  absence,
  vacation;

  @override
  String toString() {
    return this == attendance
        ? Keys.attendance
        : this == absence
            ? Keys.absence
            : Keys.vacation;
  }

  static AttendanceStatus fromString(String string) {
    return string == Keys.attendance
        ? attendance
        : string == Keys.absence
            ? absence
            : vacation;
  }
}
