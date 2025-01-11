import 'package:akemha/core/utils/dbg_print.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class FirebaseApi {
  final _firebaseMessaging = FirebaseMessaging.instance;
  // final _androidChannel = const AndroidNotificationChannel(
  //   "high_importance_channel",
  //   "High_Importance_Notifications",
  //   description: "This channel is used for important notifications.",
  //   importance:Importance.defaultImportance
  // );

  Future<void> handelBackgroundMessage(RemoteMessage message) async {
    dbg("Handling a background message: ${message.messageId}");
    dbg("Title: ${message.notification?.title}");
    dbg("Body: ${message.notification?.body}");
    dbg("Payload: ${message.data}");
  }

  Future<void> handelMessage(RemoteMessage? message) async {
    if (message == null) return;
    // TODO: navigate to the notification message
    dbg("Handling a background message: ${message.messageId}");
    dbg("Title: ${message.notification?.title}");
    dbg("Body: ${message.notification?.body}");
    dbg("Payload: ${message.data}");
  }

  Future<void> initPushNotifications() async {
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
    FirebaseMessaging.instance.getInitialMessage().then(handelMessage);
    FirebaseMessaging.onMessageOpenedApp.listen(handelMessage);
    FirebaseMessaging.onBackgroundMessage(handelBackgroundMessage);
  }

  Future<void> initNotifications() async {
    await _firebaseMessaging.requestPermission();
    final token = await _firebaseMessaging.getToken();
    fcmToken = token ?? '';
    dbg("FCM Token $token");
    dbg("FCM Token $fcmToken");
    initPushNotifications();
  }

  static  String fcmToken = 'string';
}
