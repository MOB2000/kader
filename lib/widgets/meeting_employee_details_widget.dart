import 'package:flutter/material.dart';
import 'package:kader/localization/language/languages.dart';
import 'package:kader/models/meeting_employee.dart';

class MeetingEmployeeDetailsWidget extends StatefulWidget {
  final MeetingEmployee meetingEmployee;

  const MeetingEmployeeDetailsWidget({
    Key? key,
    required this.meetingEmployee,
  }) : super(key: key);

  @override
  State<MeetingEmployeeDetailsWidget> createState() =>
      _MeetingEmployeeDetailsWidgetState();
}

class _MeetingEmployeeDetailsWidgetState
    extends State<MeetingEmployeeDetailsWidget> {
  @override
  Widget build(BuildContext context) {
    final languages = Languages.of(context);

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: Colors.black),
      ),
      child: Row(
        children: [
          Text(
            widget.meetingEmployee.ownerName,
            style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
          ),
          const Spacer(),
          widget.meetingEmployee.reply != null
              ? widget.meetingEmployee.reply == true
                  ? Container(
                      padding: const EdgeInsets.all(5),
                      color: Colors.green,
                      child: Text(
                        languages.invitationAccepted,
                        style:
                            const TextStyle(fontSize: 18, color: Colors.white),
                      ),
                    )
                  : Container(
                      padding: const EdgeInsets.all(5),
                      color: Colors.red,
                      child: Text(
                        languages.invitationDeclined,
                        style:
                            const TextStyle(fontSize: 18, color: Colors.white),
                      ),
                    )
              : Container(
                  padding: const EdgeInsets.all(5),
                  color: Colors.blue,
                  child: Text(
                    languages.notSeeInvitation,
                    style: const TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
        ],
      ),
    );
  }
}
