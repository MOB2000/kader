import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:kader/constants/colors.dart';
import 'package:kader/localization/app_localizations_delegate.dart';
import 'package:kader/localization/language/languages.dart';
import 'package:kader/localization/locale_constant.dart';
import 'package:kader/providers/attendance_provider.dart';
import 'package:kader/providers/auth_provider.dart';
import 'package:kader/providers/complaints_provider.dart';
import 'package:kader/providers/custody_provider.dart';
import 'package:kader/providers/departments_provider.dart';
import 'package:kader/providers/meeting_provider.dart';
import 'package:kader/providers/vacations_provider.dart';
import 'package:kader/screens/attendance/attendance_history_screen.dart';
import 'package:kader/screens/attendance/attendance_screen.dart';
import 'package:kader/screens/attendance/employees_attendance_history_screen.dart';
import 'package:kader/screens/auth/login_screen.dart';
import 'package:kader/screens/auth/register_screen.dart';
import 'package:kader/screens/complaints/add_complaint_screen.dart';
import 'package:kader/screens/complaints/complaints_screen.dart';
import 'package:kader/screens/custody/custody_pending_requests_screen.dart';
import 'package:kader/screens/custody/custody_screen.dart';
import 'package:kader/screens/custody/custody_transfer_requests_screen.dart';
import 'package:kader/screens/custody/request_custody_screen.dart';
import 'package:kader/screens/department/create_department_screen.dart';
import 'package:kader/screens/department/departments_screen.dart';
import 'package:kader/screens/home_screen.dart';
import 'package:kader/screens/meetings/meetings_screen.dart';
import 'package:kader/screens/staff_management_screen.dart';
import 'package:kader/screens/vacations/vacation_request_screen.dart';
import 'package:kader/screens/vacations/vacations_screen.dart';
import 'package:kader/services/shared_preferences_helper.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  final widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  await SharedPreferencesHelper.instance.init();

  await Firebase.initializeApp();

  runApp(const Kader());

  FlutterNativeSplash.remove();
}

class Kader extends StatefulWidget {
  const Kader({Key? key}) : super(key: key);

  static void setLocale(BuildContext context, Locale newLocale) =>
      context.findAncestorStateOfType<_KaderState>()?.setLocale(newLocale);

  @override
  State<Kader> createState() => _KaderState();
}

class _KaderState extends State<Kader> {
  Locale _locale = languageList.first.toLocale;

  void setLocale(Locale locale) {
    setState(() => _locale = locale);
  }

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    _locale = getLocale();
  }

  String get initialRoute {
    return SharedPreferencesHelper.instance.isLogged
        ? HomeScreen.routeName
        : LoginScreen.routeName;
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthProvider()),
        ChangeNotifierProvider(create: (context) => DepartmentsProvider()),
        ChangeNotifierProvider(create: (context) => VacationsProvider()),
        ChangeNotifierProvider(create: (context) => AttendanceProvider()),
        ChangeNotifierProvider(create: (context) => ComplaintsProvider()),
        ChangeNotifierProvider(create: (context) => CustodyProvider()),
        ChangeNotifierProvider(create: (context) => MeetingProvider()),
      ],
      builder: (context, child) {
        return MaterialApp(
          theme: ThemeData(
            scaffoldBackgroundColor: kSecondaryColor,
            inputDecorationTheme: const InputDecorationTheme(
              filled: true,
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: kMainColor),
              ),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: kMainColor),
              ),
              disabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: kMainColor),
              ),
              border: UnderlineInputBorder(
                borderSide: BorderSide(color: kMainColor),
              ),
            ),
            floatingActionButtonTheme: const FloatingActionButtonThemeData(
              backgroundColor: kMainColor,
            ),
            appBarTheme: const AppBarTheme(
              centerTitle: true,
              color: kMainColor,
            ),
          ),
          initialRoute: initialRoute,
          routes: {
            LoginScreen.routeName: (context) => const LoginScreen(),
            RegisterScreen.routeName: (context) => const RegisterScreen(),
            HomeScreen.routeName: (context) => const HomeScreen(),
            StaffManagementScreen.routeName: (context) =>
                const StaffManagementScreen(),
            VacationsScreen.routeName: (context) => const VacationsScreen(),
            VacationRequestScreen.routeName: (context) =>
                const VacationRequestScreen(),
            AttendanceScreen.routeName: (context) => const AttendanceScreen(),
            AttendanceHistoryScreen.routeName: (context) =>
                const AttendanceHistoryScreen(),
            EmployeesAttendanceHistoryScreen.routeName: (context) =>
                const EmployeesAttendanceHistoryScreen(),
            DepartmentsScreen.routeName: (context) => const DepartmentsScreen(),
            CreateDepartmentScreen.routeName: (context) =>
                const CreateDepartmentScreen(),
            ComplaintsScreen.routeName: (context) => const ComplaintsScreen(),
            MeetingsScreen.routeName: (context) => const MeetingsScreen(),
            CustodyPendingRequestsScreen.routeName: (context) =>
                const CustodyPendingRequestsScreen(),
            CustodyScreen.routeName: (context) => const CustodyScreen(),
            CustodyTransferRequestsScreen.routeName: (context) =>
                const CustodyTransferRequestsScreen(),
            AddComplaintsScreen.routeName: (context) =>
                const AddComplaintsScreen(),
            RequestCustodyScreen.routeName: (context) =>
                const RequestCustodyScreen(),
          },
          locale: _locale,
          supportedLocales: languageList.map((e) => e.toLocale),
          localizationsDelegates: const <LocalizationsDelegate>[
            AppLocalizationsDelegate(),
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          localeResolutionCallback: (locale, supportedLocales) {
            for (final supportedLocale in supportedLocales) {
              if (supportedLocale.languageCode == locale?.languageCode &&
                  supportedLocale.countryCode == locale?.countryCode) {
                return supportedLocale;
              }
            }
            return supportedLocales.first;
          },
          onGenerateTitle: (context) => Languages.of(context).kader,
          color: kMainColor,
          debugShowCheckedModeBanner: false,
        );
      },
    );
  }
}
