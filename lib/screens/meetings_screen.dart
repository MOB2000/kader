import 'package:flutter/material.dart';
import 'package:kader/localization/language/languages.dart';

class MeetingsScreen extends StatelessWidget {
  static const String routeName = 'MeetingsScreen';

  const MeetingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final languages = Languages.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(languages.meetings),
      ),
      body: Center(
        child: Text(languages.meetings),
      ),
    );
  }
}
