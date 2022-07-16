import 'package:flutter/material.dart';
import 'package:kader/models/meeting.dart';
import 'package:kader/models/meeting_employee.dart';
import 'package:kader/providers/meeting_provider.dart';
import 'package:kader/widgets/meeting_all_employee_widget.dart';
import 'package:provider/provider.dart';

class MeetingAllEmployeeScreen extends StatefulWidget {
  final String meetingID;
  final MeetingEmployee meetingEmployee;

  const MeetingAllEmployeeScreen(
      {Key? key, required this.meetingID, required this.meetingEmployee})
      : super(key: key);

  @override
  State<MeetingAllEmployeeScreen> createState() =>
      _meetingAllEmployeeScreenState();
}

class _meetingAllEmployeeScreenState extends State<MeetingAllEmployeeScreen> {
  @override
  Widget build(BuildContext context) {
    final meetingProvider = Provider.of<MeetingProvider>(context);

    return Column(
      children: [
        Container(
          margin: const EdgeInsets.only(top: 10, bottom: 10),
          height: 300,
          child: FutureBuilder<List<Meeting>>(
            future: meetingProvider.getMeetingsID(widget.meetingEmployee.meetID),
            builder: (context, snapshot) {
              final meeting = snapshot.data;
              if (meeting != null) {
                return ListView.builder(
                    itemCount: meeting.length,
                    itemBuilder: (context, index) {

                  return meetingAllEmployeeWidget(
                    meetingEmployee: widget.meetingEmployee,
                  );
                });
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            },
          ),
        )
      ],
    );
  }
}
