import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

import 'password_manager.dart';

import 'preslikave.dart';
import 'home_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<LoginPage> with SingleTickerProviderStateMixin {
  final inputFieldController = TextEditingController();

  late AnimationController _checkmarkController;

  late Future<Preslikave> preslikava;

  /// checkmark icon in input field
  /// 0 = neutral, 1 = success, 2 = invalid (login)
  int checkStateIndex = 0;
  List<Icon> checkState = const [
    Icon(
      Icons.check_circle,
      size: 40,
      color: Color.fromARGB(50, 0, 0, 0),
    ),
    Icon(
      Icons.check_circle,
      size: 40,
      color: Color.fromARGB(200, 0, 150, 0),
    ),
    Icon(
      Icons.check_circle,
      size: 40,
      color: Color.fromARGB(200, 255, 0, 0),
    ),
  ];

  /// return true or false when checking:
  /// if current date is less than expire date of currently used passcode
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

  /// checks is given passcode has not yet expired
  /// if valid, proceed to next window (homepage)
  /// if password is not valid, delete it from the storage, stay at login page
  void readCheckProceedPassword() async {
    try {
      String? dateExpire = await storage.readPassword;

      if (checkValidDate(dateExpire)) {
        preslikava.then(
          (value) => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => HomePage(
                preslikava: value,
              ),
            ),
          ),
        );
      } else {
        storage.deletePassword();
      }
    } catch (e) {
      throw Exception('Password read/write issue');
    }
  }

  @override
  void initState() {
    super.initState();
    preslikava = getTransformation(context);
    readCheckProceedPassword();
    inputFieldController.clear();

    _checkmarkController = AnimationController(
        duration: const Duration(milliseconds: 500), vsync: this);

    Future.delayed(const Duration(seconds: 1))
        .then((value) => FlutterNativeSplash.remove());
  }

  @override
  Widget build(BuildContext context) {
    final double heightResized = MediaQuery.of(context).viewInsets.bottom;
    Color defaultColor = Theme.of(context).colorScheme.primary;

    return Scaffold(
      backgroundColor: defaultColor,
      body: Column(
        children: [
          const Spacer(flex: 1),
          Image.asset('assets/pediatko-logo.png', height: 50),
          const Spacer(flex: 1),
          Container(
            decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(20)),
                color: Colors.white),
            margin: const EdgeInsets.fromLTRB(20, 0, 20, 0),
            padding: const EdgeInsets.all(20),
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              SizedBox(height: heightResized == 0 ? 20 : 0),
              Icon(
                Icons.lock,
                size: 40,
                color: defaultColor,
              ),
              SizedBox(height: heightResized == 0 ? 20 : 10),
              welcomeText(),
              SizedBox(height: heightResized == 0 ? 40 : 20),
              inputField(inputFieldController),
              SizedBox(height: heightResized == 0 ? 50 : 20),
              continueButton(context),
              SizedBox(height: heightResized == 0 ? 20 : 0),
            ]),
          ),
          const Spacer(flex: 1),
        ],
      ),
    );
  }

  /// displays a multiline welcome text
  /// this is necessary due to different text styles between rows
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
        ],
      ),
    );
  }

  /// number type input field, accepts only number input
  /// also includes the suffix and prefix icons
  /// both are (necessary?) for "centering" text
  TextField inputField(inputFieldController) {
    return TextField(
      textAlign: TextAlign.center,
      controller: inputFieldController,
      keyboardType: TextInputType.number,
      inputFormatters: <TextInputFormatter>[
        FilteringTextInputFormatter.allow(RegExp(r'[0-9]'))
      ],
      decoration: InputDecoration(
        hintText: 'Vnesite aktivacijsko kodo',
        suffixIcon: animatedCheckIcon(),
        prefixIcon: const Icon(
          Icons.check_box_outline_blank,
          color: Colors.white,
        ),
      ),
    );
  }

  TextButton continueButton(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: Theme.of(context).colorScheme.primary,
        minimumSize: const Size(90.0, 90.0),
        shape: const CircleBorder(),
      ),
      child: const Icon(Icons.arrow_forward_rounded, size: 60),
      onPressed: () {
        login(context, inputFieldController.text);
      },
    );
  }

  /// checks if password is equal to the list of passwords previously acquired
  /// make sure the password has not expired yet
  bool checkValid(List tokenList, String password) {
    for (var tokenData in tokenList) {
      if (password == tokenData['token'] &&
          checkValidDate(tokenData['expires'])) {
        storage.writePassword = tokenData['expires'];
        return true;
      }
    }
    return false;
  }

  /// false login attempt will alert user by coloring and animating the check mark
  /// a successful login will color the check mark green and proceed to next window
  void login(BuildContext context, String password) async {
    bool valid;

    try {
      Preslikave p = await preslikava.then((value) => value);

      valid = checkValid(p.tokens, password);
      if (valid) {
        setState(() {
          checkStateIndex = 1;
        });
        Navigator.push(context, homePageAnimation(p));
      } else {
        setState(() {
          checkStateIndex = 2;
        });
        _checkmarkController.forward(from: 0.0);
      }
    } catch (e) {
      preslikava = getTransformation(context);
      //noInternetConnectionDialog(context, -1);
    }
  }

  /// animation to homepage is a 'fade' animation
  /// duration: 1 second
  Route homePageAnimation(Preslikave p) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) =>
          HomePage(preslikava: p),
      transitionDuration: const Duration(seconds: 1),
      reverseTransitionDuration: const Duration(milliseconds: 500),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: animation,
          child: child,
        );
      },
    );
  }

  animatedCheckIcon() {
    Animation<double> offsetAnimation = Tween(begin: 0.0, end: 10.0)
        .chain(CurveTween(curve: Curves.bounceOut))
        .animate(_checkmarkController);

    return AnimatedBuilder(
      animation: offsetAnimation,
      builder: (buildContext, child) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: 10 - offsetAnimation.value,
          ),
          child: checkState[checkStateIndex],
        );
      },
    );
  }
}
