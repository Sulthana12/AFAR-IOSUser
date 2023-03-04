import 'package:afar_cabs_user/add_favourites_page/controller/save_location_controller.dart';
import 'package:afar_cabs_user/add_favourites_page/view/my_locations_view.dart';
import 'package:afar_cabs_user/app_version_page/controller/app_version_controller.dart';
import 'package:afar_cabs_user/components/cancel_ride_model_bsheet.dart';
import 'package:afar_cabs_user/components/custom_alert_dialog.dart';
import 'package:afar_cabs_user/delivery_page/view/your_deliveries_page.dart';
import 'package:afar_cabs_user/home_page/controller/google_map_controller.dart';
import 'package:afar_cabs_user/home_page/controller/user_controller.dart';
import 'package:afar_cabs_user/rides_page/view/your_rides_page.dart';
import 'package:afar_cabs_user/sign_in_up_page/view/sign_in_page.dart';
import 'package:blurry/blurry.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../about_us_page/view/about_us_view.dart';
import '../app_version_page/view/current_version_dialog_view.dart';
import '../constants/colors/colors.dart';
import '../refer_a_friend_page/view/refer_a_friend_view.dart';
import '../settings_page/view/settings_page_view.dart';

class CustomNavigationDrawer extends StatelessWidget {
  final userProfileController = Get.put(UserProfileController());
  final googleMapController = Get.put(GoogleMapHomeController());
  final appVersionController = Get.put(AppVersionController());
  final saveLocationController = Get.put(SaveLocationController());

  CustomNavigationDrawer({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          Container(
            color: primaryColor,
            padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 40.0),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 35,
                  backgroundColor: Colors.white,
                  backgroundImage: AssetImage("assets/images/default.png"),
                ),
                SizedBox(
                  width: 20,
                ),
                Obx(
                  () => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        userProfileController.userName.value.isNotEmpty
                            ? userProfileController.userName.value
                            : "AFAR User",
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(
                        height: 4.0,
                      ),
                      Text(
                        userProfileController.mobileNum.value.isNotEmpty
                            ? "+91 ${userProfileController.mobileNum.value}"
                            : "",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            leading: Icon(Icons.home),
            title: const Text('Home'),
            onTap: () => Navigator.pop(context),
          ),
          ExpansionTile(
            leading: Icon(Icons.local_activity),
            trailing: const Icon(
              Icons.arrow_forward_ios_rounded,
              size: 10.0,
              color: primaryColor,
            ),
            title: const Text(
              "Activity",
              style: TextStyle(
                color: Colors.black,
              ),
            ),
            children: <Widget>[
              ListTile(
                leading: Icon(Icons.menu_rounded),
                title: const Text('Locations'),
                onTap: () {
                  Navigator.pop(context);

                  saveLocationController.homeOrSearchScreen.value = "homepage";
                  Get.to(() => MyLocationsPage());
                },
              ),
              ListTile(
                leading: Icon(Icons.menu_rounded),
                title: const Text('Rides'),
                onTap: () {
                  Navigator.pop(context);

                  Get.to(() => RidesPage());
                },
              ),
              ListTile(
                  leading: Icon(Icons.menu_rounded),
                  title: const Text('Deliveries'),
                onTap: () {
                  Navigator.pop(context);

                  Get.to(() => DeliveriesPage());
                },
              ),
            ],
          ),
          ListTile(
              leading: Icon(Icons.currency_rupee),
              title: const Text('AFAR Money'),
              onTap: () => Navigator.pop(context)),
          ListTile(
              leading: Icon(Icons.payment_outlined),
              title: const Text('Payments'),
              onTap: () => Navigator.pop(context)),
          ListTile(
            leading: Icon(Icons.person_add_alt_1),
            title: const Text('Refer a Friend'),
            onTap: () {
              Navigator.pop(context);
              Get.to(() => ReferFriendPage());
            },
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: const Text('Settings'),
            onTap: () {
              Navigator.pop(context);

              Get.to(() => SettingsPage());
            },
          ),
          ListTile(
            leading: Icon(Icons.person),
            title: const Text('About Us'),
            onTap: () async {
              Uri url = Uri.parse(
                  "https://afarstorage.blob.core.windows.net/mobile-app/AboutUs.html");
              if (!await launchUrl(url)) {
                throw Exception('Could not launch $url');
              }
            },
          ),
          ListTile(
            leading: Icon(Icons.logout),
            title: const Text('Sign Out'),
            onTap: () {
              Blurry.warning(
                  title: 'Confirm Sign out',
                  description: 'Are you sure you want to sign out?',
                  confirmButtonText: 'Confirm',
                  onConfirmButtonPressed: () async {
                    rideConfirmController.clearDetailsSignOut();

                    Get.offAll(() => SignInPage());
                    googleMapController.mounted.value = true;

                    SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    await prefs.setBool('isLoggedIn', false);
                  }).show(context);
            },
          ),
          GetBuilder<AppVersionController>(
            builder: (controller) => ListTile(
              leading: Icon(Icons.verified_sharp),
              title: const Text('App Version'),
              onTap: () {
                Navigator.pop(context);

                /// It'll return the current version of the app
                controller.initPackageInfo();

                showCurrentVersion(context, controller);
              },
            ),
          ),
        ],
      ),
    );
  }
}
