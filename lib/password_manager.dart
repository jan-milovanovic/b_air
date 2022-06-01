import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

PasswordManager storage = const PasswordManager();

class PasswordManager {
  // fields
  final storage = const FlutterSecureStorage();

  // getters / setters
  set writePassword(String pwdString) {
    storage.write(key: 'password', value: pwdString);
  }

  get readPassword {
    return storage.read(key: 'password');
  }

  // constructor
  const PasswordManager();

  // methods / functions
  void deletePassword() async {
    await storage.delete(key: 'password');
  }
}

/// returns a row which displays:
/// text + password expiration in slovene date format
Row passwordExpire() {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      const Text('Geslo poteče: '),
      FutureBuilder(
        future: storage.readPassword,
        builder: ((context, snapshot) {
          if (!snapshot.hasData) {
            return const Text('...');
          } else if (snapshot.hasError) {
            return Text('${snapshot.error}');
          } else {
            DateTime parseDT = DateTime.parse(snapshot.data.toString());
            var outputDate = DateFormat.yMMMd('sl').format(parseDT);

            return Text(
              outputDate,
              style: const TextStyle(fontWeight: FontWeight.bold),
            );
          }
        }),
      ),
    ],
  );
}
