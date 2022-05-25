import 'dart:convert';

import 'package:pediatko/auth/secrets.dart' as secret;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

import 'password_manager.dart';

import 'home_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<LoginPage> {
  final inputFieldController = TextEditingController();

  late final Future<List> tokenList;

  bool checkValidDate(String? dateString) {
    if (dateString != null) {
      List<String> dateListString = dateString.split('-');
      List<int> dateList = dateListString.map(int.parse).toList();
      DateTime date = DateTime.utc(dateList[0], dateList[1], dateList[2]);
      if (DateTime.now().compareTo(date) < 0) {
        return true;
      }
    }
    return false;
  }

  Future<List> getPasswordTokens() async {
    final response = await http.get(Uri.parse(
        'https://api.rtvslo.si/preslikave/bair?client_id=${secret.storyClientId}&_=1653382464036'));

    if (response.statusCode == 200) {
      return jsonDecode(response.body)['response'];
    } else {
      throw Exception('Failed to load token data');
    }
  }

  void readCheckProceedPassword() async {
    try {
      String? dateExpire = await storage.readPassword;

      if (checkValidDate(dateExpire)) {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => const HomePage()));
      } else {
        storage.deletePassword();
      }
    } catch (e) {
      // TODO: display issue
    }
  }

  @override
  void initState() {
    super.initState();
    readCheckProceedPassword();
    tokenList = getPasswordTokens();
    inputFieldController.clear();
  }

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double heightResized = MediaQuery.of(context).viewInsets.bottom;
    Color defaultColor = Theme.of(context).colorScheme.primary;

    return Scaffold(
        backgroundColor: defaultColor,
        body: Column(
          children: [
            const Spacer(flex: 1),
            const Text('Pediatko',
                style: TextStyle(fontSize: 50, color: Colors.white)),
            const Spacer(flex: 1),
            Container(
              decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  color: Colors.white),
              margin: const EdgeInsets.fromLTRB(20, 0, 20, 0),
              padding: const EdgeInsets.all(20),
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                SizedBox(height: resized(heightResized) ? 20 : 0),
                //const Spacer(flex: 1),
                Icon(
                  Icons.lock,
                  size: 40,
                  color: defaultColor,
                ),
                SizedBox(height: resized(heightResized) ? 20 : 10),
                //const Spacer(flex: 1),
                welcomeText(),
                SizedBox(height: resized(heightResized) ? 40 : 20),
                //const Spacer(flex: 1),
                inputField(inputFieldController),
                SizedBox(height: resized(heightResized) ? 50 : 20),
                //const Spacer(flex: 1),
                continueButton(context),
                SizedBox(height: resized(heightResized) ? 20 : 0),
                //const Spacer(flex: 1),
              ]),
            ),
            const Spacer(flex: 1),
          ],
        ));
  }

  bool resized(double heightResized) {
    return heightResized == 0;
  }

  RichText welcomeText() {
    return RichText(
        textAlign: TextAlign.center,
        text: const TextSpan(
            style: TextStyle(fontSize: 24, color: Colors.black),
            children: <TextSpan>[
              TextSpan(text: 'Dobrodošli,\n'),
              TextSpan(
                  text: 'vse bo vredu :)',
                  style: TextStyle(fontWeight: FontWeight.bold)),
            ]));
  }

  TextField inputField(inputFieldController) {
    return TextField(
      textAlign: TextAlign.center,
      controller: inputFieldController,
      keyboardType: TextInputType.text,
      inputFormatters: <TextInputFormatter>[
        FilteringTextInputFormatter.allow(RegExp(r'[0-9a-zA-Z]'))
      ],
      decoration: const InputDecoration(
        hintText: 'Vnesite aktivacijsko kodo',
        suffixIcon: Icon(
          Icons.check_circle,
          size: 40,
          color: Color.fromARGB(50, 0, 0, 0),
        ),
        prefixIcon: Icon(
          Icons.check_box_outline_blank,
          color: Colors.white,
        ),
      ),
    );
  }

  TextButton continueButton(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(
        primary: Colors.white,
        backgroundColor: Theme.of(context).colorScheme.primary,
        onSurface: Colors.black,
        minimumSize: const Size(90.0, 90.0),
        shape: const CircleBorder(),
      ),
      child: const Icon(Icons.arrow_forward_rounded, size: 60),
      onPressed: () {
        login(context, inputFieldController.text);
      },
    );
  }

  Future<bool> checkValid(Future<List> tokenList, String password) {
    return tokenList.then((list) {
      for (var tokenData in list) {
        if (password == tokenData['token'] &&
            checkValidDate(tokenData['expires'])) {
          storage.writePassword = tokenData['expires'];
          return true;
        }
      }
      return false;
    });
  }

  void login(BuildContext context, String password) async {
    bool valid = await checkValid(tokenList, password);

    if (valid) {
      /*
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => const HomePage()));
          */
      Navigator.push(context, homePageAnimation());
    }
  }

  Route homePageAnimation() {
    return PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            const HomePage(),
        transitionDuration: const Duration(seconds: 1),
        reverseTransitionDuration: const Duration(milliseconds: 500),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        });
  }
}
