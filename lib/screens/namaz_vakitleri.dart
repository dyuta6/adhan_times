import 'package:flutter/material.dart';

class NamazVakitleri extends StatelessWidget {
  final currentAddress;
  final imsakTime;
  final gunesTime;
  final ogleTime;
  final ikindiTime;
  final aksamTime;
  final yatsiTime;
  const NamazVakitleri({
    required this.currentAddress,
    required this.imsakTime,
    required this.gunesTime,
    required this.ogleTime,
    required this.ikindiTime,
    required this.aksamTime,
    required this.yatsiTime,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: 310,
            padding: EdgeInsets.all(20),
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
            child: Column(
              children: [
                Text(
                  '${currentAddress ?? "Bilinmiyor"}',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
                Text(
                  'Namaz Vakitleri',
                  style: TextStyle(color: Colors.white),
                ),
                SizedBox(
                  height: 10,
                ),
                imsakTime != null
                    ? Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Image.asset(
                                "assets/fajr2.png",
                                width: 14,
                                height: 14,
                                color: Color(0xFFF3A26D),
                              ),
                              Text(
                                "İmsak",
                                style: TextStyle(color: Colors.white),
                              ),
                              Text(
                                '${imsakTime ?? "Bilinmiyor"}',
                                style: TextStyle(color: Colors.white),
                              ),
                            ],
                          ),
                          Divider(
                            color: Colors.white,
                            thickness: 1.0,
                          )
                        ],
                      )
                    : SizedBox(
                        width: 14,
                        height: 14,
                        child: CircularProgressIndicator()),
                SizedBox(
                  height: 10,
                ),
                gunesTime != null
                    ? Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Image.asset(
                                "assets/weather-sunset-up.png",
                                width: 14,
                                height: 14,
                                color: Color(0xFFF3A26D),
                              ),
                              Text(
                                "Güneş",
                                style: TextStyle(color: Colors.white),
                              ),
                              Text(
                                '${gunesTime ?? "Bilinmiyor"}',
                                style: TextStyle(color: Colors.white),
                              ),
                            ],
                          ),
                          Divider(
                            color: Colors.white,
                            thickness: 1.0,
                          )
                        ],
                      )
                    : SizedBox(
                        width: 14,
                        height: 14,
                        child: CircularProgressIndicator()),
                SizedBox(
                  height: 10,
                ),
                ogleTime != null
                    ? Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Image.asset(
                                "assets/asr.png",
                                width: 14,
                                height: 14,
                                color: Color(0xFFF3A26D),
                              ),
                              Text(
                                "Öğle",
                                style: TextStyle(color: Colors.white),
                              ),
                              Text(
                                '${ogleTime ?? "Bilinmiyor"}',
                                style: TextStyle(color: Colors.white),
                              ),
                            ],
                          ),
                          Divider(
                            color: Colors.white,
                            thickness: 1.0,
                          )
                        ],
                      )
                    : SizedBox(
                        width: 14,
                        height: 14,
                        child: CircularProgressIndicator()),
                SizedBox(
                  height: 10,
                ),
                ikindiTime != null
                    ? Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Image.asset(
                                "assets/magrib.png",
                                width: 14,
                                height: 14,
                                color: Color(0xFFF3A26D),
                              ),
                              Text(
                                "İkindi",
                                style: TextStyle(color: Colors.white),
                              ),
                              Text(
                                '${ikindiTime ?? "Bilinmiyor"}',
                                style: TextStyle(color: Colors.white),
                              ),
                            ],
                          ),
                          Divider(
                            color: Colors.white,
                            thickness: 1.0,
                          )
                        ],
                      )
                    : SizedBox(
                        width: 14,
                        height: 14,
                        child: CircularProgressIndicator()),
                SizedBox(
                  height: 10,
                ),
                aksamTime != null
                    ? Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Image.asset(
                                "assets/sunset.png",
                                width: 14,
                                height: 14,
                                color: Color(0xFFF3A26D),
                              ),
                              Text(
                                "Akşam",
                                style: TextStyle(color: Colors.white),
                              ),
                              Text(
                                '${aksamTime ?? "Bilinmiyor"}',
                                style: TextStyle(color: Colors.white),
                              ),
                            ],
                          ),
                          Divider(
                            color: Colors.white,
                            thickness: 1.0,
                          ),
                        ],
                      )
                    : SizedBox(
                        width: 14,
                        height: 14,
                        child: CircularProgressIndicator()),
                SizedBox(
                  height: 10,
                ),
                yatsiTime != null
                    ? Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Image.asset(
                                "assets/moon.png",
                                width: 14,
                                height: 14,
                                color: Color(0xFFF3A26D),
                              ),
                              Text(
                                "Yatsı",
                                style: TextStyle(color: Colors.white),
                              ),
                              Text(
                                '${yatsiTime ?? "Bilinmiyor"}',
                                style: TextStyle(color: Colors.white),
                              ),
                            ],
                          ),
                        ],
                      )
                    : SizedBox(
                        width: 14,
                        height: 14,
                        child: CircularProgressIndicator()),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
