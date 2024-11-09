import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:gozip/core/routes/routes_manager.dart';
import 'package:gozip/presentation/widgets/common_widgets/snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ConnectivityHelper {
  static Future<void> replaceIfConnected(BuildContext context, String route,
      {Object? args}) async {
    final List<ConnectivityResult> connectivityResult =
        await Connectivity().checkConnectivity();
    final isConnected = connectivityResult.first != ConnectivityResult.none;

    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setBool('isConnected', isConnected);

    if (connectivityResult.first != ConnectivityResult.none) {
      // If connected, navigate to the specified route
      Navigator.of(context).pushReplacementNamed(route, arguments: args);
    } else {
      // If not connected, show the no internet screen
      Navigator.of(context).pushNamed(Routes.noInternetRoute);
    }
  }

  static Future<bool> checkConnection() async {
    final List<ConnectivityResult> connectivityResult =
        await Connectivity().checkConnectivity();
    final isConnected = connectivityResult.first != ConnectivityResult.none;
    return isConnected;
  }

  static Future<void> clareStackPush(BuildContext context, String route,
      {Object? args}) async {
    final List<ConnectivityResult> connectivityResult =
        await Connectivity().checkConnectivity();
    final isConnected = connectivityResult.first != ConnectivityResult.none;

    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setBool('isConnected', isConnected);

    if (connectivityResult.first != ConnectivityResult.none) {
      Navigator.of(context).pushNamedAndRemoveUntil(route, (route) => false);
    } else {
      Navigator.of(context)
          .pushNamedAndRemoveUntil(Routes.noInternetRoute, (route) => false);
    }
  }

  static Future<void> naviagte(BuildContext context, String route,
      {Object? args}) async {
    final List<ConnectivityResult> connectivityResult =
        await Connectivity().checkConnectivity();
    final isConnected = connectivityResult.first != ConnectivityResult.none;

    // SharedPreferences preferences = await SharedPreferences.getInstance();
    // preferences.setBool('isConnected', isConnected);

    if (isConnected) {
      // If connected, navigate to the specified route
      if (context.mounted) {
        Navigator.of(context).pushNamed(route, arguments: args);
      }
    } else {
      // If not connected, show the no internet screen
      Navigator.of(context).pushNamed(Routes.noInternetRoute);
    }
  }

  static Future<void> popIfConnected(BuildContext context) async {
    final List<ConnectivityResult> connectivityResult =
        await Connectivity().checkConnectivity();
    final isConnected = connectivityResult.first != ConnectivityResult.none;

    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setBool('isConnected', isConnected);

    if (connectivityResult.first != ConnectivityResult.none) {
      // If connected, navigate to the specified route
      Navigator.of(context).pop();
    } else {
      // If not connected, show the no internet screen
      customSnackBar(
        context,
        'Check your Internet connection',
        false,
      );
    }
  }
}
