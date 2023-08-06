import 'package:flutter/material.dart';
import 'package:kader/localization/language/languages.dart';
import 'package:kader/models/attendance.dart';
import 'package:kader/models/attendance_status.dart';
import 'package:kader/providers/attendance_provider.dart';
import 'package:kader/providers/auth_provider.dart';
import 'package:kader/screens/attendance/attendance_history_screen.dart';
import 'package:kader/screens/attendance/employees_attendance_history_screen.dart';
import 'package:kader/services/strings_helper.dart';
import 'package:kader/widgets/loading_widget.dart';
import 'package:provider/provider.dart';

class AttendanceScreen extends StatefulWidget {
  static const String routeName = 'AttendanceScreen';

  const AttendanceScreen({Key? key}) : super(key: key);

  @override
  State<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  Attendance attendance = Attendance(
    id: DateTime.now().toIso8601String(),
    employeeId: '',
    employeeName: '',
    date: DateTime.now(),
    attendanceStatus: AttendanceStatus.attendance,
  );

  @override
  Widget build(BuildContext context) {
    final languages = Languages.of(context);

    final user = Provider.of<AuthProvider>(context).user;
    final attendanceProvider = Provider.of<AttendanceProvider>(context);

    attendance.employeeId = user.id;
    attendance.employeeName = user.name;

    return Scaffold(
      appBar: AppBar(
        title: Text(languages.attendance),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: FutureBuilder<Attendance?>(
          future: attendanceProvider.checkSavedAttendance(user),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              attendance = snapshot.data ?? attendance;

              return Column(
                children: <Widget>[
                  Text(StringsHelper.getDay(attendance.date)),
                  Text(StringsHelper.getDate(attendance.date)),
                  const SizedBox(height: 12),
                  if (attendance.attendanceStatus == AttendanceStatus.absence)
                    Center(child: Text(languages.absenceSaved)),
                  if (attendance.attendanceStatus == AttendanceStatus.vacation)
                    Center(child: Text(languages.vacationSaved)),
                  if (attendance.attendanceStatus != AttendanceStatus.absence &&
                      attendance.attendanceStatus !=
                          AttendanceStatus.vacation) ...[
                    Row(
                      children: <Widget>[
                        SizedBox(
                          width: 64,
                          child: Text(languages.attendance),
                        ),
                        if (attendance.attendance != null)
                          Text(StringsHelper.getHour(attendance.attendance!)),
                        if (attendance.attendance == null)
                          TextButton(
                            child: Text(languages.checkAttendance),
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
                    if (attendance.attendance != null)
                      Row(
                        children: <Widget>[
                          SizedBox(
                            width: 64,
                            child: Text(languages.leaving),
                          ),
                          if (attendance.leaving != null)
                            Text(StringsHelper.getHour(attendance.leaving!)),
                          if (attendance.leaving == null)
                            TextButton(
                              child: Text(languages.checkLeaving),
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
                    if (attendance.attendanceStatus !=
                            AttendanceStatus.absence &&
                        attendance.attendanceStatus !=
                            AttendanceStatus.vacation)
                      TextButton(
                        child: Text(languages.checkAbsence),
                        onPressed: () async {
                          attendance.attendance = null;
                          attendance.leaving = null;
                          attendance.attendanceStatus =
                              AttendanceStatus.absence;
                          await attendanceProvider.updateAttendance(attendance);
                        },
                      ),
                  TextButton(
                    child: Text(languages.showHistory),
                    onPressed: () {
                      Navigator.of(context)
                          .pushNamed(AttendanceHistoryScreen.routeName);
                    },
                  ),
                  if (user.isManager)
                    TextButton(
                      child: Text(languages.showEmployeesHistory),
                      onPressed: () {
                        Navigator.of(context).pushNamed(
                            EmployeesAttendanceHistoryScreen.routeName);
                      },
                    ),
                ],
              );
            }

            return const LoadingWidget();
          },
        ),
      ),
    );
  }
}
