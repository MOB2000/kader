import 'package:flutter/material.dart';
import 'package:kader/localization/language/languages.dart';
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
    final languages = Languages.of(context);

    return Padding(
      padding: const EdgeInsets.all(8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(StringsHelper.getDayDate(attendance.date)),
          Text(StringsHelper.translateAttendanceStatus(
              attendance.attendanceStatus, languages)),
          if (attendance.attendanceStatus == AttendanceStatus.attendance) ...[
            Text(
                '${languages.attendance} ${StringsHelper.getHour(attendance.attendance!)}'),
            if (attendance.leaving != null)
              Text(
                  '${languages.leaving} ${StringsHelper.getHour(attendance.leaving!)}'),
            if (attendance.leaving == null) Text(languages.didNotCheckAbsence),
          ],
          const Divider(thickness: 8),
        ],
      ),
    );
  }
}
