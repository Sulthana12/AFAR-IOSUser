import 'package:afar_cabs_user/sign_in_up_page/controller/sign_up_email_phone_controller.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class ReferralContainer extends StatelessWidget {
  ReferralContainer({
    Key? key,
    required this.size,
  }) : super(key: key);

  final mailPhoneController = Get.put(MailPhoneController());
  final Size size;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: 20.0, vertical: 10.0),
      width: size.width * 0.85,
      height: size.height * 0.30,
      decoration: BoxDecoration(
        color: Colors.transparent,
        border: Border.all(color: Colors.grey, width: 2.0),
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
           AutoSizeText(
            "popupRefTit".tr,
            maxLines: 3,
            maxFontSize: 15.0,
            minFontSize: 13.0,
            style: TextStyle(
              fontSize: 15.0,
              color: Colors.black,
            ),
          ),
          const SizedBox(
            height: 10.0,
          ),
          AutoSizeText(
            "popupRefDesc".tr,
            maxLines: 3,
            style: TextStyle(
              fontSize: 13.0,
              color: Colors.grey,
            ),
          ),
          TextFormField(
            controller: mailPhoneController.referralController,
            textInputAction: TextInputAction.next,
            cursorColor: Colors.black,
            onChanged: (email) {},
            validator: MultiValidator([
              RequiredValidator(errorText: "enterRefCode".tr),
            ]),
            decoration: InputDecoration(
              hintText: "referCodeText".tr,
              hintStyle: TextStyle(color: Colors.grey),
            ),
          ),
        ],
      ),
    );
  }
}