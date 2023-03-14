import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OrDivider extends StatelessWidget {
  const OrDivider({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.symmetric(vertical: size.height * 0.02),
      width: size.width * 0.4,
      child: Row(
        children: <Widget>[
          buildDivider(),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              "or".tr,
              style: TextStyle(
                color: Colors.grey,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          buildDivider(),
        ],
      ),
    );
  }

  Expanded buildDivider() {
    return const Expanded(
      child: Divider(
        color: Colors.grey,
        height: 1.5,
      ),
    );
  }
}