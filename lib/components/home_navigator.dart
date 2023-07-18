import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:pediatko/constants/custom_dialogs.dart';
import 'package:pediatko/modals/data_provider.dart';
import 'package:pediatko/pages/home/home_page.dart';
import 'package:pediatko/pages/radio_player_page.dart';
import 'package:pediatko/pages/webview.dart';
import 'package:provider/provider.dart';

/// homepage contains the three main windows upon logging in:
/// Home -> grid of 6 recordings
/// Radio -> Live playing radio Z
/// Webview -> Page leading to a custom website
///
/// app bar and bottom navigation bar are shared between those windows
class HomeNavigator extends StatefulWidget {
  const HomeNavigator({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _HomeNavigatorState();
}

class _HomeNavigatorState extends State<HomeNavigator> {
  late final List<Widget> screens;

  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
    initializeDateFormatting();

    DataProvider dataProvider = context.read<DataProvider>();

    screens = [
      HomePage(showData: dataProvider.showList),
      RadioPlayerPage(radioData: dataProvider.radioData),
      Webview(url: dataProvider.infoPageUrl),
    ];
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Color primaryColor = Theme.of(context).primaryColor;

    return WillPopScope(
      onWillPop: () async {
        await showDialog(
            context: context,
            builder: (_) {
              return CustomDialogs.logoutDialog(context);
            });
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Image.asset('assets/pediatko-logo.png', height: 25),
          centerTitle: true,
          backgroundColor: primaryColor,
          elevation: 0,
          leadingWidth: 70,
          actions: [
            IconButton(
              icon: Image.asset(
                'assets/icons/ico-Logout.png',
                height: 25,
              ),
              onPressed: () => showDialog(
                context: context,
                builder: (_) {
                  return CustomDialogs.logoutDialog(context);
                },
              ),
            ),
          ],
          leading: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset('assets/rtvslo-logo.png'),
          ),
        ),
        backgroundColor: Colors.white,
        body: Container(
          color: primaryColor,
          child: ClipRRect(
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(20.0),
            ),
            child: screens[currentIndex],
          ),
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
              onTap: (index) => setState(() => currentIndex = index),
              showSelectedLabels: false,
              showUnselectedLabels: false,
              backgroundColor: Colors.white,
              elevation: 0,
              //iconSize: 30,
              items: [
                BottomNavigationBarItem(
                    icon: Image.asset(
                      'assets/icons/Home.png',
                      width: 40,
                    ),
                    activeIcon: Image.asset(
                      'assets/icons/Home-active.png',
                      width: 40,
                    ),
                    label: ''),
                BottomNavigationBarItem(
                    icon: Image.asset(
                      'assets/icons/V-zivo.png',
                      width: 40,
                    ),
                    activeIcon: Image.asset(
                      'assets/icons/V-zivo-active.png',
                      width: 40,
                    ),
                    label: ''),
                BottomNavigationBarItem(
                    icon: Image.asset(
                      'assets/icons/Info.png',
                      width: 40,
                    ),
                    activeIcon: Image.asset(
                      'assets/icons/Info-active.png',
                      width: 40,
                    ),
                    label: ''),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
