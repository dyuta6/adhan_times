import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hijri/hijri_calendar.dart';
import 'package:intl/intl.dart';
import 'package:namaz/screens/namaz_vakitleri.dart';
import 'package:provider/provider.dart';

import '../prayer_time_notifier.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Timer? _timer;

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    super.initState();
    initializeNotification();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> initializeNotification() async {
    var initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    var initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
    );
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  List<String> hijriMonthsInTurkish = [
    'Muharrem',
    'Safer',
    'Rebiülevvel',
    'Rebiülahir',
    'Cemaziyelevvel',
    'Cemaziyelahir',
    'Recep',
    'Şaban',
    'Ramazan',
    'Şevval',
    'Zilkade',
    'Zilhicce'
  ];
  @override
  Widget build(BuildContext context) {
    final prayerTimeNotifier = Provider.of<PrayerTimeNotifier>(context);
    String? nextPrayer = prayerTimeNotifier.nextPrayerName;
    String? hours = prayerTimeNotifier.hoursLeft;
    String? minutes = prayerTimeNotifier.minutesLeft;
    String? seconds = prayerTimeNotifier.secondsLeft;
    late Position? currentp = prayerTimeNotifier.currentPosition2;
    String? currentA = prayerTimeNotifier.currentAddress;
    String? imsak = prayerTimeNotifier.imsakTime;
    String? gunes = prayerTimeNotifier.gunesTime;
    String? ogle = prayerTimeNotifier.ogleTime;
    String? ikindi = prayerTimeNotifier.ikindiTime;
    String? aksam = prayerTimeNotifier.aksamTime;
    String? yatsi = prayerTimeNotifier.yatsiTime;

    String getHijriDate(DateTime gregorianDate) {
      var hijri = HijriCalendar.fromDate(gregorianDate);
      String day = hijri.hDay.toString();
      String month = hijriMonthsInTurkish[
          hijri.hMonth - 1]; // Ayın Türkçe ismini alıyoruz.
      String year = hijri.hYear.toString();

      return "$day $month $year";
    }

    DateTime now = DateTime.now();
    String formattedDate = DateFormat('dd MMMM yyyy', 'tr_TR').format(now);
    //String formattedTime = DateFormat('HH:mm', 'tr_TR').format(now);
    return Scaffold(
      backgroundColor: Color(0xFF32465E),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
            height: kToolbarHeight + MediaQuery.of(context).padding.top,
            decoration: BoxDecoration(
              color: Color(0xFF212832),
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  spreadRadius: 1,
                  blurRadius: 10,
                  offset: Offset(0, 3),
                )
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Ezan Vakti Lite",
                  style: TextStyle(
                    fontSize: 20.0,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 15,
          ),
          Container(
            padding: EdgeInsets.only(top: 10),
            height: 60,
            width: MediaQuery.of(context).size.width * 0.75,
            decoration: BoxDecoration(
              color: Color(0xFF212832),
              borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(20), top: Radius.circular(20)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  spreadRadius: 1,
                  blurRadius: 10,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: Center(
              child: Column(
                children: [
                  Text(
                    "$formattedDate",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "${getHijriDate(now)}",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            padding: EdgeInsets.only(top: 19),
            height: 110,
            width: MediaQuery.of(context).size.width * 0.75,
            decoration: BoxDecoration(
              color: Color(0xFF212832),
              borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(30), top: Radius.circular(30)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  spreadRadius: 1,
                  blurRadius: 10,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: Center(
              child: Column(
                children: [
                  Text(
                    nextPrayer ?? "Bilgi yükleniyor...",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        children: [
                          Text(
                            "${hours ?? '00'}",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 30,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            "Saat",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Column(
                        children: [
                          Text(
                            "${minutes ?? '00'}",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 30,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            "Dakika",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Column(
                        children: [
                          Text(
                            "${seconds ?? '00'}",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 30,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            "Saniye",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: currentp != null
                ? NamazVakitleri(
                    currentAddress: currentA,
                    imsakTime: imsak,
                    gunesTime: gunes,
                    ogleTime: ogle,
                    ikindiTime: ikindi,
                    aksamTime: aksam,
                    yatsiTime: yatsi)
                : Center(
                    child: SizedBox(
                        width: 150,
                        height: 150,
                        child: CircularProgressIndicator()),
                  ),
          ),
        ],
      ),
    );
  }
}
