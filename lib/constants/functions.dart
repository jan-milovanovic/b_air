import 'package:flutter/material.dart';
import 'package:pediatko/modals/data_provider.dart';
import 'package:pediatko/pages/login/login_page.dart';
import 'package:provider/provider.dart';

onLogoutNavigate(BuildContext context) {
  DataProvider dataProvider = context.read<DataProvider>();

  Navigator.pushAndRemoveUntil(
    context,
    MaterialPageRoute(
      maintainState: false,
      builder: (context) => ChangeNotifierProvider.value(
        value: dataProvider,
        child: const LoginPage(),
      ),
    ),
    (Route<dynamic> route) => false,
  );
}

Widget loadingIndicator() {
  return const Center(child: CircularProgressIndicator());
}
