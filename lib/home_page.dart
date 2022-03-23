import 'package:flutter/material.dart';
import 'pages/home.dart';
import 'pages/radio.dart';
import 'pages/contributors.dart';

import 'audio_data.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final screens = [
    const Home(),
    const RadioPlayer(
        audioData: AudioData(
            imageUrl:
                'https://media.wnyc.org/i/1400/1400/l/80/1/ScienceFriday_WNYCStudios_1400.jpg',
            title: "Radio Z",
            url:
                'https://di-br2e5p7r.a.eurovisionflow.net/radiodvr/otp/playlist.m3u8')),
    const Contributors()
  ]; // todo add 3rd

  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('B AIR'),
        centerTitle: true,
        backgroundColor: Colors.grey.shade400,
      ),
      body: screens[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (index) => setState(() => currentIndex = index),
        showSelectedLabels: false,
        showUnselectedLabels: false,
        //iconSize: 30,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.radio), label: 'Radio'),
          BottomNavigationBarItem(icon: Icon(Icons.light), label: '?'),
        ],
      ),
    );
  }
}
