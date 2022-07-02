import 'package:flutter/material.dart';
import 'package:kader/models/attendance.dart';
import 'package:kader/models/attendance_status.dart';
import 'package:kader/services/strings_helper.dart';

class AttendanceHistoryWidget extends StatelessWidget {
  final Attendance attendance;

  const AttendanceHistoryWidget({
    Key? key,
    required this.attendance,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(StringsHelper.getDayDate(attendance.date)),
          if (attendance.attendanceStatus == AttendanceStatus.attendance) ...[
            Text(attendance.attendanceStatus.toString()),
            Text('الحضور ${StringsHelper.getHour(attendance.attendance!)}'),
            Text('الانصراف ${StringsHelper.getHour(attendance.leaving!)}'),
          ],
          if (attendance.attendanceStatus != AttendanceStatus.attendance) ...[
            Text(attendance.attendanceStatus.toString()),
          ],
          const Divider(thickness: 8),
        ],
      ),
    );
  }
}
