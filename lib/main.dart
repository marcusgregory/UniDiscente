import 'dart:convert';

import 'package:background_fetch/background_fetch.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'models/noticias.model.dart';
import 'pages/splash_screen.page.dart';
import 'repositories/noticias.repository.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

 Future<void> _showNotification(int numNoticias) async {

  var initializationSettingsAndroid = AndroidInitializationSettings('app_icon');
  var initializationSettingsIOS = IOSInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,);
  var initializationSettings = InitializationSettings(
      initializationSettingsAndroid, initializationSettingsIOS);
  await flutterLocalNotificationsPlugin.initialize(initializationSettings,
      onSelectNotification: (String payload) async {
    if (payload != null) {
      debugPrint('notification payload: ' + payload);
    }
  });
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'event_new_notice', 'Noticias','',
        importance: Importance.Max, priority: Priority.High, ticker: 'ticker');
    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
        0, 'Notícias', numNoticias<=1? '$numNoticias nova notícia foi postada no portal Unilab':'$numNoticias novas notícias foram postadas no portal Unilab', platformChannelSpecifics,
        payload: '');
  }
void backgroundFetchHeadlessTask(String taskId) async {
  print('[BackgroundFetch] evento recebido.');
  SharedPreferences prefs = await SharedPreferences.getInstance();
  List<NoticiaModel> noticiasAtuais = await NoticiasRepository().getAll();
  String noticiasPref = prefs.getString('noticias');
  List<NoticiaModel> noticiasNovas = [];
  if (noticiasPref != null) {
    Iterable noticias = jsonDecode(noticiasPref);
    List<NoticiaModel> noticiasAntigas =
        noticias.map((model) => NoticiaModel.fromJson(model)).toList();
    noticiasAntigas.forEach((i) => noticiasAtuais.remove(i));
    noticiasNovas = noticiasAtuais;
  }
  print(noticiasNovas.length);
  if (noticiasNovas.length > 0) {
    print('[BackgroundFetch] novas noticias.');
    _showNotification(noticiasNovas.length);
  }

  BackgroundFetch.finish(taskId);
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
  BackgroundFetch.registerHeadlessTask(backgroundFetchHeadlessTask);
  BackgroundFetch.configure(
      BackgroundFetchConfig(
          minimumFetchInterval: 15,
          stopOnTerminate: false,
          enableHeadless: true,
          requiresBatteryNotLow: false,
          startOnBoot: true,
          requiresCharging: false,
          requiresStorageNotLow: false,
          requiresDeviceIdle: false,
          requiredNetworkType: NetworkType.ANY),
      backgroundFetchHeadlessTask);
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'UniDiscente',
        theme: ThemeData(
            accentColor: Colors.teal[300],
            primaryColor: Color(0xFF00396A),
            backgroundColor: Colors.white),
        home: SplashPage());
  }
}
