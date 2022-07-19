import 'package:flutter/material.dart';
import 'package:kader/localization/language/languages.dart';
import 'package:kader/models/custom_user.dart';
import 'package:kader/models/department.dart';
import 'package:kader/providers/departments_provider.dart';
import 'package:kader/widgets/loading_widget.dart';
import 'package:kader/widgets/select_manger_widget.dart';
import 'package:provider/provider.dart';

class DepartmentDetailsScreen extends StatefulWidget {
  static const String routeName = 'DepartmentDetailsScreen';

  final Department department;
  final CustomUser manager;

  const DepartmentDetailsScreen({
    Key? key,
    required this.department,
    required this.manager,
  }) : super(key: key);

  @override
  State<DepartmentDetailsScreen> createState() =>
      _DepartmentDetailsScreenState();
}

class _DepartmentDetailsScreenState extends State<DepartmentDetailsScreen> {
  List<CustomUser> departmentEmployees = <CustomUser>[];

  bool firstTime = true;

  Future<void> getDepartmentEmployees(
      DepartmentsProvider departmentsProvider) async {
    if (firstTime) {
      firstTime = false;
      departmentEmployees =
          await departmentsProvider.getDepartmentEmployees(widget.department);
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final languages = Languages.of(context);

    final departmentsProvider = Provider.of<DepartmentsProvider>(context);
    getDepartmentEmployees(departmentsProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(languages.departmentDetails),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: <Widget>[
            SelectManagerWidget(
              value: widget.manager,
              onChanged: (newManager) async {
                widget.department.managerId = newManager.id;

                await departmentsProvider.updateDepartment(widget.department);
              },
            ),
            Text(languages.employees),
            Expanded(
              child: FutureBuilder<List<CustomUser>>(
                  future: departmentsProvider
                      .getDepartmentEmployees(widget.department),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      final employees = snapshot.data!;
                      if (employees.isEmpty) {
                        return Center(
                          child: Text(languages.noEmployeesInTheDepartment),
                        );
                      }
                      return ListView.builder(
                        itemCount: employees.length,
                        itemBuilder: (context, index) {
                          final employee = employees[index];
                          return ListTile(
                            title: Text(employee.name),
                          );
                        },
                      );
                    }
                    return const LoadingWidget();
                  }),
            ),
            TextButton(
              child: Text(languages.addRemoveEmployees),
              onPressed: () async {
                final employeesWithoutDepartment = await departmentsProvider
                    .getEmployeesWithoutDepartment(widget.department);

                final employeesToAdd = await departmentsProvider
                    .getDepartmentEmployees(widget.department);
                employeesWithoutDepartment.addAll(employeesToAdd);

                final add = await showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (context) {
                    return AlertDialog(
                      content: ListView.builder(
                        itemCount: employeesWithoutDepartment.length,
                        itemBuilder: (context, index) {
                          final employee = employeesWithoutDepartment[index];
                          return StatefulBuilder(
                            builder: (context, setState) {
                              return CheckboxListTile(
                                title: Text(employee.name),
                                value: employeesToAdd.contains(employee),
                                onChanged: (value) {
                                  if (value!) {
                                    employeesToAdd.add(employee);
                                  } else {
                                    employeesToAdd.remove(employee);
                                  }
                                  setState(() {});
                                },
                              );
                            },
                          );
                        },
                      ),
                      actions: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            TextButton(
                              child: Text(languages.done),
                              onPressed: () {
                                Navigator.of(context).pop(true);
                              },
                            ),
                            TextButton(
                              child: Text(languages.cancel),
                              onPressed: () {
                                Navigator.of(context).pop(false);
                              },
                            ),
                          ],
                        ),
                      ],
                    );
                  },
                );
                if (add) {
                  await departmentsProvider.addEmployeesToDepartment(
                      employeesToAdd, widget.department);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
