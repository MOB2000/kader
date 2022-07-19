import 'package:flutter/material.dart';
import 'package:kader/localization/language/languages.dart';
import 'package:kader/models/meeting.dart';
import 'package:kader/models/meeting_employee.dart';
import 'package:kader/providers/meeting_provider.dart';
import 'package:kader/widgets/loading_widget.dart';
import 'package:kader/widgets/meeting_employee_details_widget.dart';
import 'package:kader/widgets/when_empty_widget.dart';
import 'package:provider/provider.dart';

class MeetingEmployeeDetailsScreen extends StatefulWidget {
  final Meeting meeting;

  const MeetingEmployeeDetailsScreen({Key? key, required this.meeting})
      : super(key: key);

  @override
  State<MeetingEmployeeDetailsScreen> createState() =>
      _MeetingEmployeeDetailsScreenState();
}

class _MeetingEmployeeDetailsScreenState
    extends State<MeetingEmployeeDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    final languages = Languages.of(context);
    final provider = Provider.of<MeetingProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(languages.meetingDetails),
      ),
      body: FutureBuilder<List<MeetingEmployee>>(
        future: provider.getMeetingEmployee(widget.meeting.id!),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            final meetings = snapshot.data!;
            if (meetings.isEmpty) {
              return const WhenEmptyWidget();
            }
            return ListView.builder(
              itemCount: meetings.length,
              itemBuilder: (context, index) {
                return MeetingEmployeeDetailsWidget(
                  meetingEmployee: meetings[index],
                );
              },
            );
          }
          return const LoadingWidget();
        },
      ),
    );
  }
}
