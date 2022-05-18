import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'home_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<LoginPage> {
  final inputFieldController = TextEditingController();

  final storage = const FlutterSecureStorage();

  void writePasswordStorage(String pwdString) async {
    await storage.write(key: 'password', value: pwdString);
  }

  void readCheckProceedPassword() async {
    try {
      String? pwdString = await storage.read(key: 'password');

      if (pwdString != null) {
        List<String> pwdListString = pwdString.split('-');
        List<int> pwdList = pwdListString.map(int.parse).toList();
        DateTime pwdDate = DateTime.utc(pwdList[0], pwdList[1], pwdList[2]);
        if (DateTime.now().compareTo(pwdDate) < 0) {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const HomePage()));
        } else {
          deletePasswordStorage();
        }
      } else {
        return;
      }
    } catch (e) {
      // TODO: display issue
    }
  }

  void deletePasswordStorage() async {
    await storage.delete(key: 'password');
  }

  @override
  void initState() {
    super.initState();
    readCheckProceedPassword();
  }

  @override
  Widget build(BuildContext context) {
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
              child: Column(children: [
                const SizedBox(height: 20),
                Icon(
                  Icons.lock,
                  size: 40,
                  color: defaultColor,
                ),
                const SizedBox(height: 20),
                welcomeText(),
                const SizedBox(height: 40),
                inputField(inputFieldController),
                const SizedBox(height: 50),
                continueButton(context),
                const SizedBox(height: 20),
              ]),
            ),
            const Spacer(flex: 1),
          ],
        ));
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
      keyboardType: TextInputType.number,
      inputFormatters: <TextInputFormatter>[
        FilteringTextInputFormatter.allow(RegExp(r'[0-9]'))
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
        checkValidAndProceed(context, inputFieldController.text);
      },
    );
  }

  void checkValidAndProceed(BuildContext context, String password) {
    //1234:2022-05-19
    //2345:2022-05-25

    String time = '2022-05-19';

    if (password == '1234') {
      // two solutions:
      // 1: write date of expirations and user has to login afterwards
      // 2: write password and check password every time upon app start
      writePasswordStorage(time);

      Navigator.push(
          context, MaterialPageRoute(builder: (context) => const HomePage()));
    }
  }
}
