import 'package:flutter/material.dart';
import 'package:kader/localization/language/languages.dart';
import 'package:kader/models/custody.dart';
import 'package:kader/models/custom_user.dart';
import 'package:kader/providers/custody_provider.dart';
import 'package:kader/services/helpers.dart';
import 'package:kader/services/shared_preferences_helper.dart';
import 'package:provider/provider.dart';

class AddCustodyScreen extends StatefulWidget {
  static const String routeName = 'AddCustodyScreen';

  const AddCustodyScreen({Key? key}) : super(key: key);

  @override
  State<AddCustodyScreen> createState() => _AddCustodyScreenState();
}

class _AddCustodyScreenState extends State<AddCustodyScreen> {
  bool value = true;
  final registerFormKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController reasonController = TextEditingController();
  CustomUser user = SharedPreferencesHelper.instance.account;

  @override
  Widget build(BuildContext context) {
    final languages = Languages.of(context);
    final custodyProvider = Provider.of<CustodyProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(languages.custodyRequest),
      ),
      body: Form(
        key: registerFormKey,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: <Widget>[
              const SizedBox(height: 10),
              TextFormField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: languages.custodyName,
                ),
                validator: (value) => checkEmpty(value, 'ادخل الاسم'),
                onSaved: (value) {
                  value = value!.trim();
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: reasonController,
                decoration: InputDecoration(
                  labelText: languages.reason,
                  alignLabelWithHint: true,
                ),
                validator: (value) => checkEmpty(value, 'ادخل السبب'),
                onSaved: (value) {
                  value = value!.trim();
                },
                minLines: 8,
                maxLines: 15,
              ),
              const SizedBox(height: 20),
              TextButton(
                child: Text(
                  languages.sendRequest,
                  style: const TextStyle(
                    fontSize: 20,
                  ),
                ),
                onPressed: () async {
                  Custody custody = Custody(
                      ownerId: user.id,
                      ownerName: user.name,
                      name: nameController.text,
                      reason: reasonController.text,
                      dateSendRequest: DateTime.now(),
                      dateRequestAccept: DateTime.now());
                  custodyProvider.addCustody(custody);
                  Navigator.of(context).pop();
                },
              ),
              const Spacer(flex: 3),
            ],
          ),
        ),
      ),
    );
  }
}
