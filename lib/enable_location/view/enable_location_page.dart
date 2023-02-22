import 'package:afar_cabs_user/enable_location/controller/enable_location_controller.dart';
import 'package:afar_cabs_user/home_page/controller/google_map_controller.dart';
import 'package:afar_cabs_user/home_page/view/home_page_view.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../components/custom_rounded_button.dart';
import '../../sign_in_up_page/controller/sign_up_email_phone_controller.dart';

class EnableLocation extends StatelessWidget {
  EnableLocation({Key? key}) : super(key: key);
  final mailPhoneController = Get.put(MailPhoneController());
  final locController = Get.put(EnableLocationController());
  final googleMapController = Get.put(GoogleMapHomeController());

  @override
  Widget build(BuildContext context) {

    Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          reverse: true,
          child: SizedBox(
            width: double.infinity,
            child: GetBuilder<EnableLocationController> (
              builder:(controller) => Column(
                mainAxisAlignment: MainAxisAlignment.center,
                // crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.asset(
                    "assets/images/enable_loc.png",
                    height: size.height * 0.6,
                    width: size.width * 0.8,
                  ),
                  const AutoSizeText(
                    "Enable Location",
                    minFontSize: 20,
                    maxFontSize: 30,
                    style: TextStyle(
                      // fontSize: 25.0,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 0.4,
                    ),
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: size.width * 0.08),
                    child: const AutoSizeText(
                      "Enable and share your location to request and confirm rides to your desired destination",
                      maxLines: 3,
                      textAlign: TextAlign.justify,
                      style: TextStyle(
                        fontSize: 20.0,
                        color: Colors.grey,
                        letterSpacing: 0.4,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 30.0,
                  ),
                  RoundedButtonCustom(
                    pressed: () async {
                      await controller.getCurrentPosition();

                      // await googleMapController.getUserCurrentLocation();
                      print("Latitude" + controller.currentLatitude.value.toString());
                      print("Longitude" + controller.currentLongitude.value.toString());
                      print("Address" + controller.currentAddress.value);

                      mailPhoneController.clearAllInputs();
                      Get.offAll(() => HomePage());
                    },
                    child: const AutoSizeText("Allow Access",
                      maxLines: 1,
                      minFontSize: 10.0,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      mailPhoneController.clearAllInputs();

                      Get.offAll(() => HomePage());
                    },
                    child: const Text(
                      "Skip for now",
                      style: TextStyle(
                        color: Colors.blue,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
