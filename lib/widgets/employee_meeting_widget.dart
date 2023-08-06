import 'package:flutter/material.dart';
import 'package:kader/localization/language/languages.dart';
import 'package:kader/models/custom_user.dart';
import 'package:kader/models/department.dart';
import 'package:kader/models/meeting.dart';
import 'package:kader/models/meeting_employee.dart';
import 'package:kader/providers/meeting_provider.dart';
import 'package:provider/provider.dart';

class EmployeeMeetingWidget extends StatefulWidget {
  final CustomUser user;
  final Department department;
  final Meeting meeting;

  const EmployeeMeetingWidget(
      {Key? key,
      required this.user,
      required this.department,
      required this.meeting})
      : super(key: key);

  @override
  State<EmployeeMeetingWidget> createState() => _EmployeeMeetingWidgetState();
}

class _EmployeeMeetingWidgetState extends State<EmployeeMeetingWidget> {
  @override
  Widget build(BuildContext context) {
    final languages = Languages.of(context);
    final provider = Provider.of<MeetingProvider>(context);

    return Container(
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
        padding: const EdgeInsets.symmetric(horizontal: 15),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.black)),
        child: Row(
          children: [
            Text(
              widget.user.name,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            const Spacer(),
            FutureBuilder<bool>(
              future:
                  provider.checkExisting(widget.user.id, widget.meeting.id!),
              builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
                if (snapshot.data == true) {
                  return ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Colors.green),
                      ),
                      onPressed: () {},
                      child: Text(languages.invited));
                } else {
                  return ElevatedButton(
                    onPressed: () async {
                      await provider.addMeetingEmployee(
                        MeetingEmployee(
                          meetId: widget.meeting.id!,
                          ownerName: widget.user.name,
                          ownerId: widget.user.id,
                        ),
                      );
                    },
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.redAccent),
                    ),
                    child: Text(languages.invitation),
                  );
                }
              },
            ),
          ],
        ));
  }
}
