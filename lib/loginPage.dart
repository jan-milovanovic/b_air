import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'homePage.dart';

class LoginPage extends StatelessWidget {
  LoginPage({Key? key}) : super(key: key);

  final inputFieldController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: CustomPaint(
        painter: Background(),
        child: Container(
          margin: const EdgeInsets.only(left: 30.0, right: 30.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: height * 0.2),
              welcomeText(),
              SizedBox(height: height * 0.1),
              inputField(inputFieldController),
              SizedBox(height: height * 0.33),
              Container(
                  padding: EdgeInsets.only(left: width * 0.6),
                  child: continueButton(inputFieldController.text, context)),
            ],
          ),
        ),
      ),
    );
  }
}

class Background extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final height = size.height;
    final width = size.width;
    Paint paint = Paint();

    Path bottomColor = Path();
    bottomColor.addRect(Rect.fromLTRB(0, height * 0.8, width, height));
    //Rect.fromLTRB(left, top, right, bottom)
    paint.color = Colors.grey.shade400;
    canvas.drawPath(bottomColor, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

RichText welcomeText() {
  return RichText(
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
    controller: inputFieldController,
    keyboardType: TextInputType.number,
    inputFormatters: <TextInputFormatter>[
      FilteringTextInputFormatter.allow(RegExp(r'[0-9]'))
    ],
    decoration: const InputDecoration(
        hintText: 'Vnesite aktivacijsko kodo', prefixIcon: Icon(Icons.key)),
  );
}

TextButton continueButton(String passcode, BuildContext context) {
  return TextButton(
    style: TextButton.styleFrom(
        primary: Colors.white,
        backgroundColor: Colors.blue.shade900,
        onSurface: Colors.black,
        minimumSize: const Size(70.0, 70.0)),
    child: Column(
      children: const [
        Icon(Icons.arrow_forward),
        Text('Vstop'),
      ],
    ),
    onPressed: () {
      checkValidAndProceed(passcode, context);
    },
  );
}

void checkValidAndProceed(String passcode, BuildContext context) {
  if (passcode == "1234") {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => const HomePage()));
  }
}
