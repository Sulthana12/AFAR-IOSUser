import 'package:flutter/material.dart';

import '../controller/app_version_controller.dart';

Future<dynamic> showCurrentVersion(
    BuildContext context, AppVersionController controller) {
  return showDialog(
    context: context,
    builder: (ctx) => AlertDialog(
      title: const Text("Current App Version"),
      content: Text(
          "Your current version of AFAR CABS is ${controller.appVersion.value}"),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(ctx).pop();
          },
          child: Text("Okay"),
        ),
      ],
    ),
  );
}
