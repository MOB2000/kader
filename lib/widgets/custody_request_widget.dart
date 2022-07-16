import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kader/localization/language/languages.dart';
import 'package:kader/models/custody.dart';
import 'package:kader/models/custom_user.dart';
import 'package:kader/providers/custody_provider.dart';
import 'package:kader/services/shared_preferences_helper.dart';
import 'package:provider/provider.dart';

class CustodyRequestWidget extends StatefulWidget {
  final Custody custody;

  const CustodyRequestWidget({
    Key? key,
    required this.custody,
  }) : super(key: key);

  @override
  State<CustodyRequestWidget> createState() => _CustodyRequestWidgetState();
}

class _CustodyRequestWidgetState extends State<CustodyRequestWidget> {
  @override
  Widget build(BuildContext context) {
    final languages = Languages.of(context);
    final servicesProvider = Provider.of<CustodyProvider>(context);

    CustomUser user = SharedPreferencesHelper.instance.account;
    return user.type.toString() == "admin"
        ? Container(
            margin: const EdgeInsets.all(10),
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              color: Colors.white,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${languages.employeeName} : ${widget.custody.ownerName}",
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  "${languages.custodyName} : ${widget.custody.name}",
                  style: const TextStyle(fontSize: 20),
                ),
                const SizedBox(height: 8),
                Text(
                  "${languages.reason} : ${widget.custody.reason}",
                  style: const TextStyle(fontSize: 18),
                ),
                const SizedBox(height: 8),
                Text(
                  "${languages.sendingDate} : ${DateFormat('yyyy-MM-dd').format(widget.custody.dateSendRequest!)}",
                  style: const TextStyle(fontSize: 18, color: Colors.green),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                        onPressed: () {
                          widget.custody.reply = true;
                          widget.custody.dateRequestAccept = DateTime.now();
                          servicesProvider.updateCustody(widget.custody);
                        },
                        child: Text(
                          languages.acceptance,
                          style: const TextStyle(
                              fontSize: 20, color: Colors.green),
                        )),
                    const SizedBox(width: 30),
                    TextButton(
                        onPressed: () {
                          servicesProvider.deleteCustody(widget.custody);
                        },
                        child: Text(
                          languages.reject,
                          style:
                              const TextStyle(fontSize: 20, color: Colors.red),
                        )),
                  ],
                )
              ],
            ),
          )
        : Container();
  }
}
