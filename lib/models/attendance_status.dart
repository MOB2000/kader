import 'package:kader/constants/keys.dart';

enum AttendanceStatus {
  attendance,
  absence,
  officialHoliday,
  vacation;

  @override
  String toString() {
    return this == attendance
        ? Keys.attendanceStatus
        : this == absence
            ? Keys.absence
            : this == officialHoliday
                ? Keys.officialHoliday
                : Keys.vacation;
  }

  static AttendanceStatus fromString(String string) {
    return string == Keys.attendanceStatus
        ? attendance
        : string == Keys.absence
            ? absence
            : string == Keys.officialHoliday
                ? officialHoliday
                : vacation;
  }
}
