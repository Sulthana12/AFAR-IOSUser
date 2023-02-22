import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../constants/colors/colors.dart';

class ContactUsPage extends StatelessWidget {
  const ContactUsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        // leading: Padding(
        //   padding: const EdgeInsets.only(left: 7.0),
        //   child: Image.asset("assets/icon/afar.png"),
        // ),
        title: Center(child: Text("Contact Us")),
        // actions: [
        //   TextButton(
        //       onPressed: () {},
        //       child: Icon(
        //         Icons.notifications,
        //         color: Colors.white,
        //       )),
        // ],
        backgroundColor: primaryColor,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: size.height * 0.08),
              child: Image.asset(
                "assets/images/contact_us.png",
                fit: BoxFit.fill,
                // height: size.height * 0.35,
                width: double.infinity,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: size.width * 0.1),
              child: AutoSizeText(
                "Want to Reach Out to us?",
                maxLines: 1,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: size.width * 0.06,
                ),
              ),
            ),
            SizedBox(height: size.height * 0.03,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Icon(Icons.phone, size: size.width * 0.13, color: Colors.green,),
                Padding(
                  padding: EdgeInsets.only(right: size.width * 0.1),
                  child: AutoSizeText(
                    "Phone: +91 96266 37184",
                    maxLines: 1,
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: size.width * 0.045,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: size.height * 0.03,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Icon(Icons.mail, size: size.width * 0.13, color: Colors.lightGreen,),
                Padding(
                  padding: EdgeInsets.only(right: size.width * 0.02),
                  child: AutoSizeText(
                    "E-mail:\nafartechnologiesmdu@gmail\n.com",
                    maxLines: 3,
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: size.width * 0.045,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
