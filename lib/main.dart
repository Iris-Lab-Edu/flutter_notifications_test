import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:voice_rec/test_notifications.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final netflixUrl = "https://www.youtube.com/";
  String netflixKids = "Kids"; // Vai para a página do titulo (as informações)
  String netflixMovie = "watch?v=gr9N8Zkc4Z0"; //t= time in seconds t=1200
  String finalDeepUrl;

  final _myNotifications = MyNotifications();

  String deepUrl() {
    var httpsUrl = netflixUrl.split("https").last;

    return httpsUrl.replaceFirst('', 'youtube');
  }

  _launchUrl() async {
    if (await canLaunch(netflixUrl)) {
      try {
        finalDeepUrl = deepUrl();

        await launch(finalDeepUrl + netflixMovie);

        // await launch(finalDeepUrl + netflixMovie);
      } catch (e) {
        print("launching on browser" + e.message);

        await launch(netflixUrl + netflixMovie);
      }
    } else {
      throw 'Could not launch $netflixUrl';
    }

    await _myNotifications.showMessagingNotification();
  }

  @override
  void initState() {
    super.initState();

    _myNotifications.initializeNotifications();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Netflix DeepLinks',
      theme: ThemeData(
        buttonColor: Colors.amberAccent[400],
        primaryColor: Colors.red,
        primarySwatch: Colors.red,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Scaffold(
        body: openDeepLink(context),
      ),
    );
  }

  Widget openDeepLink(BuildContext context) {
    return Center(
      child: Container(
        child: RaisedButton.icon(
          padding: EdgeInsets.all(20.0),
          elevation: 10,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(30.0),
            ),
          ),
          icon: Icon(
            Icons.open_in_new,
            size: 28.0,
          ),
          label: Text(
            "Open Netflix movie",
            style: TextStyle(fontSize: 20.0),
          ),
          onPressed: () => _launchUrl(),
        ),
      ),
    );
  }
}

class StringTest {
  final netflixUrl = "https://www.netflix.com/";
  final netflixMovie = "title/80186863"; //81254224";
  String newUrl;

  void deepUrl() {
    var httpsUrl = netflixUrl.split("https").last;

    var deepUrl = httpsUrl.replaceFirst('', 'nflx');

    newUrl = deepUrl + netflixMovie;
  }
}
