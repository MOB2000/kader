import 'package:flutter/material.dart';
import 'package:kader/localization/language/languages.dart';
import 'package:kader/providers/complaints_provider.dart';
import 'package:provider/provider.dart';

class ComplaintsScreen extends StatelessWidget {
  static const String routeName = 'ComplaintsScreen';

  const ComplaintsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final languages = Languages.of(context);
    final complaintsProvider = Provider.of<ComplaintsProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(languages.complaints),
      ),
      body: Column(
        children: <Widget>[
          Center(child: Text(languages.complaints)),
        ],
      ),
    );
  }
}
