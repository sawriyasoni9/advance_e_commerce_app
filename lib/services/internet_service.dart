import 'package:connectivity_plus/connectivity_plus.dart';

class InternetService {
  static Future<bool> hasInternetConnected() async {
    final connectivityResults = await Connectivity().checkConnectivity();

    if (connectivityResults.contains(ConnectivityResult.mobile) ||
        connectivityResults.contains(ConnectivityResult.wifi) ||
        connectivityResults.contains(ConnectivityResult.ethernet) ||
        connectivityResults.contains(ConnectivityResult.vpn)) {
      return true;
    }

    // No connection or unsupported types
    return false;
  }
}
