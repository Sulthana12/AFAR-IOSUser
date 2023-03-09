import 'package:afar_cabs_user/add_favourites_page/controller/save_location_controller.dart';
import 'package:afar_cabs_user/add_favourites_page/view/my_locations_view.dart';
import 'package:afar_cabs_user/app_version_page/controller/app_version_controller.dart';
import 'package:afar_cabs_user/app_version_page/view/current_version_dialog_view.dart';
import 'package:afar_cabs_user/components/cancel_ride_model_bsheet.dart';
import 'package:afar_cabs_user/constants/colors/colors.dart';
import 'package:afar_cabs_user/delivery_page/view/your_deliveries_page.dart';
import 'package:afar_cabs_user/home_page/controller/google_map_controller.dart';
import 'package:afar_cabs_user/home_page/controller/user_controller.dart';
import 'package:afar_cabs_user/refer_a_friend_page/view/refer_a_friend_view.dart';
import 'package:afar_cabs_user/rides_page/view/your_rides_page.dart';
import 'package:afar_cabs_user/settings_page/view/settings_page_view.dart';
import 'package:afar_cabs_user/sign_in_up_page/view/sign_in_page.dart';
import 'package:blurry/blurry.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';


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
      child: Material(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24.0, 24, 24, 0),
          child: ListView(
            children: [
              headerWidget(),
              const SizedBox(height: 40,),
              const Divider(thickness: 1, height: 10, color: Colors.grey,),
              const SizedBox(height: 40,),
              ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Home'),
            onTap: () => Navigator.pop(context),
          ),
          ExpansionTile(
            leading: const Icon(Icons.local_activity),
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
                leading: const Icon(Icons.menu_rounded),
                title: const Text('Locations'),
                onTap: () {
                  Navigator.pop(context);

                  saveLocationController.homeOrSearchScreen.value = "homepage";
                  Get.to(() => MyLocationsPage());
                },
              ),
              ListTile(
                leading: const Icon(Icons.menu_rounded),
                title: const Text('Rides'),
                onTap: () {
                  Navigator.pop(context);

                  Get.to(() => const RidesPage());
                },
              ),
              ListTile(
                  leading: const Icon(Icons.menu_rounded),
                  title: const Text('Deliveries'),
                onTap: () {
                  Navigator.pop(context);

                  Get.to(() => const DeliveriesPage());
                },
              ),
            ],
          ),
          ListTile(
              leading: const Icon(Icons.currency_rupee),
              title: const Text('AFAR Money'),
              onTap: () => Navigator.pop(context)),
          ListTile(
              leading: const Icon(Icons.payment_outlined),
              title: const Text('Payments'),
              onTap: () => Navigator.pop(context)),
          ListTile(
            leading: const Icon(Icons.person_add_alt_1),
            title: const Text('Refer a Friend'),
            onTap: () {
              Navigator.pop(context);
              Get.to(() => ReferFriendPage());
            },
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Settings'),
            onTap: () {
              Navigator.pop(context);

              Get.to(() => const SettingsPage());
            },
          ),
          ListTile(
            leading: const Icon(Icons.person),
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
            leading: const Icon(Icons.logout),
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
              leading: const Icon(Icons.verified_sharp),
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
        ),
      ),
    );
  }

  void onItemPressed(BuildContext context, {required int index}){
    Navigator.pop(context);

    switch(index){
      case 0:
        // Navigator.push(context, MaterialPageRoute(builder: (context) => const People()));
        break;
    }
  }

  Widget headerWidget() {
    const url = 'https://media.istockphoto.com/photos/learn-to-love-yourself-first-picture-id1291208214?b=1&k=20&m=1291208214&s=170667a&w=0&h=sAq9SonSuefj3d4WKy4KzJvUiLERXge9VgZO-oqKUOo=';
    return Row(
      children: [
        const CircleAvatar(
          radius: 35,
          backgroundColor: Colors.white,
          backgroundImage: AssetImage("assets/images/default.png"),
        ),
        const SizedBox(width: 20,),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(userProfileController.userName.value.isNotEmpty
                            ? userProfileController.userName.value
                            : "AFAR User", style: const TextStyle(fontSize: 14, color: Colors.black)),
            const SizedBox(height: 10,),
            Text(userProfileController.mobileNum.value.isNotEmpty
                            ? "+91 ${userProfileController.mobileNum.value}"
                            : "", style: const TextStyle(fontSize: 14, color: Colors.black))
          ],
        )
      ],
    );

  }
}
