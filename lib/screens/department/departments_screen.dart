import 'package:flutter/material.dart';
import 'package:kader/localization/language/languages.dart';
import 'package:kader/models/department.dart';
import 'package:kader/providers/departments_provider.dart';
import 'package:kader/screens/department/create_department_screen.dart';
import 'package:kader/widgets/department_widget.dart';
import 'package:kader/widgets/loading_widget.dart';
import 'package:provider/provider.dart';

class DepartmentsScreen extends StatelessWidget {
  static const String routeName = 'DepartmentsScreen';

  const DepartmentsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final languages = Languages.of(context);
    final departmentsProvider = Provider.of<DepartmentsProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(languages.departments),
      ),
      body: FutureBuilder<List<Department>>(
        future: departmentsProvider.departments,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            final departments = snapshot.data!;
            if (departments.isEmpty) {
              return Center(child: Text(languages.noData));
            }

            return ListView.builder(
              itemCount: departments.length,
              itemBuilder: (context, index) => DepartmentWidget(
                department: departments[index],
              ),
            );
          }
          return const LoadingWidget();
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.of(context).pushNamed(CreateDepartmentScreen.routeName);
        },
      ),
    );
  }
}
