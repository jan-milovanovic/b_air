import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:pediatko/components/home_navigator.dart';
import 'package:pediatko/components/login_authenticator.dart';
import 'package:pediatko/modals/data_provider.dart';
import 'package:pediatko/pages/login/login_page.dart';
import 'package:provider/provider.dart';

class AuthenticatorPage extends StatelessWidget {
  const AuthenticatorPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: LoginAuthenticator.isAuthenticated(),
      builder: (context, snapshot) {
        bool? isAuthenticated = snapshot.data;

        if (snapshot.hasData) {
          Future.delayed(const Duration(seconds: 1)).then(
            (value) => FlutterNativeSplash.remove(),
          );
          return ChangeNotifierProvider.value(
            value: context.read<DataProvider>(),
            child: isAuthenticated! ? const HomeNavigator() : const LoginPage(),
          );
        }

        if (snapshot.hasError) {
          Future.delayed(const Duration(seconds: 1)).then(
            (value) => FlutterNativeSplash.remove(),
          );
          return ChangeNotifierProvider.value(
            value: context.read<DataProvider>(),
            child: const LoginPage(),
          );
        }

        return const SizedBox.shrink();
      },
    );
  }
}
