import 'package:flutter/material.dart';
import 'package:kader/localization/language/languages.dart';
import 'package:kader/models/custody.dart';
import 'package:kader/providers/custody_provider.dart';
import 'package:kader/services/strings_helper.dart';
import 'package:provider/provider.dart';

class CustodyPendingRequestWidget extends StatefulWidget {
  final Custody custody;

  const CustodyPendingRequestWidget({
    Key? key,
    required this.custody,
  }) : super(key: key);

  @override
  State<CustodyPendingRequestWidget> createState() =>
      _CustodyPendingRequestWidgetState();
}

class _CustodyPendingRequestWidgetState
    extends State<CustodyPendingRequestWidget> {
  @override
  Widget build(BuildContext context) {
    final languages = Languages.of(context);
    final provider = Provider.of<CustodyProvider>(context);

    return Container(
      margin: const EdgeInsets.all(8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(32),
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.custody.ownerName,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            widget.custody.name,
          ),
          const SizedBox(height: 8),
          Text(
            "${languages.reason}: ${widget.custody.reason}",
          ),
          const SizedBox(height: 8),
          Text(
            "${languages.requestDate}: "
            "${StringsHelper.getDate(widget.custody.dateSendRequest!)}",
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton(
                onPressed: () {
                  widget.custody.hasReply = true;
                  widget.custody.dateRequestAccept = DateTime.now();
                  provider.updateCustody(widget.custody);
                },
                child: Text(
                  languages.acceptance,
                  style: const TextStyle(
                    color: Colors.green,
                  ),
                ),
              ),
              const SizedBox(width: 32),
              TextButton(
                child: Text(
                  languages.reject,
                  style: const TextStyle(
                    color: Colors.red,
                  ),
                ),
                onPressed: () async {
                  await provider.deleteCustody(widget.custody);
                },
              ),
            ],
          )
        ],
      ),
    );
  }
}
