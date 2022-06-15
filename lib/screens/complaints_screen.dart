import 'package:flutter/material.dart';
import 'package:kader/localization/language/languages.dart';
import 'package:kader/models/complaint.dart';
import 'package:kader/providers/services_provider.dart';
import 'package:kader/widgets/complaint_widget.dart';
import 'package:provider/provider.dart';

class ComplaintsScreen extends StatelessWidget {
  static const String routeName = 'ComplaintsScreen';

  const ComplaintsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final languages = Languages.of(context);
    final servicesProvider = Provider.of<ServicesProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(languages.complaints),
      ),
      body: Column(
        children: <Widget>[
          Center(child: Text(languages.complaints)),
          Expanded(
            child: FutureBuilder<List<Complaint>>(
              future: servicesProvider.complaints,
              builder: (context, snapshot) {
                final complaints = snapshot.data!;
                return ListView.builder(
                  itemCount: complaints.length,
                  itemBuilder: (context, index) =>
                      ComplaintWidget(complaint: complaints[index]),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
