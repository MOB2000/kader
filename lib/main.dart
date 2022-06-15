import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kader/constants/colors.dart';
import 'package:kader/localization/app_localizations_delegate.dart';
import 'package:kader/localization/language/languages.dart';
import 'package:kader/localization/locale_constant.dart';
import 'package:kader/providers/auth_provider.dart';
import 'package:kader/screens/auth/login_screen.dart';
import 'package:kader/screens/auth/register_screen.dart';
import 'package:kader/screens/complaints_screen.dart';
import 'package:kader/screens/custody_screen.dart';
import 'package:kader/screens/display_vacations_screen.dart';
import 'package:kader/screens/e_vacation_screen.dart';
import 'package:kader/screens/home_screen.dart';
import 'package:kader/screens/pending_requests_screen.dart';
import 'package:kader/screens/return_screen.dart';
import 'package:kader/screens/vacation_request_screen.dart';
import 'package:kader/screens/vacations_balance_screen.dart';
import 'package:kader/screens/working_hours_screen.dart';
import 'package:kader/services/connectivity.dart';
import 'package:kader/services/db.dart';
import 'package:kader/services/shared_preferences.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  final widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  await SharedPrefs.instance.init();
  await DB.instance.init();
  Connection.instance.listen();

  await Firebase.initializeApp();

  // TODO: remove unused packages, images and classes
  // TODO: check exceptions
  // TODO: check internet connection
  // TODO: extract strings
  // TODO: group files in sub folders
  // TODO:
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

  String get initialRoute => SharedPrefs.instance.isLogged
      ? HomeScreen.routeName
      : LoginScreen.routeName;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthProvider()),
      ],
      builder: (context, child) {
        return MaterialApp(
          theme: ThemeData(
            fontFamily: GoogleFonts.tajawal().fontFamily,
            scaffoldBackgroundColor: kScaffoldBackgroundColor,
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
            ComplaintsScreen.routeName: (context) => const ComplaintsScreen(),
            EVacationScreen.routeName: (context) => const EVacationScreen(),
            ReturnScreen.routeName: (context) => const ReturnScreen(),
            VacationRequestScreen.routeName: (context) =>
                const VacationRequestScreen(),
            PendingRequestsScreen.routeName: (context) =>
                const PendingRequestsScreen(),
            DisplayVacationsScreen.routeName: (context) =>
                const DisplayVacationsScreen(),
            WorkingHoursScreen.routeName: (context) =>
                const WorkingHoursScreen(),
            CustodyScreen.routeName: (context) => const CustodyScreen(),
            VacationsBalanceScreen.routeName: (context) =>
                const VacationsBalanceScreen(),
          },
          locale: _locale,
          supportedLocales: languageList.map((e) => e.toLocale),
          localizationsDelegates: const [
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
