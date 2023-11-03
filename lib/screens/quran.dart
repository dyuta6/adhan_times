import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:namaz/screens/image_list.dart';

import 'audio_list.dart';

class Quran extends StatefulWidget {
  final int pageIndex;
  final int imageIndex;
  const Quran({
    Key? key,
    required this.pageIndex,
    required this.imageIndex,
  }) : super(key: key);

  @override
  State<Quran> createState() => _QuranState();
}

class _QuranState extends State<Quran> {
  late AudioPlayer player;
  bool isPlaying = false;
  late int _pageIndex;
  late int _imageIndex;

  @override
  void initState() {
    super.initState();
    _pageIndex = widget.pageIndex;
    _imageIndex = widget.imageIndex;
    player = AudioPlayer();
    player.setUrl(audioUrls[widget.pageIndex]);
  }

  String _formatDuration(Duration d) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    return "${twoDigits(d.inMinutes.remainder(60))}:${twoDigits(d.inSeconds.remainder(60))}";
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Color(0xFF32465E),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              height: screenHeight * 0.05,
            ),
            Container(
              width: 400, // istediğiniz genişlik
              height: screenHeight * 0.61, // istediğiniz yükseklik
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: CachedNetworkImageProvider(imageUrls[_imageIndex]),
                  fit: BoxFit.fill, // resmi container'a sığdırmak için
                ),
              ),
              child: CachedNetworkImage(
                imageUrl: imageUrls[_imageIndex],
                placeholder: (context, url) =>
                    Center(child: CircularProgressIndicator()),
                errorWidget: (context, url, error) => Icon(Icons.error),
                fit: BoxFit.fill,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  style: ButtonStyle(),
                  onPressed: () async {
                    if (!isPlaying) {
                      if (player.position == player.duration) {
                        await player.seek(Duration.zero);
                      }
                      player.play();
                      setState(() {
                        isPlaying = true;
                      });
                    } else {
                      player.pause();
                      setState(() {
                        isPlaying = false;
                      });
                    }
                  },
                  child: Icon(isPlaying ? Icons.pause : Icons.play_arrow),
                ),
                SizedBox(width: 20),
                ElevatedButton(
                  onPressed: () async {
                    await player.seek(Duration.zero);
                    if (isPlaying) {
                      player.pause();
                    }
                    setState(() {
                      isPlaying = false;
                    });
                  },
                  child: Icon(
                    Icons.stop,
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            StreamBuilder<Duration?>(
                stream: player.durationStream,
                builder: (context, snapshot) {
                  final duration = snapshot.data ?? Duration.zero;
                  return StreamBuilder<Duration>(
                    stream: player.positionStream,
                    builder: (context, snapshot) {
                      var position = snapshot.data ?? Duration.zero;
                      if (position > duration) {
                        position = duration;
                      }
                      return Text(
                        '${_formatDuration(position)} / ${_formatDuration(duration)}',
                        style: TextStyle(color: Colors.white),
                      );
                    },
                  );
                }),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _pageIndex != 0
                    ? GestureDetector(
                        onTap: () {
                          setState(() {
                            _pageIndex--;
                            _imageIndex--;
                            player.setUrl(audioUrls[
                                _pageIndex]); // Audio URL'ini de güncelliyoruz
                          });
                        },
                        child: Column(
                          children: [
                            Icon(
                              Icons.arrow_back_ios,
                              color: Colors.white,
                              size: 40,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              "Önceki Sayfa",
                              style: TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                      )
                    : Column(
                        children: [
                          Icon(
                            Icons.arrow_back_ios,
                            color: Colors.transparent,
                            size: 40,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            "Önceki Sayfa",
                            style: TextStyle(color: Colors.transparent),
                          ),
                        ],
                      ),
                SizedBox(
                  width: 70,
                ),
                Column(
                  children: [
                    Text(
                      "${_pageIndex + 1}.Sayfa",
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ],
                ),
                SizedBox(
                  width: 75,
                ),
                (_pageIndex < audioUrls.length - 1 && _pageIndex != 603)
                    ? GestureDetector(
                        onTap: () {
                          setState(() {
                            _pageIndex++;
                            _imageIndex++;
                            player.setUrl(audioUrls[
                                _pageIndex]); // Audio URL'ini de güncelliyoruz
                          });
                        },
                        child: Column(
                          children: [
                            Icon(
                              Icons.arrow_forward_ios,
                              color: Colors.white,
                              size: 40,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              "Sonraki Sayfa",
                              style: TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                      )
                    : Column(
                        children: [
                          Icon(
                            Icons.arrow_forward_ios,
                            color: Colors.transparent,
                            size: 40,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            "Sonraki Sayfa",
                            style: TextStyle(color: Colors.transparent),
                          ),
                        ],
                      ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      if (_pageIndex > 49 && _pageIndex <= 99) {
                        _pageIndex = 0;
                        _imageIndex = 0;
                        player.setUrl(audioUrls[_pageIndex]);
                      } else if (_pageIndex > 99 && _pageIndex <= 149) {
                        _pageIndex = 50;
                        _imageIndex = 50;
                        player.setUrl(audioUrls[_pageIndex]);
                      } else if (_pageIndex > 149 && _pageIndex <= 199) {
                        _pageIndex = 100;
                        _imageIndex = 100;
                        player.setUrl(audioUrls[_pageIndex]);
                      } else if (_pageIndex > 199 && _pageIndex <= 249) {
                        _pageIndex = 150;
                        _imageIndex = 150;
                        player.setUrl(audioUrls[_pageIndex]);
                      } else if (_pageIndex > 249 && _pageIndex <= 299) {
                        _pageIndex = 200;
                        _imageIndex = 200;
                        player.setUrl(audioUrls[_pageIndex]);
                      } else if (_pageIndex > 299 && _pageIndex <= 349) {
                        _pageIndex = 250;
                        _imageIndex = 250;
                        player.setUrl(audioUrls[_pageIndex]);
                      } else if (_pageIndex > 349 && _pageIndex <= 399) {
                        _pageIndex = 300;
                        _imageIndex = 300;
                        player.setUrl(audioUrls[_pageIndex]);
                      } else if (_pageIndex > 399 && _pageIndex <= 449) {
                        _pageIndex = 350;
                        _imageIndex = 350;
                        player.setUrl(audioUrls[_pageIndex]);
                      } else if (_pageIndex > 449 && _pageIndex <= 499) {
                        _pageIndex = 400;
                        _imageIndex = 400;
                        player.setUrl(audioUrls[_pageIndex]);
                      } else if (_pageIndex > 499 && _pageIndex <= 549) {
                        _pageIndex = 450;
                        _imageIndex = 450;
                        player.setUrl(audioUrls[_pageIndex]);
                      } else if (_pageIndex > 549 && _pageIndex <= 603) {
                        _pageIndex = 500;
                        _imageIndex = 500;
                        player.setUrl(audioUrls[_pageIndex]);
                      }
                    });
                  },
                  child: Icon(
                    Icons.arrow_back_ios,
                    color: Colors.white,
                  ),
                ),
                Text(
                  _pageIndex < 50
                      ? "1-50"
                      : (_pageIndex >= 50 && _pageIndex < 100)
                          ? "51-100"
                          : (_pageIndex >= 100 && _pageIndex < 150)
                              ? "101-150"
                              : (_pageIndex >= 150 && _pageIndex < 200)
                                  ? "151-200"
                                  : (_pageIndex >= 200 && _pageIndex < 250)
                                      ? "201-250"
                                      : (_pageIndex >= 250 && _pageIndex < 300)
                                          ? "251-300"
                                          : (_pageIndex >= 300 &&
                                                  _pageIndex < 350)
                                              ? "301-350"
                                              : (_pageIndex >= 350 &&
                                                      _pageIndex < 400)
                                                  ? "351-400"
                                                  : (_pageIndex >= 400 &&
                                                          _pageIndex < 450)
                                                      ? "401-450"
                                                      : (_pageIndex >= 450 &&
                                                              _pageIndex < 500)
                                                          ? "451-500"
                                                          : (_pageIndex >=
                                                                      500 &&
                                                                  _pageIndex <
                                                                      550)
                                                              ? "501-550"
                                                              : (_pageIndex >=
                                                                      550)
                                                                  ? "551-604"
                                                                  : "Unknown", // Bu durum asla gerçekleşmemeli, ancak her ihtimale karşı ekledik
                  style: TextStyle(color: Colors.white),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      if (_pageIndex < 50) {
                        _pageIndex = 50;
                        _imageIndex = 50;
                        player.setUrl(audioUrls[_pageIndex]);
                      } else if (_pageIndex >= 50 && _pageIndex < 100) {
                        _pageIndex = 100;
                        _imageIndex = 100;
                      } else if (_pageIndex >= 100 && _pageIndex < 150) {
                        _pageIndex = 150;
                        _imageIndex = 150;
                      } else if (_pageIndex >= 150 && _pageIndex < 200) {
                        _pageIndex = 200;
                        _imageIndex = 200;
                      } else if (_pageIndex >= 200 && _pageIndex < 250) {
                        _pageIndex = 250;
                        _imageIndex = 250;
                      } else if (_pageIndex >= 250 && _pageIndex < 300) {
                        _pageIndex = 300;
                        _imageIndex = 300;
                      } else if (_pageIndex >= 300 && _pageIndex < 350) {
                        _pageIndex = 350;
                        _imageIndex = 350;
                      } else if (_pageIndex >= 350 && _pageIndex < 400) {
                        _pageIndex = 400;
                        _imageIndex = 400;
                      } else if (_pageIndex >= 400 && _pageIndex < 450) {
                        _pageIndex = 450;
                        _imageIndex = 450;
                      } else if (_pageIndex >= 450 && _pageIndex < 500) {
                        _pageIndex = 500;
                        _imageIndex = 500;
                      } else if (_pageIndex >= 500 && _pageIndex < 550) {
                        _pageIndex = 550;
                        _imageIndex = 550;
                      } else if (_pageIndex >= 550 && _pageIndex < 603) {
                        _pageIndex = 603;
                        _imageIndex = 603;
                      }
                      // İstediğiniz diğer koşulları da ekleyebilirsiniz
                    });
                  },
                  child: Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }
}
