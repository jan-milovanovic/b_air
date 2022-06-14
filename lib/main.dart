import 'package:flutter/material.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:google_fonts/google_fonts.dart';

import 'login_page.dart';

Future<void> main() async {
  await JustAudioBackground.init(
    androidNotificationChannelId: 'com.ryanheise.bg_demo.channel.audio',
    androidNotificationChannelName: 'Audio playback',
    androidNotificationOngoing: true,
  );
  await Future.delayed(const Duration(seconds: 1));
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
      home: const LoginPage(),
    );
  }
}
