import 'package:flutter/material.dart';
import 'package:kader/models/attendance.dart';
import 'package:kader/providers/attendance_provider.dart';
import 'package:kader/providers/auth_provider.dart';
import 'package:kader/widgets/employee_attendance_history.dart';
import 'package:kader/widgets/loading_widget.dart';
import 'package:provider/provider.dart';

class EmployeesAttendanceHistoryScreen extends StatelessWidget {
  static const String routeName = 'EmployeesAttendanceHistoryScreen';

  const EmployeesAttendanceHistoryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AuthProvider>(context).user;
    final provider = Provider.of<AttendanceProvider>(context);

    return Scaffold(
      appBar: AppBar(),
      body: FutureBuilder<List<Attendance>>(
        future: provider.allDepartmentEmployeesAttendance(user),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            final attendance = snapshot.data!;
            return ListView.builder(
              itemCount: attendance.length,
              itemBuilder: (context, index) {
                return EmployeeAttendanceHistory(attendance: attendance[index]);
              },
            );
          }

          return const LoadingWidget();
        },
      ),
    );
  }
}
