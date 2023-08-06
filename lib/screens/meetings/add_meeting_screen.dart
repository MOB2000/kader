import 'package:flutter/material.dart';
import 'package:kader/localization/language/languages.dart';
import 'package:kader/models/department.dart';
import 'package:kader/models/meeting.dart';
import 'package:kader/providers/meeting_provider.dart';
import 'package:kader/services/helpers.dart';
import 'package:kader/services/shared_preferences_helper.dart';
import 'package:kader/services/strings_helper.dart';
import 'package:provider/provider.dart';
import 'package:time_range_picker/time_range_picker.dart';

class AddMeetingScreen extends StatefulWidget {
  final Department department;

  const AddMeetingScreen({
    Key? key,
    required this.department,
  }) : super(key: key);

  @override
  State<AddMeetingScreen> createState() => _AddMeetingScreenState();
}

class _AddMeetingScreenState extends State<AddMeetingScreen> {
  final addMeetingFormKey = GlobalKey<FormState>();

  final placeController = TextEditingController();
  final subjectController = TextEditingController();

  Future<void> openDialog(BuildContext context, Languages languages) async {
    await showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text(languages.meetingMessage),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                  },
                  child: Text(languages.ok),
                )
              ],
            ));
  }

  DateTime date = DateTime.now().add(const Duration(days: 1));

  TimeRange time = TimeRange(
      startTime: TimeOfDay.now(),
      endTime:
          TimeOfDay.fromDateTime(DateTime.now().add(const Duration(hours: 1))));

  @override
  Widget build(BuildContext context) {
    final meetingProvider = Provider.of<MeetingProvider>(context);
    final languages = Languages.of(context);
    final user = SharedPreferencesHelper.instance.account;

    return Scaffold(
      appBar: AppBar(
        title: Text(languages.addMeeting),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: addMeetingFormKey,
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Text('${languages.date}: '),
                    Text(StringsHelper.getDayDate(date)),
                    TextButton(
                      onPressed: () async {
                        final selectedDate = await showDatePicker(
                          context: context,
                          initialDate: date,
                          firstDate: DateTime.now(),
                          lastDate:
                              DateTime.now().add(const Duration(days: 10)),
                        );
                        if (selectedDate != null) {
                          setState(() {
                            date = selectedDate;
                          });
                        }
                      },
                      child: Text(languages.change),
                    ),
                  ],
                ),
                Row(
                  children: <Widget>[
                    Text('${languages.time}: '
                        '${languages.from} ${StringsHelper.getHourMinute(time.startTime)} '
                        '${languages.to} ${StringsHelper.getHourMinute(time.endTime)}'),
                    TextButton(
                      child: Text(languages.change),
                      onPressed: () async {
                        time = await showTimeRangePicker(
                          context: context,
                          start: time.startTime,
                          end: time.endTime,
                        );

                        setState(() {});
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: placeController,
                  decoration: InputDecoration(
                    labelText: languages.place,
                    alignLabelWithHint: true,
                  ),
                  validator: (value) => checkEmpty(value, languages.enterValue),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: subjectController,
                  decoration: InputDecoration(
                    labelText: languages.subject,
                    alignLabelWithHint: true,
                  ),
                  validator: (value) => checkEmpty(value, languages.enterValue),
                ),
                const SizedBox(height: 32),
                TextButton(
                  child: Text(
                    languages.addMeeting,
                    style: const TextStyle(
                      fontSize: 20,
                    ),
                  ),
                  onPressed: () async {
                    if (addMeetingFormKey.currentState!.validate()) {
                      addMeetingFormKey.currentState!.save();

                      await meetingProvider.addMeeting(
                        Meeting(
                          departmentId: widget.department.id!,
                          ownerId: user.id,
                          date: date,
                          time: time,
                          place: placeController.text,
                          subject: subjectController.text,
                        ),
                      );

                      if (!mounted) return;
                      await openDialog(context, languages);
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
