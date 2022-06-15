import 'package:flutter/material.dart';
import 'package:kader/localization/language/languages.dart';

// TODO: Build and update data
class ProfileScreen extends StatefulWidget {
  static const routeName = 'ProfileScreen';
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    final languages = Languages.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(languages.profile),
      ),
      body: Column(
        children: <Widget>[
          Text(languages.profile),
        ],
      ),
    );
  }
}
