import 'package:afar_cabs_user/constants/colors/colors.dart';
import 'package:flutter/material.dart';

class RoundedButtonCustom extends StatelessWidget {
  final Function? pressed;
  // final String buttonText;
  final Widget child;

  RoundedButtonCustom({
    Key? key,
    required this.pressed,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 130.0,
      height: 45.0,
      child: ElevatedButton(
        onPressed: pressed as void Function()?,
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          primary: primaryColor,
        ),
        child: child,
      ),
    );
  }
}