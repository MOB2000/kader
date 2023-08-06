import 'package:flutter/material.dart';
import 'package:kader/localization/language/languages.dart';
import 'package:kader/models/complaint.dart';
import 'package:kader/providers/complaints_provider.dart';
import 'package:kader/services/helpers.dart';
import 'package:kader/services/shared_preferences_helper.dart';
import 'package:kader/services/strings_helper.dart';
import 'package:provider/provider.dart';

class ComplaintDetailsScreen extends StatefulWidget {
  final Complaint complaint;

  const ComplaintDetailsScreen({
    Key? key,
    required this.complaint,
  }) : super(key: key);

  @override
  State<ComplaintDetailsScreen> createState() => _ComplaintDetailsScreenState();
}

class _ComplaintDetailsScreenState extends State<ComplaintDetailsScreen> {
  final controller = TextEditingController();

  Future openDialog(
    BuildContext context,
    Languages languages,
  ) async {
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(languages.message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            },
            child: Text(languages.ok),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final languages = Languages.of(context);
    final servicesProvider = Provider.of<ComplaintsProvider>(context);
    final user = SharedPreferencesHelper.instance.account;

    return Scaffold(
      appBar: AppBar(
        title: Text(languages.complaintDetails),
      ),
      body: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          margin: const EdgeInsets.only(top: 15, right: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(15),
                child: Text(
                  languages.titleComplaints,
                  style: const TextStyle(
                      fontSize: 22, fontWeight: FontWeight.bold),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(5),
                margin: const EdgeInsets.only(right: 10, left: 15),
                width: double.infinity,
                color: Colors.blueGrey,
                child: Text(
                  widget.complaint.title,
                  style: const TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(15),
                child: Text(
                  languages.sendingDate,
                  style: const TextStyle(
                      fontSize: 22, fontWeight: FontWeight.bold),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(5),
                margin: const EdgeInsets.only(right: 10, left: 15),
                width: double.infinity,
                color: Colors.blueGrey,
                child: Text(
                  StringsHelper.getDate(widget.complaint.dateTime),
                  style: const TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
              if (widget.complaint.showOwner) ...[
                Container(
                  padding: const EdgeInsets.all(15),
                  child: Text(
                    languages.sender,
                    style: const TextStyle(
                        fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(5),
                  margin: const EdgeInsets.only(right: 10, left: 15),
                  width: double.infinity,
                  color: Colors.blueGrey,
                  child: Text(
                    widget.complaint.showOwner
                        ? widget.complaint.ownerName
                        : languages.userUnknown,
                    style: const TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
              ],
              Container(
                padding: const EdgeInsets.all(15),
                child: Text(
                  languages.contentComplaints,
                  style: const TextStyle(
                      fontSize: 22, fontWeight: FontWeight.bold),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(5),
                margin: const EdgeInsets.only(right: 10, left: 15),
                width: double.infinity,
                height: 120,
                color: Colors.blueGrey,
                child: Text(
                  widget.complaint.body,
                  style: const TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(15),
                child: Text(
                  languages.reply,
                  style: const TextStyle(
                      fontSize: 22, fontWeight: FontWeight.bold),
                ),
              ),
              if (user.isAdmin)
                TextFormField(
                  enabled: !widget.complaint.hasReply,
                  controller: controller,
                  decoration: InputDecoration(
                    labelText: widget.complaint.reply,
                    alignLabelWithHint: true,
                  ),
                  validator: (value) => checkEmpty(value, languages.enterValue),
                  onSaved: (value) {
                    value = value!.trim();
                  },
                  minLines: 8,
                  maxLines: 15,
                ),
              if (!user.isAdmin)
                if (widget.complaint.hasReply)
                  Container(
                    padding: const EdgeInsets.all(5),
                    margin: const EdgeInsets.only(right: 10, left: 15),
                    width: double.infinity,
                    color: Colors.blueGrey,
                    child: Text(
                      widget.complaint.reply!,
                      style: const TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                  ),
              if (!user.isAdmin)
                if (!widget.complaint.hasReply)
                  Container(
                    padding: const EdgeInsets.all(5),
                    margin: const EdgeInsets.only(right: 10, left: 15),
                    width: double.infinity,
                    color: Colors.red,
                    child: Text(
                      languages.notReply,
                      style: const TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                  ),
              if (user.isAdmin)
                if (!widget.complaint.hasReply)
                  Container(
                    margin: const EdgeInsets.only(top: 20),
                    alignment: Alignment.center,
                    child: TextButton(
                      child: Text(
                        languages.sendReply,
                        style: const TextStyle(
                          fontSize: 20,
                        ),
                      ),
                      onPressed: () async {
                        widget.complaint.reply = controller.text;
                        servicesProvider.updateComplaints(widget.complaint);
                        await openDialog(context, languages);
                      },
                    ),
                  ),
            ],
          ),
        ),
      ),
    );
  }
}
