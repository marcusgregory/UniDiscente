/* Init Flutter Local Notification */
//================================================================================
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
const initializationSettingsAndroid = AndroidInitializationSettings('app_icon');
const initializationSettingsIOS = IOSInitializationSettings();
const initializationSettings = InitializationSettings(
    initializationSettingsAndroid, initializationSettingsIOS);
//================================================================================

void initNotification() async {
  await flutterLocalNotificationsPlugin.initialize(initializationSettings,
      onSelectNotification: (String payload) async {
    if (payload != null) {
      print('notification payload: ' + payload);
    }
  });
}

Future<void> showNotification(int numNoticias) async {
  var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'event_new_notice', 'Noticias', '',
      importance: Importance.Max, priority: Priority.High, ticker: 'ticker');
  var iOSPlatformChannelSpecifics = IOSNotificationDetails();
  var platformChannelSpecifics = NotificationDetails(
      androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
  await flutterLocalNotificationsPlugin.show(
      0,
      numNoticias <= 1 ? 'Nova Notícia' : 'Novas Notícias',
      numNoticias <= 1
          ? '$numNoticias nova notícia foi postada no portal Unilab.'
          : '$numNoticias novas notícias foram postadas no portal Unilab.',
      platformChannelSpecifics,
      payload: '');
}
