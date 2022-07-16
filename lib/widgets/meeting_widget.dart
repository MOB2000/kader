import 'package:flutter/material.dart';
import 'package:kader/localization/language/languages.dart';
import 'package:kader/models/meeting.dart';
import 'package:kader/providers/departments_provider.dart';
import 'package:kader/screens/meeting_employee_details_screen.dart';
import 'package:kader/screens/send_request_meet_screen.dart';
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
        children: [
          Row(
            children: [
              Text(
                "${languages.meetingDate}: ${widget.meeting.date}",
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              const Spacer(),
              Text(
                "${languages.hour}: ${widget.meeting.hour}",
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
            ],
          ),
          const SizedBox(height: 15),
          Row(
            children: [
              Text(
                "${languages.meetingAddress} : ${widget.meeting.subject}",
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              )
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                  child: ElevatedButton.icon(
                icon: const Icon(
                  Icons.add,
                  size: 20,
                ),
                label: const Text("دعوة موظفين"),
                onPressed: () async {
                  var department = await departmentsProvider
                      .getDepartmentId(widget.meeting.departmentId);
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
                child: ElevatedButton.icon(
                  icon: const Icon(
                    Icons.details,
                    size: 20,
                  ),
                  label: const Text("تفاصيل"),
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
