import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'home_page.dart';

class LoginPage extends StatelessWidget {
  LoginPage({Key? key}) : super(key: key);

  final inputFieldController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;

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
        checkValidAndProceed(context);
      },
    );
  }

  void checkValidAndProceed(BuildContext context) {
    if (inputFieldController.text == "1234") {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => const HomePage()));
    }
  }
}
