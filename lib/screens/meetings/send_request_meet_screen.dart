import 'package:flutter/material.dart';
import 'package:kader/localization/language/languages.dart';
import 'package:kader/models/custom_user.dart';
import 'package:kader/models/department.dart';
import 'package:kader/models/meeting.dart';
import 'package:kader/models/meeting_employee.dart';
import 'package:kader/providers/departments_provider.dart';
import 'package:kader/providers/meeting_provider.dart';
import 'package:kader/widgets/employee_meeting_widget.dart';
import 'package:provider/provider.dart';

class SendRequestMeetScreen extends StatefulWidget {
  final Department department;
  final Meeting meeting;

  const SendRequestMeetScreen(
      {Key? key, required this.department, required this.meeting})
      : super(key: key);

  @override
  State<SendRequestMeetScreen> createState() => _SendRequestMeetScreenState();
}

class _SendRequestMeetScreenState extends State<SendRequestMeetScreen> {
  bool sendToAllEmployees = true;

  Future openDialog(
    BuildContext context,
    Languages languages,
    Department department,
    String meetingId,
    MeetingProvider provider,
    DepartmentsProvider departmentsProvider,
  ) =>
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(languages.inviteAllEmployees),
          actions: [
            TextButton(
              onPressed: () async {
                var list = await departmentsProvider
                    .getDepartmentEmployees(department);
                list.forEach((element) async {
                  var result =
                      await provider.checkExisting(element.id, meetingId);
                  if (result == false) {
                    provider.addMeetingEmployee(MeetingEmployee(
                        meetId: meetingId,
                        ownerName: element.name,
                        ownerId: element.id));
                  }
                });

                Navigator.of(context).pop();
              },
              child: Text(languages.ok),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(languages.no),
            )
          ],
        ),
      );

  @override
  Widget build(BuildContext context) {
    final servicesProvider = Provider.of<DepartmentsProvider>(context);
    final provider = Provider.of<MeetingProvider>(context);

    final languages = Languages.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(languages.sendRequestsEmployees),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 30),
            Row(
              children: [
                Text(
                  languages.selectAllEmployees,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 20),
                ),
                const Spacer(),
                Checkbox(
                    value: sendToAllEmployees,
                    onChanged: (v) {
                      setState(() {
                        sendToAllEmployees = v!;
                      });
                    }),
              ],
            ),
            sendToAllEmployees
                ? ElevatedButton(
                    onPressed: () async {
                      openDialog(context, languages, widget.department,
                          widget.meeting.id!, provider, servicesProvider);
                    },
                    child: Text(languages.inviteAll))
                : Container(),
            const SizedBox(height: 30),
            Container(
                margin: const EdgeInsets.only(top: 10),
                alignment: Alignment.centerRight,
                child: !sendToAllEmployees
                    ? SingleChildScrollView(
                        child: Column(
                          children: [
                            SizedBox(
                              height: MediaQuery.of(context).size.width,
                              child: FutureBuilder<List<CustomUser>>(
                                future: servicesProvider
                                    .getDepartmentEmployees(widget.department),
                                builder: (context, snapshot) {
                                  final users = snapshot.data;
                                  if (users != null) {
                                    return ListView.builder(
                                        itemCount: users.length,
                                        itemBuilder: (context, index) {
                                          return EmployeeMeetingWidget(
                                            user: users[index],
                                            department: widget.department,
                                            meeting: widget.meeting,
                                          );
                                        });
                                  } else {
                                    return const Center(
                                      child: CircularProgressIndicator(),
                                    );
                                  }
                                },
                              ),
                            )
                          ],
                        ),
                      )
                    : const Text("")),
          ],
        ),
      ),
    );
  }
}
