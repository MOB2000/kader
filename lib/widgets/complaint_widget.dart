import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kader/localization/language/languages.dart';
import 'package:kader/models/complaint.dart';
import 'package:kader/screens/complaints/complaint_details_screen.dart';
import 'package:kader/services/shared_preferences_helper.dart';

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
    final user = SharedPreferencesHelper.instance.account;

    final languages = Languages.of(context);

    return user.isAdmin
        ? GestureDetector(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color: Colors.blueGrey[100],
              ),
              margin:
                  const EdgeInsets.only(top: 20, right: 8, left: 8, bottom: 5),
              padding: const EdgeInsets.all(15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${languages.address} : ${widget.complaint.title}",
                    style: const TextStyle(
                        fontSize: 17, fontWeight: FontWeight.bold),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Container(
                    padding:
                        const EdgeInsets.only(right: 1, top: 10, bottom: 10),
                    width: 300,
                    child: Text(
                      widget.complaint.body,
                      style: const TextStyle(fontSize: 20),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ),
                  Text(
                    widget.complaint.showOwner
                        ? "${languages.sender} : ${widget.complaint.ownerName}"
                        : languages.userUnknown,
                    style: const TextStyle(
                      fontSize: 20,
                      color: Colors.blueAccent,
                    ),
                  ),
                  Text(widget.complaint.hasReply ? 'تم الرد' : 'لم يتم الرد')
                ],
              ),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) =>
                      ComplaintDetailsScreen(complaint: widget.complaint),
                ),
              );
            },
          )
        : Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              color: Colors.white,
            ),
            margin:
                const EdgeInsets.only(top: 20, right: 10, left: 10, bottom: 5),
            padding: const EdgeInsets.all(15),
            child: Row(
              children: [
                Expanded(
                  flex: 7,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${languages.address} : ${widget.complaint.title}",
                        style: const TextStyle(
                            fontSize: 17, fontWeight: FontWeight.bold),
                        overflow: TextOverflow.ellipsis,
                      ),
                      Container(
                        padding: const EdgeInsets.only(
                            right: 1, top: 10, bottom: 10),
                        child: Text(
                          widget.complaint.body,
                          style: const TextStyle(fontSize: 12),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ),
                      Text(
                        DateFormat('yyyy-MM-dd')
                            .format(widget.complaint.dateTime),
                        style: const TextStyle(
                            fontSize: 20, color: Colors.blueAccent),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                Expanded(
                  flex: 3,
                  child: Column(
                    children: [
                      if (widget.complaint.hasReply)
                        Container(
                            padding: const EdgeInsets.all(6),
                            color: Colors.lightGreen,
                            child: Text(
                              languages.answered,
                              style: const TextStyle(
                                  fontSize: 18, color: Colors.white),
                            )),
                      if (!widget.complaint.hasReply)
                        Container(
                            padding: const EdgeInsets.all(6),
                            color: Colors.red,
                            child: Text(
                              languages.notReply,
                              style: const TextStyle(
                                  fontSize: 18, color: Colors.white),
                            )),
                      if (widget.complaint.hasReply)
                        TextButton(
                          child: Text(
                            languages.viewReply,
                            style: const TextStyle(
                              fontSize: 18,
                            ),
                          ),
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        ComplaintDetailsScreen(
                                            complaint: widget.complaint)));
                          },
                        ),
                    ],
                  ),
                ),
              ],
            ),
          );
  }
}
