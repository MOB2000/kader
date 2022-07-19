import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:kader/constants/keys.dart';
import 'package:kader/localization/language/languages.dart';
import 'package:kader/models/vacation_request.dart';
import 'package:kader/providers/auth_provider.dart';
import 'package:kader/providers/vacations_provider.dart';
import 'package:kader/services/helpers.dart';
import 'package:kader/services/strings_helper.dart';
import 'package:provider/provider.dart';

class VacationRequestScreen extends StatefulWidget {
  static const String routeName = 'VacationRequestScreen';

  const VacationRequestScreen({Key? key}) : super(key: key);

  @override
  State<VacationRequestScreen> createState() => _VacationRequestScreenState();
}

class _VacationRequestScreenState extends State<VacationRequestScreen> {
  final _vacationRequestFormKey = GlobalKey<FormState>();

  String cause = '';

  DateTimeRange dateTimeFullRange = DateTimeRange(
    start: DateTime.now(),
    end: DateTime.now().add(const Duration(days: 40)),
  );
  DateTimeRange dateTimeRange = DateTimeRange(
    start: DateTime.now(),
    end: DateTime.now().add(
      const Duration(days: 2),
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
                        initialDateRange: dateTimeRange,
                        firstDate: dateTimeFullRange.start,
                        lastDate: dateTimeFullRange.end,
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
                onSaved: (value) => cause = value!.trim(),
                decoration: InputDecoration(
                  labelText: languages.cause,
                ),
              ),
              const SizedBox(height: 24),
              Center(
                child: TextButton(
                  child: Text(languages.sendRequest),
                  onPressed: () async {
                    if (_vacationRequestFormKey.currentState!.validate()) {
                      _vacationRequestFormKey.currentState!.save();

                      final departmentId = await FirebaseFirestore.instance
                          .collection(Keys.employeesDepartments)
                          .where(Keys.employeeId, isEqualTo: user.id)
                          .get()
                          .then((value) =>
                              value.docs.first.data()[Keys.departmentId]);

                      final vacationsBalance = await FirebaseFirestore.instance
                          .collection(Keys.vacationsBalance)
                          .where(Keys.userId, isEqualTo: user.id)
                          .get()
                          .then((value) async {
                        return value.docs.first.data()[Keys.balance];
                      });

                      if (dateTimeRange.duration.inDays > vacationsBalance) {
                        Fluttertoast.showToast(
                          msg: languages.youDoNotHaveVacationsBalance,
                        );
                        return;
                      }
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
            ],
          ),
        ),
      ),
    );
  }
}
