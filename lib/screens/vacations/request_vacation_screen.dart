import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:kader/constants/keys.dart';
import 'package:kader/localization/language/languages.dart';
import 'package:kader/models/vacation_request.dart';
import 'package:kader/providers/auth_provider.dart';
import 'package:kader/providers/vacations_provider.dart';
import 'package:kader/services/helpers.dart';
import 'package:kader/services/strings_helper.dart';
import 'package:provider/provider.dart';

class RequestVacationScreen extends StatefulWidget {
  static const String routeName = 'RequestVacationScreen';

  const RequestVacationScreen({Key? key}) : super(key: key);

  @override
  State<RequestVacationScreen> createState() => _RequestVacationScreenState();
}

class _RequestVacationScreenState extends State<RequestVacationScreen> {
  final _vacationRequestFormKey = GlobalKey<FormState>();

  String cause = '';
  DateTimeRange dateTimeRange = DateTimeRange(
    start: DateTime.now(),
    end: DateTime.now().add(
      const Duration(days: 100),
    ),
  );
  final initialDateTimeRange = DateTimeRange(
    start: DateTime.now(),
    end: DateTime.now().add(
      const Duration(days: 1),
    ),
  );

  @override
  Widget build(BuildContext context) {
    final languages = Languages.of(context);
    final user = Provider.of<AuthProvider>(context).user;
    final vacationsProvider = Provider.of<VacationsProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(languages.requestVacation),
      ),
      body: Form(
        key: _vacationRequestFormKey,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(languages.duration),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  const SizedBox(width: 12),
                  Text(StringsHelper.getDate(dateTimeRange.start)),
                  const SizedBox(width: 12),
                  Text(StringsHelper.getDate(dateTimeRange.end)),
                  const SizedBox(width: 12),
                  TextButton(
                    child: Text(languages.pickDuration),
                    onPressed: () async {
                      final pickedDate = await showDateRangePicker(
                        context: context,
                        initialDateRange: initialDateTimeRange,
                        firstDate: dateTimeRange.start,
                        lastDate: dateTimeRange.end,
                      );

                      if (pickedDate != null) {
                        setState(() {
                          dateTimeRange = pickedDate;
                        });
                      }
                    },
                  ),
                ],
              ),
              TextFormField(
                validator: (value) => checkEmpty(value, languages.enterValue),
                onSaved: (value) {
                  value = value!.trim();
                  cause = value;
                },
                decoration: InputDecoration(
                  labelText: languages.cause,
                ),
              ),
              const Spacer(),
              Center(
                child: TextButton(
                  child: Text(languages.sendRequest),
                  onPressed: () async {
                    if (_vacationRequestFormKey.currentState!.validate()) {
                      _vacationRequestFormKey.currentState!.save();

                      final departmentId = await FirebaseFirestore.instance
                          .collection(Keys.employeesDepartments)
                          .where(Keys.empId, isEqualTo: user.id)
                          .get()
                          .then((value) =>
                              value.docs.first.data()[Keys.department_id]);

                      final vacationRequest = VacationRequest(
                        departmentId: departmentId,
                        employeeId: user.id,
                        employeeName: user.name,
                        dateTimeRange: dateTimeRange,
                        cause: cause,
                      );

                      await vacationsProvider
                          .addVacationRequest(vacationRequest);

                      if (!mounted) return;
                      Navigator.of(context).pop();
                    }
                  },
                ),
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
