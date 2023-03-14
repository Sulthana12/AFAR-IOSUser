import 'package:afar_cabs_user/sign_in_up_page/view/sign_in_page.dart';
import 'package:afar_cabs_user/sign_in_up_page/view/sign_up_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../components/custom_rounded_button.dart';

class SignInUpIntro extends StatelessWidget {
  const SignInUpIntro({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(25.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: Image.asset(
                "assets/images/welcome.png",
                height: height * 0.5,
                width: width * 1.0,
              ),
            ),
            Text(
              "welcome".tr,
              style: TextStyle(fontWeight: FontWeight.bold,
                fontSize: 20.0,
              ),
            ),
            Text(
              "welcomeDesc".tr,
              style: TextStyle(fontWeight: FontWeight.bold,
                fontSize: 18.0,
                height: 1.5,
              ),
            ),
            RoundedButtonCustom(
              pressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SignInPage(),
                  ),
                );
              }, child: Text("signIn".tr),
            ),
            RoundedButtonCustom(
              pressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SignUpPage(),
                  ),
                );
              }, child: Text("signUp".tr),
            ),
          ],
        ),
      ),
    );
  }
}

