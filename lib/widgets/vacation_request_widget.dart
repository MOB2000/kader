import 'package:flutter/material.dart';
import 'package:kader/models/request_status.dart';
import 'package:kader/models/vacation_request.dart';
import 'package:kader/providers/vacations_provider.dart';
import 'package:kader/services/strings_helper.dart';
import 'package:provider/provider.dart';

class VacationRequestWidget extends StatelessWidget {
  final VacationRequest vacationRequest;
  final bool isManager;

  const VacationRequestWidget({
    Key? key,
    required this.vacationRequest,
    required this.isManager,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<VacationsProvider>(context);

    final range =
        '${StringsHelper.getDate(vacationRequest.dateTimeRange.start)} ${StringsHelper.getDate(vacationRequest.dateTimeRange.end)}';
    return ListTile(
      title: Text(vacationRequest.employeeName),
      subtitle: Text(range),
      trailing: isManager && vacationRequest.status == RequestStatus.pending
          ? Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                TextButton(
                  child: const Text('قبول'),
                  onPressed: () async {
                    vacationRequest.status = RequestStatus.accepted;

                    await provider.updateVacation(vacationRequest);
                  },
                ),
                TextButton(
                  child: const Text('رفض'),
                  onPressed: () async {
                    vacationRequest.status = RequestStatus.rejected;
                    await provider.updateVacation(vacationRequest);
                  },
                ),
              ],
            )
          : Text(vacationRequest.status.toString()),
    );
  }
}
