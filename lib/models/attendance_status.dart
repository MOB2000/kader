import 'package:kader/constants/keys.dart';

enum AttendanceStatus {
  attendance,
  absence,
  officialHoliday,
  vacation;

  @override
  String toString() {
    return this == attendance
        ? Keys.attendance
        : this == absence
            ? Keys.absence
            : this == officialHoliday
                ? Keys.officialHoliday
                : Keys.vacation;
  }

  static AttendanceStatus fromString(String string) {
    return string == Keys.attendance
        ? attendance
        : string == Keys.absence
            ? absence
            : string == Keys.officialHoliday
                ? officialHoliday
                : vacation;
  }
}
