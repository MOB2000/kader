import 'package:flutter/material.dart';
import 'package:kader/models/complaint.dart';
import 'package:kader/services/strings_helper.dart';

class ComplaintWidget extends StatefulWidget {
  final Complaint complaint;

  const ComplaintWidget({
    Key? key,
    required this.complaint,
  }) : super(key: key);

  @override
  State<ComplaintWidget> createState() => _ComplaintWidgetState();
}

class _ComplaintWidgetState extends State<ComplaintWidget> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(widget.complaint.title),
      subtitle: Text(StringsHelper.getDayDate(widget.complaint.dateTime)),
    );
  }
}
