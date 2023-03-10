import 'package:flutter/material.dart';

class CustAlertDialog extends StatelessWidget {
  final String title;
  final String content;
  final List<Widget> actions;

  CustAlertDialog({
    required this.title,
    required this.content,
    this.actions = const [],
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        this.title,
      ),
      actions: this.actions,
      content: Text(
        this.content,
      ),
    );
  }
}