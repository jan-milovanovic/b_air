import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'password_manager.dart';

/// while data is still loading display a circular loading indicator
Container loadingIndicator() {
  return Container(
      alignment: Alignment.center, child: const CircularProgressIndicator());
}

/// displays a dialog for a user to check their internet connection
/// popNo -> amount of windows the dialog should close
/// 1 = close itself
/// 2 = close itself + following window ,....
/// -1 = close the application
noInternetConnectionDialog(context, int popNo) {
  showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () async => false,
          child: AlertDialog(
            title: const Text(
              'Preverite internetno povezavo',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20))),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                    'Prosim preverite internetno povezavo in poskusite znova.'),
                TextButton(
                  child: const Text(
                    'ok',
                    style: TextStyle(fontSize: 20),
                  ),
                  onPressed: () {
                    for (int i = 0; i < popNo; i++) {
                      Navigator.of(context).pop();
                    }
                    if (popNo == -1) {
                      SystemNavigator.pop();
                    }
                  },
                ),
              ],
            ),
          ),
        );
      });
}

/// display dialog with date of passcode expiration
/// upon agreeing to logout, passcode is removed from storage and user gets
/// moved 1 window back -> back to login screen
AlertDialog logoutDialog(context) {
  return AlertDialog(
    title: const Text('Odjava?'),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(
        Radius.circular(20),
      ),
    ),
    content: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        passwordExpire(),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextButton(
              child: const Text(
                'Zapri',
                style: TextStyle(color: Colors.grey),
              ),
              onPressed: () {
                Navigator.pop(context); // close dialog
              },
            ),
            TextButton(
              child: const Text('Odjavi me'),
              onPressed: () {
                storage.deletePassword();
                Navigator.pop(context); // close dialog
                Navigator.pop(context); // return to login screen
              },
            ),
          ],
        ),
      ],
    ),
  );
}
