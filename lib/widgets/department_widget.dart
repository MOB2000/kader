import 'package:flutter/material.dart';
import 'package:kader/localization/language/languages.dart';
import 'package:kader/providers/departments_provider.dart';
import 'package:kader/screens/department/department_details_screen.dart';
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
    final languages = Languages.of(context);

    final provider = Provider.of<DepartmentsProvider>(context);
    return ListTile(
      title: Text(department.name),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          TextButton(
            child: Text(languages.details),
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
            onPressed: () async {
              final confirmDelete = await showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text(languages.areYouSure),
                  actions: [
                    TextButton(
                      child: Text(languages.yes),
                      onPressed: () async {
                        Navigator.of(context).pop(true);
                      },
                    ),
                    TextButton(
                      child: Text(languages.no),
                      onPressed: () {
                        Navigator.of(context).pop(false);
                      },
                    ),
                  ],
                ),
              );
              if (confirmDelete) {
                await provider.deleteDepartment(department);
              }
            },
          ),
        ],
      ),
    );
  }
}
