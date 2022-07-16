import 'package:flutter/material.dart';
import 'package:kader/localization/language/languages.dart';
import 'package:kader/models/custody.dart';
import 'package:kader/providers/custody_provider.dart';
import 'package:kader/widgets/custody_request_widget.dart';
import 'package:kader/widgets/loading_widget.dart';
import 'package:kader/widgets/text_empty_widget.dart';
import 'package:provider/provider.dart';

class PendingRequestsScreen extends StatelessWidget {
  static const String routeName = 'PendingRequestsScreen';

  const PendingRequestsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final languages = Languages.of(context);
    final custodyProvider = Provider.of<CustodyProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(languages.pendingRequests),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: FutureBuilder<List<Custody>>(
              future: custodyProvider.custodiesWithoutReply,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  final custodies = snapshot.data!;

                  if (custodies.isEmpty) {
                    return const TextEmptyWidget();
                  }

                  return ListView.builder(
                    itemCount: custodies.length,
                    itemBuilder: (context, index) {
                      return CustodyRequestWidget(custody: custodies[index]);
                    },
                  );
                }
                return const LoadingWidget();
              },
            ),
          )
        ],
      ),
    );
  }
}
