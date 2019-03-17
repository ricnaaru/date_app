import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

typedef TokenHandler = void Function(String token);

class NotificationHelper {
  static NotificationHelper get instance => _singleton;
  static final NotificationHelper _singleton = new NotificationHelper._();
  static FirebaseMessaging _instance = FirebaseMessaging();
  MessageHandler _onMessage;
  MessageHandler _onLaunch;
  MessageHandler _onResume;
  TokenHandler _onTokenRefresh;
  Function _aaa;

  NotificationHelper._() {
    initState();
  }

  static init({
    MessageHandler onMessage,
    MessageHandler onLaunch,
    MessageHandler onResume,
    TokenHandler onTokenRefresh,
    Function aaa,
  }) {
    _singleton._onMessage = onMessage;
    _singleton._onLaunch = onLaunch;
    _singleton._onResume = onResume;
    _singleton._onTokenRefresh = onTokenRefresh;
    _singleton._aaa = aaa;
    return _singleton;
  }

  static getToken() {
    _instance.getToken().then((token) => _singleton._onTokenRefresh(token));
  }

  void initState() {
    initLocalNotification();
    initFirebaseMessaging();
  }

  Future onDidRecieveLocalNotification(int id, String title, String body, String payload) async {
    print("saya di dalam");
      return await _aaa(id, title, body, payload);


    }

  Future onSelectNotification(String payload) {

  }

  void initLocalNotification() {
    /// app_icon needs to be a added as a drawable resource to the Android head project
    var initializationSettingsAndroid = new AndroidInitializationSettings('app_icon');
    var initializationSettingsIOS = new IOSInitializationSettings(onDidReceiveLocalNotification: onDidRecieveLocalNotification);
    var initializationSettings = new InitializationSettings(initializationSettingsAndroid, initializationSettingsIOS);
    FlutterLocalNotificationsPlugin().initialize(initializationSettings, onSelectNotification: onSelectNotification);
  }

  void initFirebaseMessaging() {
    if (Platform.isIOS) requestIosPermission();

    _instance.onTokenRefresh.listen((token) => _onTokenRefresh(token));

    _instance.configure(
      onMessage: (Map<String, dynamic> message) async {
        _onMessage(message);
      },
      onResume: (Map<String, dynamic> message) async {
        _onResume(message);
      },
      onLaunch: (Map<String, dynamic> message) async {
        _onLaunch(message);
      },
    );
  }

  void requestIosPermission() {
    _instance.requestNotificationPermissions(IosNotificationSettings(sound: true, badge: true, alert: true));
    _instance.onIosSettingsRegistered.listen((IosNotificationSettings settings) {
      print("(richardo) => Settings registered: $settings");
    });
  }
}
