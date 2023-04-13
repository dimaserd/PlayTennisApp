import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:play_tennis/app/main/widgets/palette.dart';
import 'package:play_tennis/main-services.dart';
import 'main-routes.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'main-settings.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  // await Firebase.initializeApp();

  print("Handling a background message: ${message.messageId}");
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Инициализируйте Firebase Messaging.
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  // Добавьте обработчик фоновых сообщений и бэкграугда.

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
    print("authorized for notifications");
  } else {
    print('User did not grant permission to receive notifications');
  }
  await messaging.getToken().then((token) {
    print('Token: $token');

    if (token != null) {
      AppServices.appNotificationTokenService.addToken(token);
    }
  });

  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print('Got a message whilst in the foreground!');
    print('Message data: ${message.data}');

    if (message.notification != null) {
      print('Message also contained a notification: ${message.notification}');
    }
  });

  await messaging.setForegroundNotificationPresentationOptions(alert: true);
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]).then(
    (_) => runApp(const MyApp()),
  );
}

class MyApp extends StatelessWidget {
  static bool inProccess = false;

  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    _initializeFlutterFire();
    return GlobalLoaderOverlay(
      child: MaterialApp(
        title: MainSettings.appName,
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('en', ''),
          Locale('ru', ''),
        ],
        theme: ThemeData(
          fontFamily: 'Roboto',
          bottomAppBarTheme: const BottomAppBarTheme(color: mainMaterialColor),
          colorScheme: ColorScheme.fromSwatch(primarySwatch: mainMaterialColor)
              .copyWith(secondary: Colors.amber),
        ),
        onGenerateRoute: (settings) => MainRoutes.onGenerateRoute(settings),
      ),
    );
  }

  // Define an async function to initialize FlutterFire
  Future<void> _initializeFlutterFire() async {
    // Force enable crashlytics collection enabled if we're testing it.
    await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);
    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
  }
}
