import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:pediatko/modals/data_provider.dart';
import 'package:pediatko/pages/login/components/login_form.dart';
import 'package:pediatko/pages/login/modals/checkmark_animation_provider.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: Column(
        children: [
          const Spacer(flex: 1),
          Image.asset('assets/pediatko-logo.png', height: 50),
          const Spacer(flex: 1),
          MultiProvider(
            providers: [
              ChangeNotifierProvider(
                create: (_) => CheckMarkAnimationProvider(),
              ),
              ChangeNotifierProvider.value(
                value: context.read<DataProvider>(),
              ),
            ],
            child: LoginForm(),
          ),
          const SizedBox(height: 8.0),
          FutureBuilder<PackageInfo>(
            future: PackageInfo.fromPlatform(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) return const SizedBox.shrink();
              return Text(
                'Različica: ${snapshot.data!.version}',
                style: const TextStyle(color: Colors.white),
              );
            },
          ),
          const Spacer(flex: 1),
        ],
      ),
    );
  }
}
