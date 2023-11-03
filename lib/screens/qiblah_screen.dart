import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_qiblah/flutter_qiblah.dart';

class QiblahScreen extends StatefulWidget {
  const QiblahScreen({Key? key}) : super(key: key);

  @override
  State<QiblahScreen> createState() => _QiblahScreenState();
}

Animation<double>? animation;
AnimationController? _animationController;
double begin = 0.0;

class _QiblahScreenState extends State<QiblahScreen>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    _animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500));
    animation = Tween(begin: 0.0, end: 0.0).animate(_animationController!);
    super.initState();
  }

  static const epsilon = 0.01;

  bool areApproximatelyEqual(double a, double b) {
    return (a - b).abs() < epsilon;
  }

  bool isPointingToQiblah(double currentValue, double targetValue) {
    return (currentValue - targetValue).abs() < epsilon;
  }

  @override
  void dispose() {
    _animationController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color(0xFF32465E),
        body: StreamBuilder<QiblahDirection>(
          stream: FlutterQiblah.qiblahStream,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Container(
                alignment: Alignment.center,
                child: Center(
                  child: SizedBox(
                      width: 150,
                      height: 150,
                      child: CircularProgressIndicator()),
                ),
              );
            }

            final qiblahDirection = snapshot.data;
            animation = Tween<double>(
                    begin: begin,
                    end: (qiblahDirection!.qiblah * (pi / 180) * -1))
                .animate(_animationController!);

            begin = (qiblahDirection.qiblah * (pi / 180) * -1);
            _animationController!.forward(from: 0);

            return Center(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image(
                      height: 65,
                      width: 65,
                      image: AssetImage(
                        'assets/kible2.png',
                      ),
                    ),
                    SizedBox(
                      height: 300,
                      child: AnimatedBuilder(
                        animation: animation!,
                        builder: (context, child) => Column(
                          children: [
                            Transform.rotate(
                              angle: animation!.value,
                              child: Image.asset(
                                'assets/compass3.png',
                                color: Colors.white,
                                scale: 1.9,
                              ),
                            ),
                            // Text("Animation Value: ${animation!.value.toStringAsFixed(2)}",style: TextStyle(color: Colors.white)),
                          ],
                        ),
                      ),
                    ),
                    Text(
                      "${qiblahDirection.direction.toInt()}°",
                      style: const TextStyle(color: Colors.white, fontSize: 24),
                    ),
                  ]),
            );
          },
        ),
      ),
    );
  }
}
