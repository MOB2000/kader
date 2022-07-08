import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:kader/localization/language/languages.dart';
import 'package:kader/models/custom_user.dart';
import 'package:kader/providers/departments_provider.dart';
import 'package:kader/services/helpers.dart';
import 'package:kader/widgets/select_manger_widget.dart';
import 'package:provider/provider.dart';

class CreateDepartmentScreen extends StatefulWidget {
  static const String routeName = 'CreateDepartmentScreen';

  const CreateDepartmentScreen({Key? key}) : super(key: key);

  @override
  State<CreateDepartmentScreen> createState() => _CreateDepartmentScreenState();
}

class _CreateDepartmentScreenState extends State<CreateDepartmentScreen> {
  final _createDepartmentFormKey = GlobalKey<FormState>();

  String name = '';
  CustomUser? manager;

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<DepartmentsProvider>(context);
    final languages = Languages.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(languages.createDepartment),
      ),
      body: Form(
        key: _createDepartmentFormKey,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: <Widget>[
              const SizedBox(height: 12),
              SelectManagerWidget(
                onChanged: (newManager) {
                  manager = newManager;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                validator: (value) {
                  checkEmpty(value, languages.enterValue);
                  return null;
                },
                onSaved: (value) {
                  name = value!.trim();
                },
                decoration: InputDecoration(
                  labelText: languages.departmentName,
                ),
              ),
              const SizedBox(height: 12),
              TextButton(
                child: Text(languages.create),
                onPressed: () async {
                  if (_createDepartmentFormKey.currentState!.validate()) {
                    _createDepartmentFormKey.currentState!.save();
                    if (manager == null) {
                      Fluttertoast.showToast(msg: languages.mustChooseManager);
                      return;
                    }
                    await provider.createDepartment(
                      name,
                      manager!.id,
                    );
                    if (!mounted) return;
                    Navigator.of(context).pop();
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
