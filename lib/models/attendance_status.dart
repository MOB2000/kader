enum AttendanceStatus {
  attendance,
  absence,
  officialHoliday,
  vacation;

  @override
  String toString() {
    return this == attendance
        ? 'attendance'
        : this == absence
            ? 'absence'
            : this == officialHoliday
                ? 'officialHoliday'
                : 'vacation';
  }

  static AttendanceStatus fromString(String string) {
    return string == 'attendance'
        ? attendance
        : string == 'absence'
            ? absence
            : string == 'officialHoliday'
                ? officialHoliday
                : vacation;
  }
}
