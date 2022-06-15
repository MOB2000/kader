import 'package:flutter/material.dart';

Future<void> showDialogWaiting(BuildContext context, Function function) async {
  showDialog(
    context: context,
    builder: (context) => const Center(
      child: SizedBox(
        height: 24,
        width: 24,
        child: CircularProgressIndicator.adaptive(),
      ),
    ),
  );

  await function();

  Navigator.of(context).pop();
}
