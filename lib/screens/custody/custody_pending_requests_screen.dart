import 'package:flutter/material.dart';
import 'package:kader/localization/language/languages.dart';
import 'package:kader/models/custody.dart';
import 'package:kader/providers/custody_provider.dart';
import 'package:kader/widgets/custody_pending_request_widget.dart';
import 'package:kader/widgets/loading_widget.dart';
import 'package:kader/widgets/when_empty_widget.dart';
import 'package:provider/provider.dart';

class CustodyPendingRequestsScreen extends StatelessWidget {
  static const String routeName = 'CustodyPendingRequestsScreen';

  const CustodyPendingRequestsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final languages = Languages.of(context);
    final provider = Provider.of<CustodyProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(languages.pendingRequests),
      ),
      body: FutureBuilder<List<Custody>>(
        future: provider.custodiesWithoutReply,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            final custodies = snapshot.data!;

            if (custodies.isEmpty) {
              return const WhenEmptyWidget();
            }

            return ListView.builder(
              itemCount: custodies.length,
              itemBuilder: (context, index) {
                return CustodyPendingRequestWidget(custody: custodies[index]);
              },
            );
          }
          return const LoadingWidget();
        },
      ),
    );
  }
}
