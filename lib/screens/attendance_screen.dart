import 'package:flutter/material.dart';
import 'package:kader/localization/language/languages.dart';
import 'package:kader/models/attendance.dart';
import 'package:kader/models/attendance_status.dart';
import 'package:kader/providers/attendance_provider.dart';
import 'package:kader/providers/auth_provider.dart';
import 'package:kader/screens/attendance_history_screen.dart';
import 'package:kader/services/strings_helper.dart';
import 'package:kader/widgets/loading_widget.dart';
import 'package:provider/provider.dart';

class AttendanceScreen extends StatelessWidget {
  static const String routeName = 'AttendanceScreen';

  AttendanceScreen({Key? key}) : super(key: key);

  Attendance attendance = Attendance(
    employeeId: 'employeeId',
    date: DateTime.now(),
    attendanceStatus: AttendanceStatus.attendance,
  );

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AuthProvider>(context).user;
    final attendanceProvider = Provider.of<AttendanceProvider>(context);

    attendance.employeeId = user.id;

    final languages = Languages.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(languages.attendance),
      ),
      body: FutureBuilder<Attendance?>(
          future: attendanceProvider.checkSavedAttendance(user),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              final savedAttendance = snapshot.data;
              if (savedAttendance != null) {
                attendance = savedAttendance;
              }
              return Column(
                children: <Widget>[
                  if (attendance.attendanceStatus == AttendanceStatus.absence)
                    const Center(child: Text('تم تسجيل الغياب ')),
                  if (attendance.attendanceStatus !=
                      AttendanceStatus.absence) ...[
                    Text(StringsHelper.getDay(attendance.date)),
                    Text(StringsHelper.getDate(attendance.date)),
                    Row(
                      children: <Widget>[
                        const Text('الحضور'),
                        if (attendance.attendance != null)
                          Text(StringsHelper.getHour(attendance.attendance!)),
                        if (attendance.attendance == null)
                          TextButton(
                            child: const Text('تسجيل حضور'),
                            onPressed: () async {
                              attendance.attendanceStatus =
                                  AttendanceStatus.attendance;
                              attendance.attendance = DateTime.now();
                              await attendanceProvider
                                  .updateAttendance(attendance);
                            },
                          ),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        const Text('الانصراف'),
                        if (attendance.leaving != null)
                          Text(StringsHelper.getHour(attendance.leaving!)),
                        if (attendance.leaving == null)
                          TextButton(
                            child: const Text('تسجيل انصراف'),
                            onPressed: () async {
                              attendance.attendanceStatus =
                                  AttendanceStatus.attendance;
                              attendance.leaving = DateTime.now();

                              await attendanceProvider
                                  .updateAttendance(attendance);
                            },
                          ),
                      ],
                    ),
                  ],
                  if (attendance.attendance == null &&
                      attendance.leaving == null)
                    TextButton(
                      child: const Text('تسجيل غياب'),
                      onPressed: () async {
                        attendance.attendance = null;
                        attendance.leaving = null;
                        attendance.attendanceStatus = AttendanceStatus.absence;
                        await attendanceProvider.updateAttendance(attendance);
                      },
                    ),
                  TextButton(
                    child: const Text('عرض السجل'),
                    onPressed: () {
                      Navigator.of(context)
                          .pushNamed(AttendanceHistoryScreen.routeName);
                    },
                  ),
                ],
              );
            }

            return const LoadingWidget();
          }),
    );
  }
}
