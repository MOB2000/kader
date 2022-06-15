import 'package:flutter/material.dart';
import 'package:kader/localization/language/languages.dart';

class DisplayVacationsScreen extends StatelessWidget {
  static const String routeName = 'DisplayVacationsScreen';

  const DisplayVacationsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final languages = Languages.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(languages.kDisplayVacations),
      ),
      body: Center(child: Text(languages.kDisplayVacations)),
    );
  }
}
