import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();

  factory NotificationService() => _instance;

  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  final AndroidNotificationChannel _channel = const AndroidNotificationChannel(
    'default_channel',
    'Default Notifications',
    description: 'This channel is used for default notifications.',
    importance: Importance.high,
  );

  Future<void> init() async {
    // Initialize notification settings
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const DarwinInitializationSettings iosSettings =
        DarwinInitializationSettings();
    const InitializationSettings initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _flutterLocalNotificationsPlugin.initialize(initSettings);

    await _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(_channel);

    await _requestPermissions();
    _listenToMessages();

    String? token = await FirebaseMessaging.instance.getToken();
    print('📲 FCM Token: $token');
  }

  Future<void> _requestPermissions() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    // Request Firebase messaging permissions (iOS + Android compatibility)
    await messaging.requestPermission(alert: true, badge: true, sound: true);

    // Android 13+ requires runtime permission for notifications
    if (Platform.isAndroid && await _isAndroid13OrAbove()) {
      final status = await Permission.notification.status;
      if (status.isDenied || status.isRestricted) {
        await Permission.notification.request();
      }
    }
  }

  void _listenToMessages() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      final notification = message.notification;
      if (notification != null) {
        _flutterLocalNotificationsPlugin.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
              _channel.id,
              _channel.name,
              channelDescription: _channel.description,
              importance: Importance.max,
              priority: Priority.high,
            ),
            iOS: const DarwinNotificationDetails(),
          ),
        );
      }
    });
  }

  Future<bool> _isAndroid13OrAbove() async {
    return Platform.isAndroid && (await _getAndroidSdkInt()) >= 33;
  }

  Future<int> _getAndroidSdkInt() async {
    try {
      final methodChannel = MethodChannel('com.example.playpadi/platform');
      final int sdkInt = await methodChannel.invokeMethod('getSdkInt');
      return sdkInt;
    } catch (e) {
      return 0;
    }
  }
}
