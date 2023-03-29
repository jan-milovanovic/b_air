import 'package:flutter/material.dart';
import 'package:pediatko/components/home_navigator.dart';
import 'package:pediatko/components/login_authenticator.dart';
import 'package:pediatko/modals/data_provider.dart';
import 'package:pediatko/pages/login/components/custom_textfield.dart';
import 'package:pediatko/pages/login/modals/checkmark_animation_provider.dart';
import 'package:provider/provider.dart';

class LoginForm extends StatelessWidget {
  LoginForm({Key? key}) : super(key: key);

  final TextEditingController _textEditingController = TextEditingController();

  Route fadeTransitionAnimation(BuildContext context) {
    return PageRouteBuilder(
      pageBuilder: (_, __, ___) => ChangeNotifierProvider.value(
        value: context.read<DataProvider>(),
        child: const HomeNavigator(),
      ),
      transitionDuration: const Duration(milliseconds: 300),
      transitionsBuilder: (_, animation, __, child) {
        return FadeTransition(
          opacity: animation,
          child: child,
        );
      },
    );
  }

  void login(BuildContext context, String? password) async {
    List tokens = context.read<DataProvider>().tokens;
    CheckMarkAnimationProvider cmaProvider =
        context.read<CheckMarkAnimationProvider>();

    if (password == null || password.isEmpty) {
      cmaProvider.setCheckStateIndex(2);
      //_checkmarkController.forward(from: 0.0);
      return;
    }

    bool isValid = LoginAuthenticator.checkValid(tokens, password);

    if (!isValid) {
      cmaProvider.setCheckStateIndex(2);
      //_checkmarkController.forward(from: 0.0);
      return;
    }

    cmaProvider.setCheckStateIndex(1);
    Navigator.push(context, fadeTransitionAnimation(context));
  }

  @override
  Widget build(BuildContext context) {
    Color primaryColor = Theme.of(context).primaryColor;

    return Container(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(20)),
        color: Colors.white,
      ),
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 0),
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 16.0),
          Icon(
            Icons.lock,
            size: 40,
            color: primaryColor,
          ),
          const SizedBox(height: 16.0),
          RichText(
            textAlign: TextAlign.center,
            text: const TextSpan(
              style: TextStyle(fontSize: 24, color: Colors.black),
              children: <TextSpan>[
                TextSpan(text: 'Dobrodošli,\n'),
                TextSpan(
                  text: 'vse bo vredu :)',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32.0),
          CustomTextField(textEditingController: _textEditingController),
          const SizedBox(height: 40.0),
          CircleAvatar(
            radius: 45,
            backgroundColor: primaryColor,
            child: IconButton(
              onPressed: () => login(
                context,
                _textEditingController.text,
              ),
              iconSize: 60,
              icon:
                  const Icon(Icons.arrow_forward_rounded, color: Colors.white),
            ),
          ),
          const SizedBox(height: 16.0),
        ],
      ),
    );
  }
}
