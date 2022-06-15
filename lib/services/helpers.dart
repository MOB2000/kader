import 'package:flutter/material.dart';

import '../widgets/loading_widget.dart';

Future<void> showDialogWaiting(BuildContext context, Function function) async {
  showDialog(
    context: context,
    builder: (context) => const LoadingWidget(),
  );

  await function();

  Navigator.of(context).pop();
}
