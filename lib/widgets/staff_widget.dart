import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:kader/localization/language/languages.dart';
import 'package:kader/models/custom_user.dart';
import 'package:kader/models/user_type.dart';
import 'package:kader/providers/auth_provider.dart';
import 'package:kader/providers/departments_provider.dart';
import 'package:kader/services/strings_helper.dart';
import 'package:provider/provider.dart';

class StaffWidget extends StatelessWidget {
  final CustomUser staff;

  const StaffWidget({Key? key, required this.staff}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AuthProvider>(context);
    final departmentsProvider = Provider.of<DepartmentsProvider>(context);
    final languages = Languages.of(context);

    return ListTile(
      title: Text(staff.name),
      subtitle: Text(StringsHelper.translateUserType(staff.type, languages)),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          if (staff.isEmployee)
            TextButton(
              child: Text(languages.promotion),
              onPressed: () async {
                staff.type = UserType.manager;
                await provider.updateUser(staff);
              },
            ),
          if (staff.isManager)
            TextButton(
              child: Text(languages.downgrade),
              onPressed: () async {
                final isHaveDepartment =
                    await departmentsProvider.checkManagerHasDepartment(staff);
                if (isHaveDepartment) {
                  await Fluttertoast.showToast(
                    msg: languages.managerMustRemovedFromDepartment,
                  );
                  return;
                }
                staff.type = UserType.employee;
                await provider.updateUser(staff);
              },
            ),
        ],
      ),
    );
  }
}
