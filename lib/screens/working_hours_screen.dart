import 'package:flutter/material.dart';
import 'package:kader/localization/language/languages.dart';

class WorkingHoursScreen extends StatelessWidget {
  static const String routeName = 'WorkingHoursScreen';

  const WorkingHoursScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final languages = Languages.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(languages.workingHours),
      ),
      body: Center(child: Text(languages.workingHours)),
    );
  }
}
