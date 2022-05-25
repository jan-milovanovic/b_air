import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'pages/home.dart';
import 'pages/radio.dart';
import 'pages/webview.dart';

import 'audio_data.dart';
import 'password_manager.dart';

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
  final PageController _pageController = PageController(initialPage: 0);

  @override
  void initState() {
    super.initState();
    initializeDateFormatting();
  }

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }

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
        leadingWidth: 70,
        leading: IconButton(
          icon: const Icon(Icons.logout_rounded),
          color: Colors.white,
          iconSize: 30,
          //padding: const EdgeInsets.only(left: 15),
          onPressed: () => showDialog(
            context: context,
            builder: (_) {
              return logoutDialog();
            },
          ),
        ),
      ),
      backgroundColor: Colors.white,
      body: PageView(
        controller: _pageController,
        onPageChanged: (newIndex) {
          setState(() {
            currentIndex = newIndex;
          });
        },
        children: screens,
      ),
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
            onTap: (index) {
              _pageController.animateToPage(index,
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.ease);
            },
            showSelectedLabels: false,
            showUnselectedLabels: false,
            elevation: 0,
            //iconSize: 30,
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.home), label: ''),
              BottomNavigationBarItem(icon: Icon(Icons.radio), label: ''),
              BottomNavigationBarItem(icon: Icon(Icons.info), label: ''),
            ],
          ),
        ),
      ),
    );
  }

  AlertDialog logoutDialog() {
    return AlertDialog(
      title: const Text('Ste prepričani?'),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(20),
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          passwordExpire(),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                child: const Text(
                  'Zapri',
                  style: TextStyle(color: Colors.grey),
                ),
                onPressed: () {
                  Navigator.pop(context); // close dialog
                },
              ),
              TextButton(
                child: const Text('Odjavi me'),
                onPressed: () {
                  storage.deletePassword();
                  Navigator.pop(context); // close dialog
                  Navigator.pop(context); // return to login screen
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Row passwordExpire() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text('Geslo poteče: '),
        FutureBuilder(
          future: storage.readPassword,
          builder: ((context, snapshot) {
            if (!snapshot.hasData) {
              return const Text('...');
            } else if (snapshot.hasError) {
              return Text('${snapshot.error}');
            } else {
              DateTime parseDT = DateTime.parse(snapshot.data.toString());
              var outputDate = DateFormat.yMMMd('sl').format(parseDT);

              return Text(
                outputDate,
                style: const TextStyle(fontWeight: FontWeight.bold),
              );
            }
          }),
        ),
      ],
    );
  }
}
