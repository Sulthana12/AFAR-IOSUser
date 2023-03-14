import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AlreadyHaveAnAccountCheck extends StatelessWidget {
  final bool login;
  final Function? press;
  const AlreadyHaveAnAccountCheck({
    Key? key,
    this.login = true,
    required this.press,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          login ? "dontAcc".tr : "alreadyAcc".tr,
          style: const TextStyle(color: Colors.black),
        ),
        GestureDetector(
          onTap: press as void Function()?,
          child: Text(
            login ? "signUp".tr : "logIn".tr,
            style: const TextStyle(
              color: Colors.blue,
              fontWeight: FontWeight.bold,
            ),
          ),
        )
      ],
    );
  }
}