import 'package:flutter/material.dart';
import 'package:kader/localization/language/languages.dart';

class WorkInformationScreen extends StatelessWidget {
  static const String routeName = 'WorkInformationScreen';

  const WorkInformationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final languages = Languages.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(languages.workInformation),
      ),
      body: Center(child: Text(languages.workInformation)),
    );
  }
}
