import 'package:adhan_dart/adhan_dart.dart';

class AdhanTimes {
  final double latitude;
  final double longitude;

  AdhanTimes(this.latitude, this.longitude);

  PrayerTimes getPrayerTimes() {
    DateTime date = DateTime.now();
    Coordinates coordinates = Coordinates(latitude, longitude);
    CalculationParameters params = CalculationMethod.Turkey();
    double degree = Qibla.qibla(coordinates);
    print(degree);
    return PrayerTimes(
      coordinates,
      date,
      params,
    );
  }
}
