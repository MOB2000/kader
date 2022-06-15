import 'package:flutter/material.dart';
import 'package:kader/localization/language/languages.dart';

class ShiftsScreen extends StatelessWidget {
  static const String routeName = 'ShiftsScreen';

  const ShiftsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final languages = Languages.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(languages.shifts),
      ),
      body: Center(child: Text(languages.shifts)),
    );
  }
}
