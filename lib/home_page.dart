import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'pages/home.dart';
import 'pages/radio.dart';
import 'pages/webview.dart';

import 'dialog.dart';
import 'preslikave.dart';

/// homepage contains the three main windows upon logging in:
/// Home -> grid of 6 recordings
/// Radio -> Live playing radio Z
/// Webview -> Page leading to a custom website
///
/// app bar and bottom navigation bar are shared between those windows
class HomePage extends StatefulWidget {
  const HomePage({Key? key, required this.preslikava}) : super(key: key);

  final Preslikave preslikava;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final List<Widget> screens;

  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
    initializeDateFormatting();

    screens = [
      Home(showData: widget.preslikava.showData),
      RadioPlayer(radioData: widget.preslikava.radioData),
      Webview(url: widget.preslikava.infoPageUrl),
    ];
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Color defaultColor = Theme.of(context).colorScheme.primary;

    return WillPopScope(
      onWillPop: () async {
        await showDialog(
            context: context,
            builder: (_) {
              return logoutDialog(context);
            });
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Image.asset('assets/pediatko-logo.png', height: 25),
          centerTitle: true,
          backgroundColor: defaultColor,
          elevation: 0,

          leadingWidth: 70,
          leading: IconButton(
            icon: const Icon(Icons.logout_rounded),
            color: Colors.white,
            iconSize: 30,
            //padding: const EdgeInsets.only(left: 15),
            onPressed: () => showDialog(
              context: context,
              builder: (_) {
                return logoutDialog(context);
              },
            ),
          ),
        ),
        backgroundColor: Colors.white,
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
              items: [
                BottomNavigationBarItem(icon: Image.asset('assets/icons/Home.png', width: 40,), activeIcon: Image.asset('assets/icons/Home-active.png', width: 40,), label: ''),
                BottomNavigationBarItem(icon: Image.asset('assets/icons/V-zivo.png', width: 40,), activeIcon: Image.asset('assets/icons/V-zivo-active.png', width: 40,), label: ''),
                BottomNavigationBarItem(icon: Image.asset('assets/icons/Info.png', width: 40,), activeIcon: Image.asset('assets/icons/Info-active.png', width: 40,), label: ''),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
