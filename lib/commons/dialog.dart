import 'package:flutter/material.dart';

void textDialog(BuildContext context, String title, String message) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(title: Text(title), content: Text(message));
    },
  );
}
