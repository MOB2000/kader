import 'package:flutter/material.dart';
import 'package:kader/localization/language/languages.dart';

class CustodyScreen extends StatelessWidget {
  static const String routeName = 'CustodyScreen';

  const CustodyScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final languages = Languages.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(languages.custody),
      ),
      body: Center(child: Text(languages.custody)),
    );
  }
}
