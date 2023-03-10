import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:share_plus/share_plus.dart';

import '../../constants/colors/colors.dart';
import '../../home_page/controller/user_controller.dart';

class ReferFriendPage extends StatelessWidget {
  ReferFriendPage({Key? key}) : super(key: key);
  final userProfileController = Get.put(UserProfileController());

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Refer a Friend"),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          color: Colors.white,
          onPressed: () {
            // Get.off(HomePage());
            Navigator.pop(context);
          },
        ),
        elevation: 0.0,
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
      ),
      body: Stack(
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: EdgeInsets.only(top: size.height * 0.05),
              child: Image.asset(
                "assets/images/refer_new.png",
                width: size.width * 0.8,
                height: size.height * 0.65,
                fit: BoxFit.fill,
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 30.0),
              child: SizedBox(
                width: size.width * 0.7,
                height: size.height * 0.1,
                child: Material(
                  color: Colors.teal,
                  borderRadius: BorderRadius.circular(
                    10,
                  ),
                  child: InkWell(
                    onTap: () async {
                      print("refer a friend");
                      await Share.share("Let me recommend you this application and earn more with Afar Cabs with referral code - ${userProfileController.referralCode.value}");
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        AutoSizeText('Code: KAR353',
                          maxLines: 1,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: size.width * 0.06,
                          ),
                        ), // <-- Text
                        SizedBox(
                          width: 5,
                        ),
                        Icon( // <-- Icon
                          Icons.share,
                          size: 30.0,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
