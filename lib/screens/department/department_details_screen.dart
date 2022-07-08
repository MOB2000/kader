import 'package:flutter/material.dart';
import 'package:kader/models/custom_user.dart';
import 'package:kader/models/department.dart';
import 'package:kader/providers/departments_provider.dart';
import 'package:kader/services/helpers.dart';
import 'package:kader/widgets/loading_widget.dart';
import 'package:kader/widgets/select_manger_widget.dart';
import 'package:provider/provider.dart';

class DepartmentDetailsScreen extends StatefulWidget {
  static const String routeName = 'DepartmentDetails';

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

  getDepartmentEmployees(DepartmentsProvider departmentsProvider) async {
    if (firstTime) {
      firstTime = false;
      departmentEmployees =
          await departmentsProvider.getDepartmentEmployees(widget.department);
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final departmentsProvider = Provider.of<DepartmentsProvider>(context);
    getDepartmentEmployees(departmentsProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('تفاصيل القسم'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: <Widget>[
            SelectManagerWidget(
              value: widget.manager,
              onChanged: (newManager) async {
                widget.department.managerId = newManager.id;

                showDialogWaiting(
                  context,
                  () async {
                    await departmentsProvider
                        .updateDepartment(widget.department);
                  },
                );
              },
            ),
            const Text('الموظفين'),
            Expanded(
              child: FutureBuilder<List<CustomUser>>(
                  future: departmentsProvider
                      .getDepartmentEmployees(widget.department),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      final employees = snapshot.data!;
                      if (employees.isEmpty) {
                        return const Center(
                          child: Text('لا يوجد موظفين داخل القسم'),
                        );
                      }
                      return ListView.builder(
                        itemCount: employees.length,
                        itemBuilder: (context, index) {
                          final employee = employees[index];
                          return ListTile(
                            title: Text(employee.name),
                            trailing: TextButton(
                              child: const Text('تفاصيل'),
                              onPressed: () async {},
                            ),
                          );
                        },
                      );
                    }
                    return const LoadingWidget();
                  }),
            ),
            TextButton(
              child: const Text('إضافة/إزالة موظفين'),
              onPressed: () async {
                final allEmployees = await departmentsProvider.employees;
                final employeesToAdd = await departmentsProvider
                    .getDepartmentEmployees(widget.department);
                final add = await showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (context) {
                    return AlertDialog(
                      content: ListView.builder(
                        itemCount: allEmployees.length,
                        itemBuilder: (context, index) {
                          final employee = allEmployees[index];
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
                              child: const Text('تم'),
                              onPressed: () {
                                Navigator.of(context).pop(true);
                              },
                            ),
                            TextButton(
                              child: const Text('إلغاء'),
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
                  await departmentsProvider.addEmployeesToDepartments(
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
