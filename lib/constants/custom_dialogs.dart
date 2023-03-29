import 'package:flutter/material.dart';
import 'package:pediatko/components/password_manager.dart';
import 'package:pediatko/constants/functions.dart';

class CustomDialogs {
  const CustomDialogs();

  static noInternetConnectionDialog(context) {
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
                    onPressed: () => onLogoutNavigate(context),
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
  static AlertDialog logoutDialog(context) {
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
                  Navigator.pop(context);
                },
              ),
              TextButton(
                child: const Text('Odjavi me'),
                onPressed: () {
                  storage.deletePassword();
                  onLogoutNavigate(context);
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
