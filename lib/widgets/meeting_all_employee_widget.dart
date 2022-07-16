import 'package:flutter/material.dart';
import 'package:kader/localization/language/languages.dart';
import 'package:kader/models/meeting.dart';
import 'package:kader/models/meeting_employee.dart';
import 'package:kader/providers/meeting_employee_provider.dart';
import 'package:kader/providers/meeting_provider.dart';
import 'package:provider/provider.dart';

class meetingAllEmployeeWidget extends StatefulWidget {
  final MeetingEmployee meetingEmployee;

  const meetingAllEmployeeWidget({Key? key, required this.meetingEmployee})
      : super(key: key);

  @override
  State<meetingAllEmployeeWidget> createState() =>
      _meetingAllEmployeeWidgetState();
}

class _meetingAllEmployeeWidgetState extends State<meetingAllEmployeeWidget> {
  @override
  Widget build(BuildContext context) {
    final languages = Languages.of(context);
    final meetingEmployeeProvider =
        Provider.of<MeetingEmployeeProvider>(context);
    final meetingProvider = Provider.of<MeetingProvider>(context);
    return Container(
        height: 230,
        margin: const EdgeInsets.only(top: 8, right: 15, left: 15),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.white,
        ),
        child: FutureBuilder<Meeting>(
          future: meetingProvider.getMeetingID(widget.meetingEmployee.meetID),
          builder: (BuildContext context, AsyncSnapshot<Meeting> snapshot) {
            if (snapshot.data != null) {
              Meeting meeting = snapshot.data!;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 15),
                  Row(
                    children: [
                      Text(
                        "${languages.meetingDate} : ${meeting.date}",
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const Spacer(),
                      Text(
                        "${languages.hour} : ${meeting.hour}",
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Text(
                    "${languages.meetingAddress} : ${meeting.subject}",
                    style: const TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "${languages.duration} : ${meeting.duration}",
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 10),
                  Text("${languages.place} : ${meeting.place}"),
                  const SizedBox(height: 30),
                  widget.meetingEmployee.reply != null
                      ? widget.meetingEmployee.reply == true
                          ? Container(
                              alignment: Alignment.center,
                              color: Colors.green,
                              child: const Text(
                                "تم الحضور",
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ))
                          : Container(
                              color: Colors.red,
                              alignment: Alignment.center,
                              child: const Text(
                                "اعتذرت عن الحضور",
                                style: TextStyle(
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
                                  meetingEmployeeProvider.updateMeetingEmployee(
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
                                  meetingEmployeeProvider.updateMeetingEmployee(
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
            } else {
              return const Center(
                  child: CircularProgressIndicator());
            }
          },
        ));
  }
}