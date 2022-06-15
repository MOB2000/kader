import 'package:flutter/material.dart';
import 'package:kader/localization/language/languages.dart';

class ProtocolsScreen extends StatelessWidget {
  static const String routeName = 'ProtocolsScreen';

  const ProtocolsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final languages = Languages.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(languages.protocols),
      ),
      body: Center(child: Text(languages.protocols)),
    );
  }
}
