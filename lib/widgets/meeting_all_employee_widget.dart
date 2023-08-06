import 'package:flutter/material.dart';
import 'package:kader/localization/language/languages.dart';
import 'package:kader/models/meeting.dart';
import 'package:kader/models/meeting_employee.dart';
import 'package:kader/providers/meeting_provider.dart';
import 'package:kader/services/strings_helper.dart';
import 'package:kader/widgets/loading_widget.dart';
import 'package:provider/provider.dart';

class MeetingAllEmployeeWidget extends StatefulWidget {
  final MeetingEmployee meetingEmployee;

  const MeetingAllEmployeeWidget({Key? key, required this.meetingEmployee})
      : super(key: key);

  @override
  State<MeetingAllEmployeeWidget> createState() =>
      _MeetingAllEmployeeWidgetState();
}

class _MeetingAllEmployeeWidgetState extends State<MeetingAllEmployeeWidget> {
  @override
  Widget build(BuildContext context) {
    final languages = Languages.of(context);
    final provider = Provider.of<MeetingProvider>(context);
    final meetingProvider = Provider.of<MeetingProvider>(context);
    return Container(
        margin: const EdgeInsets.only(top: 8, right: 15, left: 15),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.white,
        ),
        child: FutureBuilder<Meeting>(
          future: meetingProvider.getMeetingById(widget.meetingEmployee.meetId),
          builder: (BuildContext context, AsyncSnapshot<Meeting> snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              final meeting = snapshot.data!;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                      "${languages.date}: ${StringsHelper.getDayDate(meeting.date)}"),
                  const SizedBox(height: 12),
                  Text('${languages.time}: '
                      '${languages.from} ${StringsHelper.getHourMinute(meeting.time.startTime)} '
                      '${languages.to} ${StringsHelper.getHourMinute(meeting.time.endTime)}'),
                  const SizedBox(height: 12),
                  Text(
                    "${languages.subject}: ${meeting.subject}",
                    style: const TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text("${languages.place} : ${meeting.place}"),
                  const SizedBox(height: 30),
                  widget.meetingEmployee.reply != null
                      ? widget.meetingEmployee.reply == true
                          ? Container(
                              alignment: Alignment.center,
                              color: Colors.green,
                              child: Text(
                                languages.hadAttend,
                                style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ))
                          : Container(
                              color: Colors.red,
                              alignment: Alignment.center,
                              child: Text(
                                languages.hadApologize,
                                style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                            )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            TextButton(
                                onPressed: () {
                                  widget.meetingEmployee.reply = true;
                                  provider.updateMeetingEmployee(
                                      widget.meetingEmployee);
                                },
                                child: Text(
                                  languages.presence,
                                  style: const TextStyle(
                                    fontSize: 18,
                                  ),
                                )),
                            const SizedBox(width: 50),
                            TextButton(
                                onPressed: () {
                                  widget.meetingEmployee.reply = false;
                                  provider.updateMeetingEmployee(
                                      widget.meetingEmployee);
                                },
                                child: Text(
                                  languages.apology,
                                  style: const TextStyle(fontSize: 18),
                                )),
                          ],
                        ),
                ],
              );
            }

            return const LoadingWidget();
          },
        ));
  }
}
