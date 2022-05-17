import 'package:flutter/material.dart';
import 'pages/home.dart';
import 'pages/radio.dart';
import 'pages/webview.dart';

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
                'https://img.rtvslo.si/_up/upload/2020/04/30/65671496.jpg',
            title: 'Radio Z',
            titleDescription: 'this is a radio..',
            showName: 'Radio Z',
            showDescription: 'radio',
            url:
                'https://di-br2e5p7r.a.eurovisionflow.net/radiodvr/otp/playlist.m3u8')),
    const Webview()
  ];

  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    Color defaultColor = Theme.of(context).colorScheme.primary;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pediatko'),
        centerTitle: true,
        backgroundColor: defaultColor,
        elevation: 0,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(20),
          ),
        ),
      ),
      body: screens[currentIndex],
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(20),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black38,
              blurRadius: 5,
            )
          ],
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(20),
          ),
          child: BottomNavigationBar(
            currentIndex: currentIndex,
            onTap: (index) => setState(() => currentIndex = index),
            showSelectedLabels: false,
            showUnselectedLabels: false,
            elevation: 0,
            //iconSize: 30,
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
              BottomNavigationBarItem(icon: Icon(Icons.radio), label: 'Radio'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.info), label: 'Contributors'),
            ],
          ),
        ),
      ),
    );
  }
}
