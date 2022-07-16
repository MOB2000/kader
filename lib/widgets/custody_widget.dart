import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kader/localization/language/languages.dart';
import 'package:kader/models/custody.dart';
import 'package:kader/providers/custody_provider.dart';
import 'package:kader/services/shared_preferences_helper.dart';
import 'package:provider/provider.dart';

class CustodyWidget extends StatefulWidget {
  final Custody custody;

  const CustodyWidget({
    Key? key,
    required this.custody,
  }) : super(key: key);

  @override
  State<CustodyWidget> createState() => _CustodyWidgetState();
}

class _CustodyWidgetState extends State<CustodyWidget> {
  @override
  Widget build(BuildContext context) {
    final languages = Languages.of(context);
    final user = SharedPreferencesHelper.instance.account;
    final servicesProvider = Provider.of<CustodyProvider>(context);

    return user.type.toString() == 'admin'
        ? Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              color: Colors.white,
            ),
            margin: const EdgeInsets.only(top: 15, left: 10, right: 10),
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Expanded(
                  flex: 7,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("${languages.custodyName} : ${widget.custody.name}",
                          style: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 15),
                      Text(
                          "${languages.employeeName} : ${widget.custody.ownerName}",
                          style: const TextStyle(fontSize: 18)),
                      const SizedBox(height: 15),
                      Text(
                        "${languages.receivedDate} : ${DateFormat('yyyy-MM-dd').format(widget.custody.dateRequestAccept!)}",
                        style: const TextStyle(
                          fontSize: 18,
                          color: Colors.green,
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                Expanded(
                  flex: 3,
                  child: Column(
                    children: [
                      TextButton(
                          onPressed: () {
                            servicesProvider.deleteCustody(widget.custody);
                          },
                          child: Text(
                            languages.deleteCustody,
                            style: const TextStyle(
                              fontSize: 18,
                            ),
                          ))
                    ],
                  ),
                )
              ],
            ),
          )
        : Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              color: Colors.white,
            ),
            margin: const EdgeInsets.only(top: 15, left: 10, right: 10),
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${languages.custodyName} : ${widget.custody.name}",
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 15),
                widget.custody.hasReply
                    ? Text(
                        languages.awaitingApproval,
                        style: const TextStyle(fontSize: 18, color: Colors.red),
                      )
                    : Text(
                        "${languages.receivedDate} : ${DateFormat('yyyy-MM-dd').format(widget.custody.dateRequestAccept!)}",
                        style: const TextStyle(
                          fontSize: 18,
                          color: Colors.green,
                        ),
                      ),
              ],
            ),
          );
  }
}
