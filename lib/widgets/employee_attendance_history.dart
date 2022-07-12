import 'package:flutter/material.dart';
import 'package:kader/models/attendance.dart';
import 'package:kader/widgets/attendance_history_widget.dart';

class EmployeeAttendanceHistory extends StatelessWidget {
  final Attendance attendance;

  const EmployeeAttendanceHistory({
    Key? key,
    required this.attendance,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Text(attendance.employeeName),
        AttendanceHistoryWidget(attendance: attendance),
      ],
    );
  }
}
