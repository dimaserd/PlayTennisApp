import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:play_tennis/app/main/widgets/images/ImageViewWidget.dart';
import 'package:play_tennis/app/main/widgets/palette.dart';
import 'package:play_tennis/main-services.dart';
import 'main-routes.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'main-settings.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

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

  //Почему-то падает
  try {
    String? token = await FirebaseMessaging.instance.getToken();

    if (token != null) {
      AppServices.appNotificationTokenService.addToken(token);
    }
  } catch (e) {
    print(e);
  }

  FirebaseMessaging.onMessageOpenedApp
      .listen((RemoteMessage message) => _handleMessage(message));

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
    [
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ],
  ).then(
    (_) => runApp(
      const MyApp(),
    ),
  );
}

void _handleMessage(RemoteMessage message) {
  navigatorKey.currentState?.pushNamed(MainRoutes.notifications);
}

class MyApp extends StatelessWidget {
  static bool inProccess = false;

  const MyApp({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    _initializeFlutterFire();
    _getSettingsApplication();
    return GlobalLoaderOverlay(
      child: MaterialApp(
        navigatorKey: navigatorKey,
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
          scaffoldBackgroundColor: Colors.white,
          bottomAppBarTheme: const BottomAppBarTheme(
            color: mainMaterialColor,
          ),
          colorScheme:
              ColorScheme.fromSwatch(primarySwatch: mainMaterialColor).copyWith(
            secondary: const Color.fromARGB(255, 0, 0, 0),
          ),
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

  Future<void> _getSettingsApplication() async {
    var model = await AppServices.clientService.settingsApplication();
    var imageUrl = model?.publicImageUrlFormat;
    ImageViewWidgetExtensions.setImageUrl(imageUrl);
  }
}
