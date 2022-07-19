import 'package:flutter/material.dart';
import 'package:kader/localization/language/languages.dart';
import 'package:kader/models/complaint.dart';
import 'package:kader/providers/complaints_provider.dart';
import 'package:kader/screens/complaints/add_complaint_screen.dart';
import 'package:kader/services/shared_preferences_helper.dart';
import 'package:kader/widgets/complaint_widget.dart';
import 'package:kader/widgets/loading_widget.dart';
import 'package:provider/provider.dart';

class ComplaintsScreen extends StatelessWidget {
  static const String routeName = 'ComplaintsScreen';

  const ComplaintsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final languages = Languages.of(context);
    final complaintsProvider = Provider.of<ComplaintsProvider>(context);
    final user = SharedPreferencesHelper.instance.account;

    return Scaffold(
      appBar: AppBar(
        title: Text(languages.complaints),
      ),
      body: FutureBuilder<List<Complaint>>(
        future: user.isAdmin
            ? complaintsProvider.complaints
            : complaintsProvider.getComplaints(user.id),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            final complaints = snapshot.data!;

            return ListView.builder(
              itemCount: complaints.length,
              itemBuilder: (context, index) =>
                  ComplaintWidget(complaint: complaints[index]),
            );
          }

          return const LoadingWidget();
        },
      ),
      floatingActionButton: user.isAdmin
          ? null
          : FloatingActionButton(
              child: const Icon(Icons.add),
              onPressed: () {
                Navigator.of(context).pushNamed(AddComplaintsScreen.routeName);
              },
            ),
    );
  }
}
