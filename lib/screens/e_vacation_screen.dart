import 'package:flutter/material.dart';
import 'package:kader/localization/language/languages.dart';
import 'package:kader/screens/display_vacations_screen.dart';
import 'package:kader/screens/pending_requests_screen.dart';
import 'package:kader/screens/return_screen.dart';
import 'package:kader/screens/vacation_request_screen.dart';
import 'package:kader/screens/vacations_balance_screen.dart';
import 'package:kader/widgets/e_vaction_service_widget.dart';

class EVacationScreen extends StatelessWidget {
  static const String routeName = 'EVacationScreen';

  const EVacationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final languages = Languages.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(languages.eVacation),
      ),
      body: Column(
        children: <Widget>[
          EVacationServiceWidget(
            name: languages.vacationRequest,
            routeName: VacationRequestScreen.routeName,
          ),
          EVacationServiceWidget(
            name: languages.vacationsBalance,
            routeName: VacationsBalanceScreen.routeName,
          ),
          EVacationServiceWidget(
            name: languages.pendingRequests,
            routeName: PendingRequestsScreen.routeName,
          ),
          EVacationServiceWidget(
            name: languages.returnAcknowledgment,
            routeName: ReturnScreen.routeName,
          ),
          EVacationServiceWidget(
            name: languages.kDisplayVacations,
            routeName: DisplayVacationsScreen.routeName,
          ),
        ],
      ),
    );
  }
}
