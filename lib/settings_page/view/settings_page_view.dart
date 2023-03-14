import 'package:afar_cabs_user/contact_us_page/view/contact_us_view.dart';
import 'package:afar_cabs_user/language_change_provider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../constants/colors/colors.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings page"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
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
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 15.0),
        children: [
          ExpansionTile(
            childrenPadding: const EdgeInsets.symmetric(horizontal: 25),
            leading: const Icon(
              Icons.translate,
              color: Colors.black,
            ),
            trailing: const Icon(
              Icons.arrow_forward_ios_rounded,
              size: 15.0,
              color: Colors.black,
            ),
            title: Text(
              "langPrefs".tr,
              style: const TextStyle(
                color: Colors.black,
              ),
            ),
            children: <Widget>[
              ListTile(
                // leading: const Icon(Icons.translate),
                title:  Text('english'.tr),
                onTap: () {
                  Provider.of<LanguageChangeProvider>(context, listen: false)
                      .changeLocale("en");
                  // Navigator.pop(context);
                },
              ),
              ListTile(
                // leading: const Icon(Icons.menu_rounded),
                title:  Text('tamil'.tr),
                onTap: () {
                  Provider.of<LanguageChangeProvider>(context, listen: false)
                      .changeLocale("ta");
                  // Navigator.pop(context);
                },
              ),
            ],
          ),
          // ListTile(
          //   leading: const Icon(Icons.translate, color: Colors.black ,),
          //   title: const Text('Language Preference',
          //   ),
          //   onTap: () => Navigator.pop(context),
          //   trailing: const Icon(
          //     Icons.arrow_forward_ios_rounded,
          //     size: 15.0,
          //     color: Colors.black,
          //   ),
          //   minVerticalPadding: 20.0,

          // ),
          const SizedBox(
            height: 10.0,
          ),
          ListTile(
            leading: const Icon(
              Icons.privacy_tip_sharp,
              color: Colors.black,
            ),
            title: const Text(
              'Privacy Policy',
            ),
            onTap: () async {
              Uri url = Uri.parse(
                  "https://afarstorage.blob.core.windows.net/mobile-app/PrivacyPolicy.html");
              if (!await launchUrl(url)) {
                throw Exception('Could not launch $url');
              }
            },
            trailing: const Icon(
              Icons.arrow_forward_ios_rounded,
              size: 15.0,
              color: Colors.black,
            ),
            minVerticalPadding: 20.0,
          ),
          const SizedBox(
            height: 10.0,
          ),
          ListTile(
            leading: const Icon(
              Icons.fact_check,
              color: Colors.black,
            ),
            title: const Text(
              'Cancellation and Refund Policy',
            ),
            onTap: () async {
              Uri url = Uri.parse(
                  "https://afarstorage.blob.core.windows.net/mobile-app/CancellationRefundPolicy.html");
              if (!await launchUrl(url)) {
                throw Exception('Could not launch $url');
              }
            },
            trailing: const Icon(
              Icons.arrow_forward_ios_rounded,
              size: 15.0,
              color: Colors.black,
            ),
            minVerticalPadding: 20.0,
          ),
          const SizedBox(
            height: 10.0,
          ),
          ListTile(
            leading: const Icon(
              Icons.question_answer,
              color: Colors.black,
            ),
            title: const Text(
              'Contact Us',
            ),
            onTap: () {
              // Navigator.pop(context);
              Get.to(() => const ContactUsPage());
            },
            trailing: const Icon(
              Icons.arrow_forward_ios_rounded,
              size: 15.0,
              color: Colors.black,
            ),
            minVerticalPadding: 20.0,
          ),
          const Divider(
            thickness: 3.0,
          ),
        ],
      ),
    );
  }
}
