import 'package:connectivity_plus/connectivity_plus.dart';

class Connection {
  Connection._();

  static final Connection instance = Connection._();

  bool hasConnection = false;

  void listen() async {
    Connectivity().onConnectivityChanged.listen((result) {
      hasConnection = result == ConnectivityResult.wifi;
    });
  }
}
