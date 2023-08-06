import 'package:flutter/material.dart';
import 'package:kader/localization/language/languages.dart';
import 'package:kader/models/custom_user.dart';
import 'package:kader/providers/auth_provider.dart';
import 'package:kader/widgets/loading_widget.dart';
import 'package:provider/provider.dart';

class SelectManagerWidget extends StatefulWidget {
  final CustomUser? value;
  final Function(CustomUser) onChanged;

  const SelectManagerWidget({
    Key? key,
    this.value,
    required this.onChanged,
  }) : super(key: key);

  @override
  State<SelectManagerWidget> createState() => _SelectManagerWidgetState();
}

class _SelectManagerWidgetState extends State<SelectManagerWidget> {
  @override
  void initState() {
    super.initState();
    manager = widget.value;
  }

  CustomUser? manager;

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final languages = Languages.of(context);

    return Row(
      children: <Widget>[
        Text(languages.theManager),
        const SizedBox(width: 32),
        FutureBuilder<List<CustomUser>>(
          future: authProvider.managersWithoutDepartments,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              final managers = snapshot.data!;
              if (widget.value != null) {
                managers.add(widget.value!);
              }
              if (managers.isEmpty) {
                return Center(
                  child: Text(languages.noManagersFound),
                );
              }

              manager = manager ?? managers.first;

              return DropdownButton<CustomUser>(
                value: manager,
                items: managers
                    .map(
                      (e) => DropdownMenuItem<CustomUser>(
                        value: e,
                        child: Text(e.name),
                      ),
                    )
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    manager = value!;
                  });
                  widget.onChanged(manager!);
                },
              );
            }
            return const LoadingWidget();
          },
        ),
      ],
    );
  }
}
