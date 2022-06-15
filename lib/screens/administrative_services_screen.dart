import 'package:flutter/material.dart';
import 'package:kader/constants/images.dart';
import 'package:kader/localization/language/languages.dart';
import 'package:kader/screens/e_vacation_screen.dart';
import 'package:kader/screens/shifts_screen_screen.dart';
import 'package:kader/screens/working_hours_screen.dart';
import 'package:kader/widgets/service_widget.dart';
import 'package:kader/widgets/services_widget.dart';

class AdministrativeServicesScreen extends StatelessWidget {
  static const String routeName = 'AdministrativeServicesScreen';

  const AdministrativeServicesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final languages = Languages.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(languages.administrativeServices),
      ),
      body: ServicesWidget(
        children: <ServiceWidget>[
          ServiceWidget(
            name: languages.eVacation,
            image: Images.eVacation,
            routeName: EVacationScreen.routeName,
          ),
          ServiceWidget(
            name: languages.workingHours,
            image: Images.workingHours,
            routeName: WorkingHoursScreen.routeName,
          ),
          ServiceWidget(
            name: languages.shifts,
            image: Images.shifts,
            routeName: ShiftsScreen.routeName,
          ),
        ],
      ),
    );
  }
}
