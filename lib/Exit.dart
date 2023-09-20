import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

Future<bool> showExitConfirmationDialog(BuildContext context) {
  return showDialog(
    context: context,
    builder: (context) => AlertDialog(
      backgroundColor: Color(0xFF144272),
      title: Text(
          'Exit App',
        style: TextStyle(
          color: Colors.white,
          fontFamily: 'Poppins-Regular',
        ),
      ),
      content: Text(
        'Do you want to exit the app?',
        style: TextStyle(
          color: Colors.white,
          fontFamily: 'Poppins-Regular',
        ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(false);
          },
          child: Text(
              'No',
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'Poppins-Regular',
            ),
          ),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(true);
            SystemNavigator.pop();
          },
          child: Text(
            'Yes',
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'Poppins-Regular',
            ),
          ),
        ),
      ],
    ),
  ).then((value) => value ?? false);
}
