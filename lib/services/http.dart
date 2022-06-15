import 'dart:io';

class Http {
  Http._() {
    HttpOverrides.global = MyHttpOverrides();
  }

  static final Http instance = Http._();
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
