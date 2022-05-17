import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:page_transition/page_transition.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:google_fonts/google_fonts.dart';

import 'login_page.dart';

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
      title: 'Pediatko',
      theme: ThemeData(
        primaryColor: const Color(0xff3fbbed),
        textTheme: GoogleFonts.ptSansTextTheme(Theme.of(context).textTheme),
      ),
      //darkTheme: ThemeData.dark(),
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
