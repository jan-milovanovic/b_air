import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:page_transition/page_transition.dart';
import 'package:just_audio_background/just_audio_background.dart';

import 'loginPage.dart';

Future<void> main() async {
  await JustAudioBackground.init(
    androidNotificationChannelId: 'com.ryanheise.bg_demo.channel.audio',
    androidNotificationChannelName: 'Audio playback',
    androidNotificationOngoing: true,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'B AIR',
      theme: ThemeData(
        primaryColor: Colors.white,
        secondaryHeaderColor: Colors.blue.shade900,
        textTheme: Theme.of(context)
            .textTheme
            .apply(bodyColor: Colors.black, displayColor: Colors.blue.shade900),
      ),
      darkTheme: ThemeData.dark(),
      home: const SplashScreen(),
    );
  }
}

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      splash: Lottie.asset('assets/loading.json'),
      splashIconSize: 250,
      duration: 2000,
      splashTransition: SplashTransition.fadeTransition,
      pageTransitionType: PageTransitionType.bottomToTop,
      animationDuration: const Duration(seconds: 1),
      //disableNavigation: true,
      nextScreen: LoginPage(),
    );
  }
}
