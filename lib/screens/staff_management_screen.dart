import 'package:flutter/material.dart';
import 'package:kader/localization/language/languages.dart';
import 'package:kader/models/custom_user.dart';
import 'package:kader/providers/auth_provider.dart';
import 'package:kader/widgets/loading_widget.dart';
import 'package:kader/widgets/staff_widget.dart';
import 'package:provider/provider.dart';

class StaffManagementScreen extends StatelessWidget {
  static const String routeName = 'StaffManagementScreen';

  const StaffManagementScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AuthProvider>(context);
    final languages = Languages.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(languages.staffManagement),
      ),
      body: FutureBuilder<List<CustomUser>>(
        future: provider.staff,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            final staff = snapshot.data!;

            return ListView.builder(
              itemCount: staff.length,
              itemBuilder: (context, index) => StaffWidget(staff: staff[index]),
            );
          }
          return const LoadingWidget();
        },
      ),
    );
  }
}
