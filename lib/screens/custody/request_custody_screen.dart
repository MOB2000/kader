import 'package:flutter/material.dart';
import 'package:kader/localization/language/languages.dart';
import 'package:kader/models/custody.dart';
import 'package:kader/providers/custody_provider.dart';
import 'package:kader/services/helpers.dart';
import 'package:kader/services/shared_preferences_helper.dart';
import 'package:provider/provider.dart';

class RequestCustodyScreen extends StatefulWidget {
  static const String routeName = 'RequestCustodyScreen';

  const RequestCustodyScreen({Key? key}) : super(key: key);

  @override
  State<RequestCustodyScreen> createState() => _RequestCustodyScreenState();
}

class _RequestCustodyScreenState extends State<RequestCustodyScreen> {
  final requestCustodyFormKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final reasonController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final languages = Languages.of(context);
    final user = SharedPreferencesHelper.instance.account;

    final custodyProvider = Provider.of<CustodyProvider>(context);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(languages.custodyRequest),
      ),
      body: Form(
        key: requestCustodyFormKey,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: <Widget>[
              const SizedBox(height: 10),
              TextFormField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: languages.name,
                ),
                validator: (value) => checkEmpty(value, languages.enterValue),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: reasonController,
                decoration: InputDecoration(
                  labelText: languages.reason,
                ),
                validator: (value) => checkEmpty(value, languages.enterValue),
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
                  if (requestCustodyFormKey.currentState!.validate()) {
                    requestCustodyFormKey.currentState!.save();

                    await custodyProvider.addCustody(
                      Custody(
                        ownerId: user.id,
                        ownerName: user.name,
                        name: nameController.text,
                        reason: reasonController.text,
                        dateSendRequest: DateTime.now(),
                        dateRequestAccept: DateTime.now(),
                      ),
                    );
                    if (!mounted) return;
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
