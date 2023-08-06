import 'package:flutter/material.dart';
import 'package:kader/localization/language/languages.dart';
import 'package:kader/models/complaint.dart';
import 'package:kader/providers/complaints_provider.dart';
import 'package:kader/services/helpers.dart';
import 'package:kader/services/shared_preferences_helper.dart';
import 'package:provider/provider.dart';

class AddComplaintsScreen extends StatefulWidget {
  static const String routeName = 'AddComplaintsScreen';

  const AddComplaintsScreen({Key? key}) : super(key: key);

  @override
  State<AddComplaintsScreen> createState() => _AddComplaintsScreenState();
}

class _AddComplaintsScreenState extends State<AddComplaintsScreen> {
  bool showOwner = true;
  final addComplaintFormKey = GlobalKey<FormState>();
  final titleController = TextEditingController();
  final bodyController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final user = SharedPreferencesHelper.instance.account;
    final languages = Languages.of(context);
    final provider = Provider.of<ComplaintsProvider>(context);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(languages.addComplaintsTitle),
      ),
      body: Form(
        key: addComplaintFormKey,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: <Widget>[
              const SizedBox(height: 8),
              TextFormField(
                controller: titleController,
                decoration: InputDecoration(
                  labelText: languages.titleComplaints,
                ),
                validator: (value) => checkEmpty(value, languages.enterValue),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: bodyController,
                decoration: InputDecoration(
                  labelText: languages.contentComplaints,
                  alignLabelWithHint: true,
                ),
                validator: (value) => checkEmpty(value, languages.enterValue),
                minLines: 8,
                maxLines: 15,
              ),
              const SizedBox(height: 12),
              CheckboxListTile(
                title: Text(languages.showName),
                value: showOwner,
                onChanged: (v) {
                  setState(() {
                    showOwner = v!;
                  });
                },
              ),
              const SizedBox(height: 20),
              TextButton(
                child: Text(
                  languages.addComplaints,
                  style: const TextStyle(
                    fontSize: 20,
                  ),
                ),
                onPressed: () async {
                  if (addComplaintFormKey.currentState!.validate()) {
                    addComplaintFormKey.currentState!.save();
                    final complaint = Complaint(
                      ownerId: user.id,
                      ownerName: user.name,
                      title: titleController.text,
                      body: bodyController.text,
                      showOwner: showOwner,
                      reply: null,
                      dateTime: DateTime.now(),
                    );

                    provider.addComplaint(complaint);
                    Navigator.of(context).pop();
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
