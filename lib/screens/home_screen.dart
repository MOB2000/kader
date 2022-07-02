import 'package:flutter/material.dart';
import 'package:kader/constants/images.dart';
import 'package:kader/localization/language/languages.dart';
import 'package:kader/screens/attendance_screen.dart';
import 'package:kader/screens/complaints_screen.dart';
import 'package:kader/screens/custody_screen.dart';
import 'package:kader/screens/departments_screen.dart';
import 'package:kader/screens/meetings_screen.dart';
import 'package:kader/screens/vacations_screen.dart';
import 'package:kader/widgets/custom_drawer.dart';
import 'package:kader/widgets/service_widget.dart';
import 'package:kader/widgets/services_widget.dart';

class HomeScreen extends StatelessWidget {
  static const String routeName = 'HomeScreen';

  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final languages = Languages.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(languages.kHome),
      ),
      drawer: const CustomDrawer(),
      body: ServicesWidget(
        children: <ServiceWidget>[
          ServiceWidget(
            name: languages.manageDepartments,
            image: Images.eVacation,
            routeName: DepartmentsScreen.routeName,
          ),
          ServiceWidget(
            name: languages.meetings,
            image: Images.eVacation,
            routeName: MeetingsScreen.routeName,
          ),
          ServiceWidget(
            name: languages.vacations,
            image: Images.eVacation,
            routeName: VacationsScreen.routeName,
          ),
          ServiceWidget(
            name: languages.attendance,
            image: Images.attendance,
            routeName: AttendanceScreen.routeName,
          ),
          ServiceWidget(
            name: languages.custody,
            image: Images.custodyImage,
            routeName: CustodyScreen.routeName,
          ),
          ServiceWidget(
            name: languages.complaints,
            image: Images.complaints,
            routeName: ComplaintsScreen.routeName,
          ),
        ],
      ),
    );
  }
}
