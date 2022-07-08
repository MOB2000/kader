import 'package:flutter/material.dart';
import 'package:kader/localization/language/languages.dart';
import 'package:kader/models/attendance.dart';
import 'package:kader/providers/attendance_provider.dart';
import 'package:kader/providers/auth_provider.dart';
import 'package:kader/widgets/attendance_history_widget.dart';
import 'package:kader/widgets/loading_widget.dart';
import 'package:provider/provider.dart';

class AttendanceHistoryScreen extends StatelessWidget {
  static const routeName = 'AttendanceHistoryScreen';

  const AttendanceHistoryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final languages = Languages.of(context);
    final provider = Provider.of<AttendanceProvider>(context);
    final user = Provider.of<AuthProvider>(context).user;

    return Scaffold(
      appBar: AppBar(
        title: Text(languages.attendanceHistory),
      ),
      body: FutureBuilder<List<Attendance>>(
        future: provider.getEmployeeAttendanceHistory(user),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            final history = snapshot.data!;
            if (history.isEmpty) {
              return Center(child: Text(languages.noData));
            }
            return ListView.builder(
              itemCount: history.length,
              itemBuilder: (context, index) =>
                  AttendanceHistoryWidget(attendance: history[index]),
            );
          }

          return const LoadingWidget();
        },
      ),
    );
  }
}
