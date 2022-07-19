import 'package:flutter/material.dart';
import 'package:kader/localization/language/languages.dart';
import 'package:kader/models/request_status.dart';
import 'package:kader/models/vacation_request.dart';
import 'package:kader/providers/auth_provider.dart';
import 'package:kader/providers/vacations_provider.dart';
import 'package:kader/services/strings_helper.dart';
import 'package:provider/provider.dart';

class VacationRequestWidget extends StatelessWidget {
  final VacationRequest vacationRequest;

  const VacationRequestWidget({
    Key? key,
    required this.vacationRequest,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final languages = Languages.of(context);

    final provider = Provider.of<VacationsProvider>(context);
    final user = Provider.of<AuthProvider>(context).user;

    final range =
        '${StringsHelper.getDate(vacationRequest.dateTimeRange.start)} '
        '${StringsHelper.getDate(vacationRequest.dateTimeRange.end)}';

    return ListTile(
      title: Text(
        user.isEmployee ? vacationRequest.cause : vacationRequest.employeeName,
      ),
      subtitle: Text('${vacationRequest.cause}\n$range'),
      isThreeLine: true,
      trailing:
          user.isManager && vacationRequest.status == RequestStatus.pending
              ? Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    TextButton(
                      child: Text(languages.accept),
                      onPressed: () async {
                        vacationRequest.status = RequestStatus.accepted;

                        await provider.updateVacation(vacationRequest);
                      },
                    ),
                    TextButton(
                      child: Text(languages.reject),
                      onPressed: () async {
                        vacationRequest.status = RequestStatus.rejected;
                        await provider.updateVacation(vacationRequest);
                      },
                    ),
                  ],
                )
              : Text(
                  StringsHelper.translateRequestStatus(
                    vacationRequest.status,
                    languages,
                  ),
                ),
    );
  }
}
