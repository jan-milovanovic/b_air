import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:pediatko/authenticator.dart';
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

  DataProvider dataProvider = await DataProvider.create();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(MyApp(dataProvider: dataProvider));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key, required this.dataProvider}) : super(key: key);

  final DataProvider dataProvider;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => dataProvider,
      child: MaterialApp(
        //debugShowCheckedModeBanner: false,
        title: 'Pediatko',
        theme: ThemeData(
          primaryColor: const Color(0xff3fbbed),
          textTheme: GoogleFonts.ptSansTextTheme(Theme.of(context).textTheme),
        ),
        //darkTheme: ThemeData.dark(),
        home: const AuthenticatorPage(),
      ),
    );
  }
}
