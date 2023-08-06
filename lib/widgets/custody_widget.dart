import 'package:flutter/material.dart';
import 'package:kader/localization/language/languages.dart';
import 'package:kader/models/custody.dart';
import 'package:kader/models/custody_transfer_request.dart';
import 'package:kader/models/department.dart';
import 'package:kader/providers/custody_provider.dart';
import 'package:kader/providers/departments_provider.dart';
import 'package:kader/services/shared_preferences_helper.dart';
import 'package:kader/services/strings_helper.dart';
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
    final provider = Provider.of<CustodyProvider>(context);

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        color: Colors.white,
      ),
      margin: const EdgeInsets.all(12),
      padding: const EdgeInsets.all(12),
      child: user.isAdmin
          ? Row(
              children: <Widget>[
                Expanded(
                  flex: 7,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.custody.name,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        widget.custody.ownerName,
                        style: const TextStyle(
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        "${languages.requestDate}: "
                        "${StringsHelper.getDate(widget.custody.dateRequestAccept!)}",
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                TextButton(
                  child: Text(
                    languages.deleteCustody,
                    style: const TextStyle(
                      fontSize: 18,
                    ),
                  ),
                  onPressed: () {
                    provider.deleteCustody(widget.custody);
                  },
                )
              ],
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  widget.custody.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                if (widget.custody.hasRequestToTransfer)
                  Text(languages.custodyRequestTransferHasSent),
                if (!widget.custody.hasRequestToTransfer) ...[
                  const SizedBox(height: 12),
                  if (widget.custody.hasReply)
                    Text(
                      "${languages.receivedDate}: "
                      "${StringsHelper.getDate(widget.custody.dateRequestAccept!)}",
                    ),
                  const SizedBox(height: 12),
                  if (!widget.custody.hasReply)
                    Text(
                      languages.awaitingApproval,
                      style: const TextStyle(fontSize: 18, color: Colors.red),
                    ),
                  const SizedBox(height: 12),
                  if (widget.custody.hasReply) ...[
                    TextButton(
                      child: Text(languages.transferToAnotherEmployee),
                      onPressed: () async {
                        if (!mounted) return;
                        late Department department;
                        if (user.isEmployee) {
                          department = await Provider.of<DepartmentsProvider>(
                            context,
                            listen: false,
                          ).getDepartmentByEmployee(user);
                        } else {
                          department = await Provider.of<DepartmentsProvider>(
                            context,
                            listen: false,
                          ).getDepartmentByManager(user);
                        }

                        if (!mounted) return;
                        final users = await Provider.of<DepartmentsProvider>(
                          context,
                          listen: false,
                        ).getDepartmentEmployees(department);

                        users.remove(user);

                        await showDialog(
                          context: context,
                          builder: (context) {
                            return Dialog(
                              child: ListView.builder(
                                itemCount: users.length,
                                itemBuilder: (context, index) {
                                  final user = users[index];
                                  return ListTile(
                                    title: Text(user.name),
                                    trailing: TextButton(
                                      child: Text(languages.transfer),
                                      onPressed: () async {
                                        widget.custody.hasRequestToTransfer =
                                            true;
                                        await provider
                                            .updateCustody(widget.custody);
                                        await provider
                                            .addCustodyTransferRequest(
                                          CustodyTransferRequest(
                                            custodyId: widget.custody.id!,
                                            custodyName: widget.custody.name,
                                            fromUserId: widget.custody.ownerId,
                                            fromUserName:
                                                widget.custody.ownerName,
                                            toUserId: user.id,
                                            toUserName: user.name,
                                          ),
                                        );

                                        Navigator.of(context).pop();
                                      },
                                    ),
                                  );
                                },
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ],
                ],
              ],
            ),
    );
  }
}
