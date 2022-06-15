import 'package:flutter/material.dart';
import 'package:kader/localization/language/languages.dart';

class ReturnScreen extends StatelessWidget {
  static const String routeName = 'ReturnScreen';

  const ReturnScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final languages = Languages.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(languages.returnAcknowledgment),
      ),
      body: Center(child: Text(languages.returnAcknowledgment)),
    );
  }
}
