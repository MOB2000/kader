import 'package:flutter/material.dart';
import 'package:kader/localization/language/languages.dart';
import 'package:kader/models/custody_transfer_request.dart';
import 'package:kader/providers/custody_provider.dart';
import 'package:kader/widgets/loading_widget.dart';
import 'package:kader/widgets/when_empty_widget.dart';
import 'package:provider/provider.dart';

class CustodyTransferRequestsScreen extends StatelessWidget {
  static const String routeName = 'CustodyTransferRequestsScreen';

  const CustodyTransferRequestsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final languages = Languages.of(context);
    final provider = Provider.of<CustodyProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(languages.transferRequests),
      ),
      body: FutureBuilder<List<CustodyTransferRequest>>(
        future: provider.custodyTransferRequests,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            final requests = snapshot.data!;
            if (requests.isEmpty) {
              return const WhenEmptyWidget();
            }
            return ListView.builder(
              itemCount: requests.length,
              itemBuilder: (context, index) {
                final request = requests[index];
                return ListTile(
                  title: Text(request.custodyName),
                  subtitle: Text(
                    '${languages.from} ${request.fromUserName} \n${languages.to} ${request.toUserName}',
                  ),
                  isThreeLine: true,
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      TextButton(
                        onPressed: () async {
                          await provider.transferCustody(request);
                        },
                        child: Text(languages.accept),
                      ),
                      TextButton(
                        onPressed: () async {
                          await provider.deleteCustodyTransferRequest(request);
                        },
                        child: Text(languages.reject),
                      ),
                    ],
                  ),
                );
              },
            );
          }

          return const LoadingWidget();
        },
      ),
    );
  }
}
