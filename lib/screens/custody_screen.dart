import 'package:flutter/material.dart';
import 'package:kader/localization/language/languages.dart';
import 'package:kader/models/custody.dart';
import 'package:kader/providers/auth_provider.dart';
import 'package:kader/providers/custody_provider.dart';
import 'package:kader/screens/add_custody_screen.dart';
import 'package:kader/screens/pending_requests_screen.dart';
import 'package:kader/widgets/custody_widget.dart';
import 'package:kader/widgets/loading_widget.dart';
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
          if (user.isAdmin)
            TextButton(
              child: Text(languages.pendingRequests),
              onPressed: () async {
                Navigator.of(context)
                    .pushNamed(PendingRequestsScreen.routeName);
              },
            ),
          if (user.isAdmin)
            Expanded(
              child: FutureBuilder<List<Custody>>(
                future: custodyProvider.custodies,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    final custodies = snapshot.data!;
                    return ListView.builder(
                      itemCount: custodies.length,
                      itemBuilder: (context, index) {
                        return CustodyWidget(custody: custodies[index]);
                        if (custodies[index].reply) {
                          return CustodyWidget(custody: custodies[index]);
                        } else {
                          return Container();
                        }
                      },
                    );
                  }
                  return const LoadingWidget();
                },
              ),
            ),
          if (!user.isAdmin)
            Expanded(
              child: FutureBuilder<List<Custody>>(
                future: custodyProvider.custodies,
                builder: (context, snapshot) {
                  final custody = snapshot.data;
                  if (custody != null) {
                    return ListView.builder(
                        itemCount: custody.length,
                        itemBuilder: (context, index) {
                          if (custody[index].ownerId == user.id) {
                            return CustodyWidget(custody: custody[index]);
                          } else {
                            return Container();
                          }
                        });
                  } else {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
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
                Navigator.of(context).pushNamed(AddCustodyScreen.routeName);
              },
            ),
    );
  }
}
