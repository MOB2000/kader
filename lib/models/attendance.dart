import 'package:kader/constants/keys.dart';
import 'package:kader/models/attendance_status.dart';

class Attendance {
  String? id;
  String employeeId;
  String employeeName;
  DateTime date;
  DateTime? attendance;
  DateTime? leaving;

  AttendanceStatus attendanceStatus;

  Attendance({
    this.id,
    required this.employeeId,
    required this.employeeName,
    required this.date,
    this.attendance,
    this.leaving,
    required this.attendanceStatus,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      Keys.id: id,
      Keys.employeeId: employeeId,
      Keys.employeeName: employeeName,
      Keys.date: date.toIso8601String(),
      Keys.attendance: attendance?.toIso8601String(),
      Keys.leaving: leaving?.toIso8601String(),
      Keys.attendanceStatus: attendanceStatus.toString(),
    };
  }

  factory Attendance.fromMap(Map<String, dynamic> map) {
    return Attendance(
      id: map[Keys.id],
      employeeId: map[Keys.employeeId],
      employeeName: map[Keys.employeeName],
      date: DateTime.parse(map[Keys.date]),
      attendance: DateTime.tryParse(map[Keys.attendance] ?? ''),
      leaving: DateTime.tryParse(map[Keys.leaving] ?? ''),
      attendanceStatus: AttendanceStatus.fromString(map[Keys.attendanceStatus]),
    );
  }
}
