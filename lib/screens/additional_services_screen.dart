import 'package:flutter/material.dart';
import 'package:kader/localization/language/languages.dart';

class AdditionalServicesScreen extends StatelessWidget {
  static const String routeName = 'AdditionalServicesScreen';

  const AdditionalServicesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final languages = Languages.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(languages.additionalServices),
      ),
      body: Center(child: Text(languages.additionalServices)),
    );
  }
}
