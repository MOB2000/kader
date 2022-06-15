import 'package:flutter/material.dart';
import 'package:kader/constants/colors.dart';
import 'package:kader/localization/language/languages.dart';
import 'package:kader/services/strings_helper.dart';

class VacationRequestScreen extends StatefulWidget {
  static const String routeName = 'VacationRequestScreen';

  const VacationRequestScreen({Key? key}) : super(key: key);

  @override
  State<VacationRequestScreen> createState() => _VacationRequestScreenState();
}

class _VacationRequestScreenState extends State<VacationRequestScreen> {
  int vacationLength = 0;
  DateTime startDate = DateTime.now();

  DateTime get endDate => startDate.add(Duration(days: vacationLength));

  final vacationFormKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final languages = Languages.of(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(title: Text(languages.vacationRequest)),
      body: Form(
        key: vacationFormKey,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: <Widget>[
              TextFormField(
                decoration: InputDecoration(
                  labelText: languages.enterVacationDaysNumber,
                ),
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.done,
                onChanged: (value) {
                  setState(() {
                    vacationLength = int.tryParse(value) ?? 0;
                  });
                },
                validator: (value) {
                  value = value!.trim();
                  if (value.isEmpty) {
                    return languages.enterVacationDaysNumber;
                  }
                  final intValue = int.tryParse(value);
                  if (intValue == null) {
                    return languages.digitsOnlyAllowed;
                  }

                  return null;
                },
                onSaved: (value) => vacationLength = int.parse(value!.trim()),
              ),
              const SizedBox(height: 18),
              GestureDetector(
                onTap: () async {
                  final selectedDate = await showDatePicker(
                      context: context,
                      currentDate: DateTime.now(),
                      initialDate: DateTime.now(),
                      firstDate: DateTime.now(),
                      lastDate: DateTime(2222),
                      builder: (context, child) {
                        return Theme(
                          data: Theme.of(context).copyWith(
                            colorScheme: const ColorScheme.light(
                              primary: kMainColor,
                              onPrimary: Colors.white,
                            ),
                            textButtonTheme: TextButtonThemeData(
                              style: TextButton.styleFrom(
                                primary: kMainColor,
                              ),
                            ),
                          ),
                          child: child!,
                        );
                      });
                  setState(() {
                    startDate = selectedDate ?? startDate;
                  });
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    const Icon(Icons.calendar_today),
                    const SizedBox(width: 8),
                    Text(languages.startDate),
                    const SizedBox(width: 4),
                    Text(StringsHelper.getDayDate(startDate)),
                  ],
                ),
              ),
              const SizedBox(height: 18),
              if (vacationLength > 0)
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    const Icon(Icons.calendar_today),
                    const SizedBox(width: 8),
                    Text(languages.returnDate),
                    const SizedBox(width: 4),
                    Text(StringsHelper.getDayDate(endDate)),
                  ],
                ),
              const SizedBox(height: 48),
              ElevatedButton(
                onPressed: () async {
                  if (vacationFormKey.currentState!.validate()) {
                    vacationFormKey.currentState!.save();

                    setState(() {});
                  }
                },
                style: ElevatedButton.styleFrom(
                  primary: kMainColor,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.zero,
                    side: BorderSide(color: kMainColor),
                  ),
                ),
                child: Text(
                  languages.requestVacation,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(
          Icons.ac_unit,
          color: Colors.white,
        ),
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text(languages.vacationsBalance),
              actions: <Widget>[
                TextButton(
                  child: Text(languages.close),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
