import 'package:flutter/material.dart';
import 'package:kader/localization/language/languages.dart';
import 'package:kader/models/department.dart';
import 'package:kader/models/meeting.dart';
import 'package:kader/providers/meeting_provider.dart';
import 'package:kader/services/helpers.dart';
import 'package:kader/services/shared_preferences_helper.dart';
import 'package:provider/provider.dart';

class AddMeetingScreen extends StatefulWidget {
  static const String routeName = 'AddMeetingScreen';
  final Department department;

  const AddMeetingScreen({
    Key? key,
    required this.department,
  }) : super(key: key);

  @override
  State<AddMeetingScreen> createState() => _AddMeetingScreenState();
}

class _AddMeetingScreenState extends State<AddMeetingScreen> {
  bool value = true;
  final addMeetingFormKey = GlobalKey<FormState>();
  final dateController = TextEditingController();
  final hoursController = TextEditingController();
  final durationController = TextEditingController();
  final placeController = TextEditingController();
  final subjectController = TextEditingController();

  Future openDialog(BuildContext context, Languages languages) async {
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
                    child: Text(languages.ok))
              ],
            ));
  }

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
                // TODO: use date picker
                TextFormField(
                  controller: dateController,
                  decoration: InputDecoration(
                    labelText: languages.meetingDate,
                  ),
                  validator: (value) => checkEmpty(value, languages.enterValue),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: hoursController,
                  decoration: InputDecoration(
                    labelText: languages.hour,
                    alignLabelWithHint: true,
                  ),
                  validator: (value) => checkEmpty(value, languages.enterValue),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: durationController,
                  decoration: InputDecoration(
                    labelText: languages.duration,
                    alignLabelWithHint: true,
                  ),
                  validator: (value) => checkEmpty(value, languages.enterValue),
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
                    labelText: languages.meetingAddress,
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
                          date: dateController.text,
                          hour: hoursController.text,
                          duration: durationController.text,
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
