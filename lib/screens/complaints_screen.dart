import 'package:flutter/material.dart';
import 'package:kader/localization/language/languages.dart';

class ComplaintsScreen extends StatelessWidget {
  static const String routeName = 'ComplaintsScreen';

  const ComplaintsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final languages = Languages.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(languages.complaints),
      ),
      body: Center(child: Text(languages.complaints)),
    );
  }
}
