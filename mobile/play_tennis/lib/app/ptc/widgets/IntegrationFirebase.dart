import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:play_tennis/firebase_options.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp();

  print("Handling a background message: ${message.messageId}");
}

class IntegrationFirebase  {
  

Future<void> integrate() async {
  print("start");
WidgetsFlutterBinding.ensureInitialized();

  // Инициализируйте Firebase Messaging.
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform
  );
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  // Добавьте обработчик фоновых сообщений и бэкграугда.
  await messaging.setForegroundNotificationPresentationOptions(alert: true);
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  // Запросите разрешение на получение уведомлений.
  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );

  // Если пользователь дал разрешение на получение уведомлений, получите токен.
  if (settings.authorizationStatus == AuthorizationStatus.authorized) {
    print("authorized");
    String? token = await messaging.getToken();
    print('Token: $token');
    String? apns = await messaging.getAPNSToken();
    print("apns token $apns");

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Got a message whilst in the foreground!');
      print('Message data: ${message.data}');

      if (message.notification != null) {
        print('Message also contained a notification: ${message.notification}');
      }
    });
  } else {
    print('User did not grant permission to receive notifications');
  }
  print("start");
}
}