import 'dart:io';
import 'package:flutter/services.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:awesome_notifications/awesome_notifications.dart';

class MyNotifications {
  final _notificationsPlugin = FlutterLocalNotificationsPlugin();

  final MethodChannel platform = MethodChannel('murilinhops/local_notifications_example');

  Future initializeNotifications() async {
    var initializationSettingsAndroid = AndroidInitializationSettings('app_icon');

    final initializationSettingsIOS = IOSInitializationSettings();

    final initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    await _notificationsPlugin.initialize(initializationSettings,
        onSelectNotification: _selectNotification);
  }

  Future _selectNotification(String payload) {
    if (payload != null) {
      debugPrint('notification payload (id, name...): $payload');
    }
  }

  displayMyNotification() async {
    tz.initializeTimeZones();

    final scheduledNotifcationTime = tz.TZDateTime.now(tz.local).add(const Duration(seconds: 5));

    final List<String> lines = <String>[
      'line <b>1</b> escrevendo mais coisas',
      'line <i>2</i>',
      'line <h3>3</h3> Escrevendo mais na linha 3'
    ];
    final inboxStyleInformation = InboxStyleInformation(lines,
        htmlFormatLines: true,
        contentTitle: 'overridden <b>inbox</b> plain title',
        htmlFormatContentTitle: true,
        summaryText: 'warn <i>text</i>',
        htmlFormatSummaryText: true);

    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'your channel id',
      'your channel name',
      'your channel description',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: false,
      enableVibration: true,
      fullScreenIntent: true,
      styleInformation: inboxStyleInformation,
    );

    var platformChannelSpecifics = NotificationDetails(android: androidPlatformChannelSpecifics);

    _notificationsPlugin.zonedSchedule(
        0, 'My Title', 'plain body', scheduledNotifcationTime, platformChannelSpecifics,
        uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
        androidAllowWhileIdle: true,
        payload: 'Parametro');
  }

  Future<void> showMessagingNotification() async {
    // use a platform channel to resolve an Android drawable resource to a URI.
    // This is NOT part of the notifications plugin. Calls made over this
    /// channel is handled by the app
    final String imageUri = await platform.invokeMethod('drawableToUri', 'food');

    /// First two person objects will use icons that part of the Android app's
    /// drawable resources
    const Person me = Person(
      name: 'Me',
      key: '1',
      uri: 'tel:1234567890',
      icon: DrawableResourceAndroidIcon('me'),
    );
    const Person coworker = Person(
      name: 'Coworker',
      key: '2',
      uri: 'tel:9876543210',
      icon: FlutterBitmapAssetAndroidIcon('assets/largeIcon.png'),
    );

    // download the icon that would be use for the lunch bot person
    final String largeIconPath =
        await _downloadAndSaveFile('http://via.placeholder.com/48x48', 'largeIcon');

    // this person object will use an icon that was downloaded
    final Person lunchBot = Person(
      name: 'Lunch bot',
      key: 'bot',
      bot: true,
      icon: BitmapFilePathAndroidIcon(largeIconPath),
    );

    final List<Message> messages = <Message>[
      Message('Hi', DateTime.now(), null),
      Message("What's up?", DateTime.now().add(const Duration(seconds: 5)), coworker),
      Message('Lunch?', DateTime.now().add(const Duration(seconds: 10)), null,
          dataMimeType: 'image/png', dataUri: imageUri),
      Message('What kind of food would you prefer?',
          DateTime.now().add(const Duration(seconds: 12)), lunchBot),
    ];

    final MessagingStyleInformation messagingStyle = MessagingStyleInformation(me,
        groupConversation: true,
        conversationTitle: 'Team lunch',
        htmlFormatContent: true,
        htmlFormatTitle: true,
        messages: messages);

    final AndroidNotificationDetails androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'message channel id', 'message channel name', 'message channel description',
        category: 'msg', styleInformation: messagingStyle);

    final NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    await _notificationsPlugin.show(0, 'message title', 'message body', platformChannelSpecifics);

    // wait 10 seconds and add another message to simulate another response
    await Future<void>.delayed(const Duration(seconds: 10), () async {
      messages.add(Message('Thai', DateTime.now().add(const Duration(seconds: 15)), null));
      await _notificationsPlugin.show(0, 'message title', 'message body', platformChannelSpecifics);
    });
  }

  Future<String> _downloadAndSaveFile(String url, String fileName) async {
    final Directory directory = await getApplicationDocumentsDirectory();
    final String filePath = '${directory.path}/$fileName';
    final http.Response response = await http.get(url);
    final File file = File(filePath);
    await file.writeAsBytes(response.bodyBytes);
    return filePath;
  }
}
