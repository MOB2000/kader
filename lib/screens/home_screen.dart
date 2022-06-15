import 'package:flutter/material.dart';
import 'package:kader/constants/colors.dart';
import 'package:kader/constants/images.dart';
import 'package:kader/localization/language/languages.dart';
import 'package:kader/screens/additional_services_screen.dart';
import 'package:kader/screens/administrative_services_screen.dart';
import 'package:kader/screens/custody_screen.dart';
import 'package:kader/screens/financial_obligations_screen.dart';
import 'package:kader/screens/protocols_screen.dart';
import 'package:kader/screens/work_information_screen.dart';
import 'package:kader/widgets/custom_drawer.dart';
import 'package:kader/widgets/service_widget.dart';
import 'package:kader/widgets/services_widget.dart';

class HomeScreen extends StatelessWidget {
  static const String routeName = 'HomeScreen';

  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final languages = Languages.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(languages.kHome),
      ),
      drawer: const CustomDrawer(),
      body: Column(
        children: <Widget>[
          Expanded(
            child: ServicesWidget(
              children: <ServiceWidget>[
                ServiceWidget(
                  name: languages.workInformation,
                  routeName: WorkInformationScreen.routeName,
                  image: Images.workInformation,
                ),
                ServiceWidget(
                  name: languages.administrativeServices,
                  routeName: AdministrativeServicesScreen.routeName,
                  image: Images.administrativeServices,
                ),
                ServiceWidget(
                  name: languages.custody,
                  image: Images.custodyImage,
                  routeName: CustodyScreen.routeName,
                ),
                ServiceWidget(
                  name: languages.financialObligations,
                  image: Images.financialObligations,
                  routeName: FinancialObligationsScreen.routeName,
                ),
                ServiceWidget(
                  name: languages.protocols,
                  image: Images.protocols,
                  routeName: ProtocolsScreen.routeName,
                ),
                ServiceWidget(
                  name: languages.additionalServices,
                  image: Images.additionalServicesImage,
                  routeName: AdditionalServicesScreen.routeName,
                  color: kSecondaryColor,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
