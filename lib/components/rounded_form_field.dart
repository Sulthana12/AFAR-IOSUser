import 'package:flutter/material.dart';

class TextFieldContainer extends StatelessWidget {
  final Widget child;
  const TextFieldContainer({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
      width: size.width * 0.85,
      height: size.height * 0.09,
      decoration: BoxDecoration(
        color: Colors.transparent,
        border: Border.all(color: Colors.grey,width: 2.0),
        borderRadius: BorderRadius.circular(35.0),
      ),
      child: child,
    );
  }
}
