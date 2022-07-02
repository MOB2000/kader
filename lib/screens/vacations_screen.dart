import 'package:flutter/material.dart';
import 'package:kader/localization/language/languages.dart';
import 'package:kader/models/user_type.dart';
import 'package:kader/models/vacation_request.dart';
import 'package:kader/providers/auth_provider.dart';
import 'package:kader/providers/departments_provider.dart';
import 'package:kader/providers/vacations_provider.dart';
import 'package:kader/screens/vacations/vacation_request_screen.dart';
import 'package:kader/widgets/loading_widget.dart';
import 'package:kader/widgets/vacation_request_widget.dart';
import 'package:provider/provider.dart';

class VacationsScreen extends StatelessWidget {
  static const String routeName = 'EVacationScreen';

  VacationsScreen({Key? key}) : super(key: key);
  bool isManager = false;

  Future<List<VacationRequest>> getVacations(BuildContext context) async {
    final vacationsProvider = Provider.of<VacationsProvider>(context);

    final user = Provider.of<AuthProvider>(context).user;
    isManager = user.type == UserType.manager ? true : false;

    if (isManager) {
      final departmentId =
          await Provider.of<DepartmentsProvider>(context).getDepartment(user);

      return vacationsProvider.getDepartmentVacations(departmentId);
    }

    return vacationsProvider.getEmployeeVacations(user);
  }

  @override
  Widget build(BuildContext context) {
    final languages = Languages.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(languages.vacations),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: FutureBuilder<List<VacationRequest>>(
              future: getVacations(context),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  final requests = snapshot.data!;

                  return ListView.builder(
                    itemCount: requests.length,
                    itemBuilder: (context, index) => VacationRequestWidget(
                      vacationRequest: requests[index],
                      isManager: isManager,
                    ),
                  );
                }
                return const LoadingWidget();
              },
            ),
          ),
        ],
      ),
      floatingActionButton: isManager
          ? null
          : FloatingActionButton(
              child: const Text(
                'طلب إجازة',
                textAlign: TextAlign.center,
              ),
              onPressed: () {
                Navigator.of(context)
                    .pushNamed(VacationRequestScreen.routeName);
              },
            ),
    );
  }
}
