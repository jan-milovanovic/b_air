import 'package:flutter/material.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:pediatko/authenticator.dart';
import 'package:pediatko/constants/dialog.dart';
import 'package:pediatko/constants/functions.dart';
import 'package:pediatko/modals/data_provider.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

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
      debugShowCheckedModeBanner: false,
      title: 'Pediatko',
      theme: ThemeData(
        primaryColor: const Color(0xff3fbbed),
        textTheme: GoogleFonts.ptSansTextTheme(Theme.of(context).textTheme),
      ),
      //darkTheme: ThemeData.dark(),
      home: FutureBuilder<DataProvider>(
        future: DataProvider.create(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ChangeNotifierProvider(
              create: (_) => snapshot.data!,
              child: const AuthenticatorPage(),
            );
          }
          return loadingIndicator();
        },
      ),
    );
  }
}
