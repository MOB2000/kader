import 'package:flutter/material.dart';
import 'package:kader/localization/language/languages.dart';

class VacationsBalanceScreen extends StatelessWidget {
  static const String routeName = 'VacationsBalanceScreen';

  const VacationsBalanceScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final languages = Languages.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(languages.vacationsBalance),
      ),
      body: Center(child: Text(languages.vacationsBalance)),
    );
  }
}
