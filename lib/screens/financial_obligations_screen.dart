import 'package:flutter/material.dart';
import 'package:kader/localization/language/languages.dart';

class FinancialObligationsScreen extends StatelessWidget {
  static const String routeName = 'FinancialObligationsScreen';

  const FinancialObligationsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final languages = Languages.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(languages.financialObligations),
      ),
      body: Center(child: Text(languages.financialObligations)),
    );
  }
}
