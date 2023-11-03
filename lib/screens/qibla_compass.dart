import 'dart:math';

import 'package:adhan_dart/adhan_dart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:geolocator/geolocator.dart';

class QiblaCompass extends StatefulWidget {
  const QiblaCompass({Key? key}) : super(key: key);

  @override
  State<QiblaCompass> createState() => _QiblaCompassState();
}

class _QiblaCompassState extends State<QiblaCompass> {
  double _azimuth = 0;
  double? _latitude;
  double? _longitude;
  double? _qiblaDegree;

  @override
  void initState() {
    super.initState();
    FlutterCompass.events?.listen((CompassEvent event) {
      setState(() {
        _azimuth = event.heading ?? 0;
      });
    });
    _getCurrentLocation();
  }

  _getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      setState(() {
        _latitude = position.latitude;
        _longitude = position.longitude;
      });
    } catch (e) {
      print("Konum alınamadı: $e");
    }
  }

  double calculateRotation(double azimuth) {
    return azimuth * pi / 180;
  }

  double calculateQiblaDirection(double userLat, double userLon) {
    double kabaLat = 21.422524;
    double kabaLon = 39.826182;

    double dLon = (kabaLon - userLon);
    double y = sin(dLon) * cos(kabaLat);
    double x =
        cos(userLat) * sin(kabaLat) - sin(userLat) * cos(kabaLat) * cos(dLon);
    double brng = atan2(y, x);

    // Radyandan dereceye dönüştür
    double brngDeg = brng * (180.0 / pi);

    // Negatif sonuçları pozitif açıya dönüştür
    if (brngDeg < 0) {
      brngDeg = 360.0 + brngDeg;
    }

    return brngDeg;
  }

  @override
  Widget build(BuildContext context) {
    if (_latitude != null && _longitude != null) {
      Coordinates coordinates = Coordinates(_latitude!, _longitude!);
      _qiblaDegree = calculateQiblaDirection(_latitude!, _longitude!);
      // ...
    } else {
      // Eğer konum alınamazsa bir yedek içerik veya yükleniyor simgesi gösterebilirsiniz.
      return CircularProgressIndicator();
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final height = constraints.maxHeight;
        final width = constraints.maxWidth;
        double rotation = (_azimuth - _qiblaDegree! + 360) % 360;
        double radius = width / 2; // pusulanın yarı çapı
        double radian;
        if (_qiblaDegree != null) {
          radian = _qiblaDegree! * pi / 180;
        } else {
          // _qiblaDegree null olduğunda yapılacak işlemler
          radian = 0; // veya diğer bir varsayılan değer
        }
        double dx = radius * sin(radian); // yatay hareket
        double dy = -radius * cos(radian); // dikey hareket
        double factor = 0.8;
        double deviation = (_azimuth - _qiblaDegree! + 360) % 360;
        if (_qiblaDegree != null) {
          deviation = (_azimuth - _qiblaDegree! + 360) % 360;
        } else {
          // _qiblaDegree null olduğunda yapılacak işlemler
          deviation = _azimuth % 360; // Veya diğer bir varsayılan işlem
        }
        double deviationRadian = deviation * pi / 180;
        bool isCorrectDirection = deviation < 5 || deviation > 355;

        return Scaffold(
          backgroundColor: Color(0xFF32465E),
          body: Column(
            children: [
              Container(
                padding:
                    EdgeInsets.only(top: MediaQuery.of(context).padding.top),
                height: kToolbarHeight + MediaQuery.of(context).padding.top,
                decoration: BoxDecoration(
                  color: Color(0xFF212832),
                  borderRadius:
                      BorderRadius.vertical(bottom: Radius.circular(30)),
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
                      "Kıble Pusulası",
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
                height: width,
                width: width,
                child: Stack(
                  children: [
                    Align(
                      alignment: Alignment.topCenter,
                      child: Image(
                        image: AssetImage('assets/kible2.png'),
                        height: 150,
                        width: 150,
                      ),
                    ),
                    Transform.translate(
                      offset: Offset(0, 150),
                      child: Transform.rotate(
                        angle: calculateRotation(_qiblaDegree! - _azimuth),
                        child: Image(
                          image: AssetImage(
                            'assets/compass3.png',
                          ),
                          height: height / 2,
                          width: width,
                          color:
                              isCorrectDirection ? Colors.green : Colors.white,
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 0, // Aşağıdan 10 birim boşluk bırakıyoruz
                      left: 0,
                      right: 0,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Derece: ${_azimuth.toStringAsFixed(2)}°",
                            style: TextStyle(
                                color: Colors.yellow,
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            "Koordinat: ${_latitude?.toStringAsFixed(4) ?? 'N/A'}, ${_longitude?.toStringAsFixed(4) ?? 'N/A'}",
                            style: TextStyle(
                              color: Colors.yellow,
                              fontSize: 16.0,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
