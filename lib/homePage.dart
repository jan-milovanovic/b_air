import 'package:flutter/material.dart';

import 'pages/home.dart';
import 'pages/radio.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final screens = [const Home(), const RadioZ()]; // todo add 3rd

  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('B AIR'),
        centerTitle: true,
        backgroundColor: Colors.grey.shade400,
        actions: [
          IconButton(
            icon: const Icon(Icons.circle),
            tooltip: 'Profile',
            onPressed: () {},
          )
        ],
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
