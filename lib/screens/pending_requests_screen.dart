import 'package:flutter/material.dart';
import 'package:kader/localization/language/languages.dart';

class PendingRequestsScreen extends StatelessWidget {
  static const String routeName = 'PendingRequestsScreen';

  const PendingRequestsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final languages = Languages.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(languages.pendingRequests),
      ),
      body: Center(child: Text(languages.pendingRequests)),
    );
  }
}
