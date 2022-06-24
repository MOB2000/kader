import 'package:flutter/material.dart';
import 'package:kader/providers/departments_provider.dart';
import 'package:kader/screens/department_details_screen.dart';
import 'package:provider/provider.dart';

import '../models/department.dart';

class DepartmentWidget extends StatelessWidget {
  final Department department;

  const DepartmentWidget({
    Key? key,
    required this.department,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<DepartmentsProvider>(context);
    return ListTile(
      title: Text(department.name),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          TextButton(
            child: const Text('تفاصيل'),
            onPressed: () async {
              final manager = await provider.getDepartmentManager(department);

              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => DepartmentDetailsScreen(
                    department: department,
                    manager: manager,
                  ),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(
              Icons.delete_forever,
              color: Colors.red,
            ),
            onPressed: () {
              //TODO: show confirm delete dialog
              provider.deleteDepartment(department);
            },
          ),
        ],
      ),
    );
  }
}
