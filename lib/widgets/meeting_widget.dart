import 'package:flutter/material.dart';
import 'package:kader/localization/language/languages.dart';
import 'package:kader/models/meeting.dart';
import 'package:kader/providers/departments_provider.dart';
import 'package:kader/screens/meetings/meeting_employee_details_screen.dart';
import 'package:kader/screens/meetings/send_request_meet_screen.dart';
import 'package:kader/services/strings_helper.dart';
import 'package:provider/provider.dart';

class MeetingWidget extends StatefulWidget {
  final Meeting meeting;

  const MeetingWidget({
    Key? key,
    required this.meeting,
  }) : super(key: key);

  @override
  State<MeetingWidget> createState() => _MeetingWidgetState();
}

class _MeetingWidgetState extends State<MeetingWidget> {
  @override
  Widget build(BuildContext context) {
    final departmentsProvider = Provider.of<DepartmentsProvider>(context);
    final languages = Languages.of(context);

    return Container(
      margin: const EdgeInsets.all(12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
              "${languages.date}: ${StringsHelper.getDayDate(widget.meeting.date)}"),
          const SizedBox(height: 12),
          Text('${languages.time}: '
              '${languages.from} ${StringsHelper.getHourMinute(widget.meeting.time.startTime)} '
              '${languages.to} ${StringsHelper.getHourMinute(widget.meeting.time.endTime)}'),
          const SizedBox(height: 12),
          Text("${languages.subject}: ${widget.meeting.subject}"),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                  child: TextButton(
                child: Text(languages.inviteEmployees),
                onPressed: () async {
                  var department = await departmentsProvider
                      .getDepartmentById(widget.meeting.departmentId);
                  if (!mounted) return;
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (BuildContext context) =>
                            SendRequestMeetScreen(
                                department: department,
                                meeting: widget.meeting),
                      ));
                },
              )),
              const SizedBox(width: 5),
              Expanded(
                child: TextButton(
                  child: Text(languages.details),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (BuildContext context) =>
                              MeetingEmployeeDetailsScreen(
                                  meeting: widget.meeting),
                        ));
                  },
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
