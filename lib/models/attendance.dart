import 'package:kader/models/attendance_status.dart';

class Attendance {
  String? id;
  String employeeId;
  DateTime date;
  DateTime? attendance;
  DateTime? leaving;

  AttendanceStatus attendanceStatus;

  Attendance({
    this.id,
    required this.employeeId,
    required this.date,
    this.attendance,
    this.leaving,
    required this.attendanceStatus,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'employeeId': employeeId,
      'date': date.toIso8601String(),
      'attendance': attendance?.toIso8601String(),
      'leaving': leaving?.toIso8601String(),
      'attendanceStatus': attendanceStatus.toString(),
    };
  }

  factory Attendance.fromMap(Map<String, dynamic> map) {
    return Attendance(
      id: map['id'],
      employeeId: map['employeeId'],
      date: DateTime.parse(map['date']),
      attendance: DateTime.tryParse(map['attendance'] ?? ''),
      leaving: DateTime.tryParse(map['leaving'] ?? ''),
      attendanceStatus: AttendanceStatus.fromString(map['attendanceStatus']),
    );
  }
}
