import 'package:b_air/pages/musicPlayer.dart';
import 'package:flutter/material.dart';

import 'pages/home.dart';
import 'pages/radio.dart';
import 'pages/contributors.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final screens = [
    const Home(),
    const MusicPlayer(url: "http://mp3.rtvslo.si/raz"),
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
