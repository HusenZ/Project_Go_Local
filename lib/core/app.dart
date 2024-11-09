import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:gozip/core/routes/routes_manager.dart';
import 'package:gozip/core/theme/theme_manager.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class MyApp extends StatefulWidget {
  const MyApp._internal(); //private named constructor

  static MyApp instance =
      const MyApp._internal(); // single instance -- singleton

  @override
  State<MyApp> createState() => _MyAppState();

  factory MyApp() => instance; // factory for the class instance
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      AwesomeNotifications().createNotification(
        content: NotificationContent(
          id: 123,
          channelKey: 'channelKey',
          displayOnBackground: true,
          displayOnForeground: true,
          title: message.notification?.title ?? "new message",
          body: message.notification?.body ?? "Message body",
        ),
      );
    });
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {});
  }

  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, deviceType) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          initialRoute: Routes.splashRoute,
          routes: routes,
          theme: getApplicationTheme(),
        );
      },
    );
  }
}
