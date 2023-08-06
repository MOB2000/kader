import 'package:flutter/material.dart';
import 'package:kader/localization/language/languages.dart';
import 'package:kader/models/meeting.dart';
import 'package:kader/models/meeting_employee.dart';
import 'package:kader/providers/departments_provider.dart';
import 'package:kader/providers/meeting_provider.dart';
import 'package:kader/screens/meetings/add_meeting_screen.dart';
import 'package:kader/services/shared_preferences_helper.dart';
import 'package:kader/widgets/loading_widget.dart';
import 'package:kader/widgets/meeting_all_employee_widget.dart';
import 'package:kader/widgets/meeting_widget.dart';
import 'package:provider/provider.dart';

class MeetingsScreen extends StatefulWidget {
  static const String routeName = 'MeetingsScreen';

  const MeetingsScreen({Key? key}) : super(key: key);

  @override
  State<MeetingsScreen> createState() => _MeetingsScreenState();
}

class _MeetingsScreenState extends State<MeetingsScreen> {
  @override
  Widget build(BuildContext context) {
    final user = SharedPreferencesHelper.instance.account;
    final departmentsProvider = Provider.of<DepartmentsProvider>(context);
    final meetingProvider = Provider.of<MeetingProvider>(context);
    final provider = Provider.of<MeetingProvider>(context);

    final languages = Languages.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(languages.meetings),
      ),
      body: user.isManager
          ? FutureBuilder<List<Meeting>>(
              future: meetingProvider.getMeeting(user.id),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  final meetings = snapshot.data!;
                  return ListView.builder(
                    itemCount: meetings.length,
                    itemBuilder: (context, index) {
                      return MeetingWidget(
                        meeting: meetings[index],
                      );
                    },
                  );
                }
                return const LoadingWidget();
              },
            )
          : FutureBuilder<List<MeetingEmployee>>(
              future: provider.getEmployeeMeetings(user.id),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  final meetings = snapshot.data!;
                  if (meetings.isEmpty) {
                    return Center(child: Text(languages.noData));
                  }
                  return ListView.builder(
                    itemCount: meetings.length,
                    itemBuilder: (context, index) {
                      return MeetingAllEmployeeWidget(
                        meetingEmployee: meetings[index],
                      );
                    },
                  );
                }
                return const LoadingWidget();
              },
            ),
      floatingActionButton: user.isEmployee
          ? null
          : FloatingActionButton(
              child: const Icon(Icons.add),
              onPressed: () async {
                final department =
                    await departmentsProvider.getDepartmentByManagerId(user.id);
                if (!mounted) return;
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) =>
                            AddMeetingScreen(department: department)));
              },
            ),
    );
  }
}
