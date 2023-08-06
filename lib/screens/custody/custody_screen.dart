import 'package:flutter/material.dart';
import 'package:kader/localization/language/languages.dart';
import 'package:kader/models/custody.dart';
import 'package:kader/providers/auth_provider.dart';
import 'package:kader/providers/custody_provider.dart';
import 'package:kader/screens/custody/custody_pending_requests_screen.dart';
import 'package:kader/screens/custody/custody_transfer_requests_screen.dart';
import 'package:kader/screens/custody/request_custody_screen.dart';
import 'package:kader/widgets/custody_widget.dart';
import 'package:kader/widgets/loading_widget.dart';
import 'package:kader/widgets/when_empty_widget.dart';
import 'package:provider/provider.dart';

class CustodyScreen extends StatelessWidget {
  static const String routeName = 'CustodyScreen';

  const CustodyScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final languages = Languages.of(context);
    final custodyProvider = Provider.of<CustodyProvider>(context);
    final user = Provider.of<AuthProvider>(context).user;

    return Scaffold(
      appBar: AppBar(
        title: Text(languages.custody),
      ),
      body: Column(
        children: <Widget>[
          if (user.isAdmin) ...[
            TextButton(
              child: Text(languages.pendingRequests),
              onPressed: () async {
                Navigator.of(context)
                    .pushNamed(CustodyPendingRequestsScreen.routeName);
              },
            ),
            TextButton(
              child: Text(languages.transferRequests),
              onPressed: () async {
                Navigator.of(context)
                    .pushNamed(CustodyTransferRequestsScreen.routeName);
              },
            ),
            Expanded(
              child: FutureBuilder<List<Custody>>(
                future: custodyProvider.custodiesWithReply,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    final custodies = snapshot.data!;
                    return ListView.builder(
                      itemCount: custodies.length,
                      itemBuilder: (context, index) {
                        return CustodyWidget(custody: custodies[index]);
                      },
                    );
                  }
                  return const LoadingWidget();
                },
              ),
            ),
          ],
          if (!user.isAdmin)
            Expanded(
              child: FutureBuilder<List<Custody>>(
                future: custodyProvider.getUserCustodies(user),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    final custody = snapshot.data!;
                    if (custody.isEmpty) {
                      return const WhenEmptyWidget();
                    }
                    return ListView.builder(
                        itemCount: custody.length,
                        itemBuilder: (context, index) =>
                            CustodyWidget(custody: custody[index]));
                  }
                  return const LoadingWidget();
                },
              ),
            )
        ],
      ),
      floatingActionButton: user.isAdmin
          ? null
          : FloatingActionButton(
              child: const Icon(Icons.add),
              onPressed: () {
                Navigator.of(context).pushNamed(RequestCustodyScreen.routeName);
              },
            ),
    );
  }
}
