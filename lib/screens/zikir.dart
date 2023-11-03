import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Zikir extends StatefulWidget {
  const Zikir({Key? key}) : super(key: key);

  @override
  State<Zikir> createState() => _ZikirState();
}

class _ZikirState extends State<Zikir> {
  int count = 0;

  @override
  void initState() {
    super.initState();
    _loadCount();
  }

  _loadCount() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      count = prefs.getInt('count') ?? 0;
    });
  }

  _incrementCount() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setInt('count', count + 1);
      print("SharedPreferences'a kaydedilen değer: ${count + 1}");

      setState(() {
        count++;
        print("Yeni count değeri: $count");
      });
    } catch (e) {
      print("Hata: $e");
    }
  }

  _resetCount() async {
    if (count == 0) {
      return;
    }
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Uyarı'),
          content: Text('Sayacı sıfırlamak istediğinize emin misiniz?'),
          actions: [
            TextButton(
              child: Text('Hayır'),
              onPressed: () {
                Navigator.of(context).pop(); // Dialog'u kapatır
              },
            ),
            TextButton(
              child: Text('Evet'),
              onPressed: () async {
                try {
                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  prefs.setInt('count', 0);
                  setState(() {
                    count = 0;
                  });
                } catch (e) {
                  print("Hata: $e");
                }
                Navigator.of(context).pop(); // Dialog'u kapatır
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Color(0xFF32465E),
      body: Column(
        children: [
          SizedBox(
            height: screenHeight * 0.1,
          ),
          Stack(
            // alignment: Alignment.center, // Stack'in merkezine göre hizalama
            children: [
              Container(
                height: screenHeight * 0.5,
                width: screenWidth * 0.99,
                child: Image.asset(
                  'assets/zikirmatik3.png',
                ),
              ),
              Positioned(
                top: screenHeight * 0.105,
                left: screenWidth * 0.31,
                child: Text(
                  "$count",
                  style: TextStyle(
                    fontSize: screenHeight * 0.09,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Positioned(
                top: screenHeight * 0.29,
                left: screenWidth * 0.35,
                child: Stack(children: [
                  InkWell(
                    onTap: () {
                      _incrementCount();
                    },
                    child: Container(
                      height: screenHeight * 0.15,
                      width: screenWidth * 0.3,
                      decoration: BoxDecoration(
                        color: Colors.blue, // Düğmenin rengini ayarlayın
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ]),
              ),
              Positioned(
                top: screenHeight * 0.242, // Örnek değer
                left: screenWidth * 0.23, // Örnek değer
                child: InkWell(
                  onTap: _resetCount,
                  child: Container(
                    height: screenHeight * 0.07,
                    width: screenWidth * 0.145,
                    decoration: BoxDecoration(
                      color: Color.fromARGB(255, 212, 113, 0),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
