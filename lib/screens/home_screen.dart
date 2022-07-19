import 'package:flutter/material.dart';
import 'package:kader/constants/images.dart';
import 'package:kader/localization/language/languages.dart';
import 'package:kader/providers/auth_provider.dart';
import 'package:kader/screens/attendance/attendance_screen.dart';
import 'package:kader/screens/complaints/complaints_screen.dart';
import 'package:kader/screens/custody/custody_screen.dart';
import 'package:kader/screens/department/departments_screen.dart';
import 'package:kader/screens/meetings/meetings_screen.dart';
import 'package:kader/screens/staff_management_screen.dart';
import 'package:kader/screens/vacations/vacations_screen.dart';
import 'package:kader/widgets/custom_drawer.dart';
import 'package:kader/widgets/service_widget.dart';
import 'package:kader/widgets/services_widget.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  static const String routeName = 'HomeScreen';

  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final languages = Languages.of(context);
    final user = Provider.of<AuthProvider>(context).user;

    return Scaffold(
      appBar: AppBar(
        title: Text(languages.home),
      ),
      drawer: const CustomDrawer(),
      body: ServicesWidget(
        children: <ServiceWidget>[
          if (user.isAdmin) ...[
            ServiceWidget(
              name: languages.manageDepartments,
              image: Images.eVacation,
              routeName: DepartmentsScreen.routeName,
            ),
            if (user.isAdmin)
              ServiceWidget(
                name: languages.manageStaff,
                image: Images.eVacation,
                routeName: StaffManagementScreen.routeName,
              ),
          ],
          ServiceWidget(
            name: languages.custody,
            image: Images.custodyImage,
            routeName: CustodyScreen.routeName,
          ),
          if (!user.isAdmin) ...[
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
              name: languages.meetings,
              image: Images.eVacation,
              routeName: MeetingsScreen.routeName,
            ),
          ],
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
