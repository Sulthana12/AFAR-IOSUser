import 'package:afar_cabs_user/components/custom_rounded_button.dart';
import 'package:afar_cabs_user/constants/colors/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';

class CouponPage extends StatelessWidget {
  const CouponPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        child: Form(
          child: SizedBox(
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: const Text(
                      "Apply Coupon",
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.8,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 30.0,
                  ),
                  Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: TextFormField(
                          // controller: controller.loginMailController,
                          keyboardType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.next,
                          cursorColor: Colors.black,
                          onChanged: (email) {},
                          validator: MultiValidator([
                            RequiredValidator(
                                errorText: "Must enter coupon code if any"),
                            // EmailValidator(errorText: "Enter a valid email"),
                          ]),
                          decoration: const InputDecoration(
                            hintText: "Enter Coupon code",
                            hintStyle: TextStyle(color: Colors.black),
                            border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(0.0)),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 30,
                      ),
                      Expanded(child: RoundedButtonCustom(pressed: () {}, child: Text("Apply"))),
                    ],
                  ),
                  SizedBox(
                    height: 30.0,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: const Text(
                      "Available Coupons",
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.8,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 30.0,
                  ),
                  ListTile(
                    tileColor: primaryColor,
                    shape: RoundedRectangleBorder(
                      side:BorderSide(
                          width: 3, color: Colors.black),
                      borderRadius: BorderRadius.circular(10),

                    ),
                    title: Text("Coupon 1",
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 30.0,
                  ),
                  ListTile(
                    tileColor: primaryColor,
                    shape: RoundedRectangleBorder(
                      side:BorderSide(
                          width: 3, color: Colors.black),
                      borderRadius: BorderRadius.circular(10),

                    ),
                    title: Text("Coupon 2",
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 30.0,
                  ),
                  ListTile(
                    tileColor: primaryColor,
                    shape: RoundedRectangleBorder(
                      side:BorderSide(
                          width: 3, color: Colors.black),
                      borderRadius: BorderRadius.circular(10),

                    ),
                    title: Text("Coupon 3",
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 30.0,
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
