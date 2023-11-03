import 'dart:async';

import 'package:adhan_dart/adhan_dart.dart';
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:namaz/adhan_times.dart';

class PrayerTimeNotifier with ChangeNotifier {
  Future<void> initializePrayerTimesToday() async {
    await getCurrentLocation(); // Bu metot prayerTimesToday'i başlatacaktır.
  }

  PrayerTimeNotifier() {
    getCurrentLocation();
  }
  Position? currentPosition2;
  String? currentAddress;
  // ignore: unused_field
  Timer? _timer;
  late List<DateTime> prayerTimesToday;
  Duration? durationUntilNextPrayer;
  String? hoursLeft;
  String? minutesLeft;
  String? secondsLeft;
  String? timeLeft;
  bool notificationSent = false;
  String? imsakTime;
  String? gunesTime;
  String? ogleTime;
  String? ikindiTime;
  String? aksamTime;
  String? yatsiTime;
  String? nextPrayerName;

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  // ... all your state and methods ...

  void startTimer() {
    print("starttimer fonksiyonu çağrıldı.");
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      DateTime now = DateTime.now();
      final result = timeUntilNextPrayer(now, prayerTimesToday);
      durationUntilNextPrayer = result['duration'] as Duration?;

      hoursLeft = durationUntilNextPrayer!.inHours.toString();
      minutesLeft = (durationUntilNextPrayer!.inMinutes % 60).toString();
      secondsLeft = (durationUntilNextPrayer!.inSeconds % 60).toString();
      nextPrayerName = result['prayerName'] as String;

      if (durationUntilNextPrayer != null) {
        timeLeft =
            "${durationUntilNextPrayer!.inHours} saat ${durationUntilNextPrayer!.inMinutes % 60} dakika ${durationUntilNextPrayer!.inSeconds % 60} saniye";
        // Eğer kalan süre 15 dakika veya daha az ise bildirim gönder
        if (durationUntilNextPrayer!.inMinutes <= 15 && !notificationSent) {
          showNotification("Namaz Vakti Yaklaşıyor",
              "$nextPrayerName, ${durationUntilNextPrayer!.inMinutes} dakika!");
          notificationSent = true;
        }
      } else {
        timeLeft = "Namaz vakti bilgisi alınamıyor.";
      }
      notifyListeners(); // Notify listeners of changes.
    });
  }

  Future<void> showNotification(String title, String body) async {
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'your channel id', 'your channel name',
        importance: Importance.max, priority: Priority.high, showWhen: false);

    var platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
    );
    await flutterLocalNotificationsPlugin
        .show(0, title, body, platformChannelSpecifics, payload: 'item x');
  }

  Map<String, dynamic> timeUntilNextPrayer(
      DateTime currentTime, List<DateTime> prayerTimes) {
    List<String> prayerNames = [
      "İmsak Vaktine Kalan Süre",
      "Sabah Namazına Kalan Süre",
      "Öğle Namazına Kalan Süre",
      "İkindi Namazına Kalan Süre",
      "Akşam Namazına Kalan Süre",
      "Yatsı Namazına Kalan Süre"
    ];
    for (int i = 0; i < prayerTimes.length; i++) {
      if (currentTime.isBefore(prayerTimes[i])) {
        return {
          'duration': prayerTimes[i].difference(currentTime),
          'prayerName': prayerNames[i]
        };
      }
    }
    return {
      'duration': prayerTimes[0].add(Duration(days: 1)).difference(currentTime),
      'prayerName': prayerNames[0]
    };
  }

  Future<void> getCurrentLocation() async {
    print("getCurrentLocation fonksiyonu çağrıldı.");
    final GeolocatorPlatform geolocator = GeolocatorPlatform.instance;
    final Position currentPosition = await geolocator.getCurrentPosition(
      locationSettings: LocationSettings(),
    );

    final List<Placemark> placemarks = await placemarkFromCoordinates(
      currentPosition.latitude,
      currentPosition.longitude,
    );

    final Placemark place = placemarks[0];
    DateTime now = DateTime.now();
    DateTime today = DateTime(now.year, now.month, now.day);

    currentPosition2 = currentPosition;
    currentAddress =
        "${place.administrativeArea},${place.subAdministrativeArea},${place.subLocality ?? place.locality}";

    AdhanTimes adhanTimes =
        AdhanTimes(currentPosition2!.latitude, currentPosition2!.longitude);
    PrayerTimes prayerTimes = adhanTimes.getPrayerTimes();
    imsakTime = DateFormat('HH:mm').format(prayerTimes.fajr!.toLocal());
    gunesTime = DateFormat('HH:mm').format(prayerTimes.sunrise!.toLocal());
    ogleTime = DateFormat('HH:mm').format(prayerTimes.dhuhr!.toLocal());
    ikindiTime = DateFormat('HH:mm').format(prayerTimes.asr!.toLocal());
    aksamTime = DateFormat('HH:mm').format(prayerTimes.maghrib!.toLocal());
    yatsiTime = DateFormat('HH:mm').format(prayerTimes.isha!.toLocal());

    prayerTimesToday = [
      DateTime(
          today.year,
          today.month,
          today.day,
          int.parse(imsakTime!.split(":")[0]),
          int.parse(imsakTime!.split(":")[1])),
      DateTime(
          today.year,
          today.month,
          today.day,
          int.parse(gunesTime!.split(":")[0]),
          int.parse(gunesTime!.split(":")[1])),
      DateTime(
          today.year,
          today.month,
          today.day,
          int.parse(ogleTime!.split(":")[0]),
          int.parse(ogleTime!.split(":")[1])),
      DateTime(
          today.year,
          today.month,
          today.day,
          int.parse(ikindiTime!.split(":")[0]),
          int.parse(ikindiTime!.split(":")[1])),
      DateTime(
          today.year,
          today.month,
          today.day,
          int.parse(aksamTime!.split(":")[0]),
          int.parse(aksamTime!.split(":")[1])),
      DateTime(
          today.year,
          today.month,
          today.day,
          int.parse(yatsiTime!.split(":")[0]),
          int.parse(yatsiTime!.split(":")[1])),
    ];

    final nextPrayerData = timeUntilNextPrayer(now, prayerTimesToday);
    print(nextPrayerData); // Bu satırı ekleyin
    durationUntilNextPrayer = nextPrayerData['duration'];
    hoursLeft = durationUntilNextPrayer!.inHours.toString();
    minutesLeft = (durationUntilNextPrayer!.inMinutes % 60).toString();
    secondsLeft = (durationUntilNextPrayer!.inSeconds % 60).toString();
    nextPrayerName = nextPrayerData['prayerName'];
    print("nextPrayerName: $nextPrayerName");

    timeLeft =
        "${durationUntilNextPrayer!.inHours} saat ${durationUntilNextPrayer!.inMinutes % 60} dakika";

    startTimer();

    notifyListeners();
  }

  Future<void> initializeAlarmManager() async {
    await AndroidAlarmManager.initialize();
  }
}
