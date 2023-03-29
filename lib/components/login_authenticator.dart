import 'package:flutter/material.dart';
import 'package:pediatko/components/home_navigator.dart';
import 'package:pediatko/components/password_manager.dart';
import 'package:pediatko/services/preslikava.dart';

class LoginAuthenticator {
  LoginAuthenticator();

  static Future<bool> isAuthenticated() async {
    try {
      String? dateExpire = await storage.readPassword;

      if (!checkValidDate(dateExpire)) {
        storage.deletePassword();
        return false;
      }
      return true;
    } catch (e) {
      return false;
    }
  }

  /// checks is given passcode has not yet expired
  /// if valid, proceed to next window (homepage)
  /// if password is not valid, delete it from the storage, stay at login page
  static void readCheckProceedPassword(
    BuildContext context,
    Preslikava transformation,
  ) async {
    try {
      String? dateExpire = await storage.readPassword;

      if (checkValidDate(dateExpire) && context.mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const HomeNavigator(),
          ),
        );
      } else {
        storage.deletePassword();
      }
    } catch (e) {
      throw Exception('Password read/write issue');
    }
  }

  /// return true or false when checking:
  /// if current date is less than expire date of currently used passcode
  static bool checkValidDate(String? dateString) {
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

  /// checks if password is equal to the list of passwords previously acquired
  /// make sure the password has not expired yet
  static bool checkValid(List tokenList, String password) {
    for (var tokenData in tokenList) {
      if (password == tokenData['token'] &&
          checkValidDate(tokenData['expires'])) {
        storage.writePassword = tokenData['expires'];
        return true;
      }
    }
    return false;
  }
}
