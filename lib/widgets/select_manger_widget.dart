import 'package:flutter/material.dart';
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

    return Row(
      children: <Widget>[
        const Text('المدير'),
        const SizedBox(width: 12),
        Expanded(
          child: FutureBuilder<List<CustomUser>>(
            future: authProvider.managers,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                final managers = snapshot.data!;
                if (managers.isEmpty) {
                  return const Center(
                    child: Text('لا يوجد مدراء'),
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
        ),
      ],
    );
  }
}
