import 'package:afar_cabs_user/constants/colors/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AboutUsPage extends StatelessWidget {
  const AboutUsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.only(left: 7.0),
          child: Image.asset("assets/icon/afar.png"),
        ),
        title: Center(child: Text("About Us")),
        actions: [
          TextButton(
              onPressed: () {},
              child: Icon(
                Icons.notifications,
                color: Colors.white,
              )),
        ],
        backgroundColor: primaryColor,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(15.0),
          child: Text(
            """AFAR Cabs was founded by Ms. Sulthana Rasiya Nasurudeen and Mohamed Asik, with a mission to build portability for people of all ages in a secured way mainly focusing on women and child safety. The AFAR Technologies headquarters is located in Madurai, Tamilnadu.
    We at AFAR cabs, envision to support Android users with a safe and hassle-free mobility platform. We have made travelling all the way more comfortable and seek to provide our users an enriching experience. All you need to do is just enable your location, go online, book a service and within span of few minutes, the cab arrives at the specified location. We also serve our customers with on-time delivery of goods and offer door-to-door service of commodity.
Apart from serving our customers, we also ensure the satisfaction and happiness of our Pilot’s who commute our customers to their desired location. We encourage them by giving reward points and bonus for their commendable job done.
We provide our pilots and users with geo-location services on three vital factors – accessing the location, providing the navigation details, and providing mapping software. The on-boarding and registration process are made seamless with good UI/UX designs to ease our customer navigation. We appoint our pilots through proper verification of their ID proof and driving license.
    """,
            textAlign: TextAlign.justify,
            style: TextStyle(
              fontSize: 23.0,
              color: Colors.grey,
            ),
          ),
        ),
      ),
    );
  }
}
