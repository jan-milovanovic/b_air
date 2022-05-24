import 'package:flutter_secure_storage/flutter_secure_storage.dart';

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
