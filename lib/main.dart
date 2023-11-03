import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:namaz/prayer_time_notifier.dart';
import 'package:namaz/screens/home_page.dart';
import 'package:namaz/screens/qiblah_screen.dart';
import 'package:namaz/screens/quran.dart';
import 'package:namaz/screens/zikir.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

@pragma('vm:entry-point')
void showPrayerTimeNotification() async {
  print("showPrayerTimeNotification çağrıldı");
  final DateTime now = DateTime.now();
  final notifier = PrayerTimeNotifier();
  await notifier.initializePrayerTimesToday();

  final Map<String, dynamic> nextPrayerData =
      notifier.timeUntilNextPrayer(now, notifier.prayerTimesToday);
  final DateTime nextPrayerTime =
      now.add(nextPrayerData['duration'] as Duration);

  if (now.isBefore(nextPrayerTime.add(Duration(minutes: 30)))) {
    await notifier.showNotification("Namaz Vakti Yaklaşıyor",
        "${notifier.nextPrayerName}, ${notifier.minutesLeft} dakika!");
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await requestPermissions();

  final prayerNotifier = PrayerTimeNotifier();

  await prayerNotifier.initializeAlarmManager();
  await prayerNotifier.initializePrayerTimesToday();
  await setPrayerTimeAlarm(prayerNotifier);

  runApp(
    ChangeNotifierProvider(
      create: (context) => prayerNotifier,
      child: MyApp(),
    ),
  );
}

Future<void> setPrayerTimeAlarm(PrayerTimeNotifier notifier) async {
  print("setPrayerTimeAlarm çağrıldı");
  await notifier.initializePrayerTimesToday();
  final DateTime now = DateTime.now();
  final Map<String, dynamic> nextPrayerData =
      notifier.timeUntilNextPrayer(now, notifier.prayerTimesToday);
  final Duration durationUntilNextPrayer =
      nextPrayerData['duration'] as Duration;
  final DateTime nextPrayerTime = now.add(durationUntilNextPrayer);
  print("Current time: $now");
  print("Next prayer time: $nextPrayerTime");
  print("Duration until next prayer: $durationUntilNextPrayer");

  try {
    final DateTime alarmTime = nextPrayerTime.subtract(Duration(minutes: 35));
    print("Calculated alarm time: $alarmTime");
    await AndroidAlarmManager.oneShotAt(
      alarmTime, // Alarmı tetikleyeceği zaman

      0, // alarm id
      showPrayerTimeNotification,
    );
    print("Alarm başarıyla ayarlandı: $alarmTime");
  } catch (e) {
    print("Alarm ayarlanırken hata oluştu: $e");
  }
}

Future<void> requestPermissions() async {
  // Konum izni durumunu kontrol et
  var status = await Permission.location.status;
  if (status.isDenied) {
    // İzin reddedilmişse, izin iste
    if (await Permission.location.request().isGranted) {
      // İzin verildi
      print("Konum izni verildi");
      // Burada konumla ilgili işlemleri başlatabilirsiniz
    } else {
      // Kullanıcı izni reddetti, uygulamanın fonksiyonelliği sınırlı olabilir
      print("Konum izni reddedildi");
      // Kullanıcıyı izin vermesi gerektiği konusunda bilgilendirin
    }
  } else if (status.isPermanentlyDenied) {
    // İzin kalıcı olarak reddedilmişse, ayarlar sayfasına yönlendirme yap
    openAppSettings();
  }
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  bool hasPermission = false;
  int _selectedIndex = 0;
  static List<Widget> _pages = <Widget>[
    MyHomePage(),
    QiblahScreen(),
    Zikir(),
    Quran(
      pageIndex: 0,
      imageIndex: 0,
    ),
  ];

  Future getPermission() async {
    if (await Permission.location.serviceStatus.isEnabled) {
      var status = await Permission.location.status;
      if (status.isGranted) {
        hasPermission = true;
      } else {
        Permission.location.request().then((value) {
          setState(() {
            hasPermission = (value == PermissionStatus.granted);
          });
        });
      }
      return true;
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        locale: Locale('tr', 'TR'),
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: [
          const Locale('tr', 'TR'), // <-- Ekleyin
        ],
        title: 'Ezan Vakti Lite',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: FutureBuilder(
          builder: (context, snapshot) {
            if (hasPermission) {
              return Scaffold(
                backgroundColor: Color(0xFF32465E),
                body: _pages.elementAt(_selectedIndex),
                bottomNavigationBar: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.vertical(
                        top: Radius.circular(30)), // Bu kısım
                    boxShadow: [
                      // Opsiyonel: Eğer bir gölge eklemek isterseniz
                      BoxShadow(
                          color: Colors.black38,
                          spreadRadius: 1,
                          blurRadius: 10),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(30)),
                    child: BottomNavigationBar(
                      type: BottomNavigationBarType
                          .shifting, // Bu satırı ekledim.
                      backgroundColor: Color(0xFF212832),
                      items: <BottomNavigationBarItem>[
                        BottomNavigationBarItem(
                          icon: Icon(Icons.home),
                          label: 'Ana Sayfa',
                          backgroundColor: Color(
                              0xFF212832), // Öğe arka plan rengi için bu satırı ekledim.
                        ),
                        BottomNavigationBarItem(
                          icon: Icon(FontAwesomeIcons.compass),
                          label: 'Kıble',
                          backgroundColor: Color(
                              0xFF212832), // Öğe arka plan rengi için bu satırı ekledim.
                        ),
                        BottomNavigationBarItem(
                          icon: Icon(Icons.fingerprint_sharp),
                          label: 'Zikir',
                          backgroundColor: Color(
                              0xFF212832), // Öğe arka plan rengi için bu satırı ekledim.
                        ),
                        BottomNavigationBarItem(
                          icon: Icon(FontAwesomeIcons.bookOpen),
                          label: 'Kur-an',
                          backgroundColor: Color(
                              0xFF212832), // Öğe arka plan rengi için bu satırı ekledim.
                        ),
                      ],
                      currentIndex: _selectedIndex,
                      selectedItemColor: Color.fromARGB(255, 245, 167, 115),
                      onTap: _onItemTapped,
                    ),
                  ),
                ),
              );
            } else {
              return const Scaffold(
                backgroundColor: Color.fromARGB(255, 48, 48, 48),
              );
            }
          },
          future: getPermission(),
        ));
  }
}
