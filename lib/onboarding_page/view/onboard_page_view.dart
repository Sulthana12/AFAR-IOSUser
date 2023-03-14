import 'package:afar_cabs_user/onboarding_page/view/sign_in_up_intro.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:introduction_screen/introduction_screen.dart';


class OnboardingScreen extends StatelessWidget {

  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    Size size = MediaQuery.of(context).size;

    return IntroductionScreen(
      // globalBackgroundColor: Colors.pink.shade100,
      pages: [
        PageViewModel(
          title: "tut1Title".tr,
          body: "tut1Body".tr,
          image: Image.asset("assets/onboard/tut_1.png", height: 270.0, width: 320.0,),
          decoration: PageDecoration(
              imagePadding: EdgeInsets.only(top: size.height * 0.25),
              titlePadding: const EdgeInsets.only(bottom: 18.0),
              bodyFlex: 0,
              imageFlex: 3,
              bodyAlignment: Alignment.bottomCenter,
              imageAlignment: Alignment.center,
          ),
        ),
        PageViewModel(
          title: "tut2Title".tr,
          body: "tut2Body".tr,
          image: Image.asset("assets/onboard/tut_2.png", height: 270.0),
          decoration: PageDecoration(
              imagePadding: EdgeInsets.only(top: size.height * 0.25),
              titlePadding: const EdgeInsets.only(bottom: 18.0),
              bodyFlex: 1,
              imageFlex: 2,
              bodyAlignment: Alignment.bottomCenter,
              imageAlignment: Alignment.center
          ),
        ),
        PageViewModel(
          title: "tut3Title".tr,
          body: "tut3Body".tr,
          image: Image.asset("assets/onboard/tut_3.png", height: 270.0),
          decoration: PageDecoration(
              imagePadding: EdgeInsets.only(top: size.height * 0.25),
              titlePadding: const EdgeInsets.only(bottom: 18.0),
              bodyFlex: 0,
              imageFlex: 0,
              bodyAlignment: Alignment.bottomCenter,
              imageAlignment: Alignment.center
          ),
        ),
      ],
      showNextButton: true,
      showSkipButton: true,
      done: Text("getStar".tr, style: TextStyle(color: Colors.black, overflow: TextOverflow.ellipsis,),),
      skip: Text("skip".tr, style: TextStyle(color: Colors.black),),
      next: Text("next".tr, style: TextStyle(color: Colors.black),),
      onDone: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const SignInUpIntro()),
        );
      },
      onSkip: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const SignInUpIntro()),
        );
      },
      dotsDecorator: DotsDecorator(
        size: const Size.square(10.0),
        activeSize: const Size(20.0, 10.0),
        activeColor: Theme.of(context).colorScheme.secondary,
        color: Colors.black26,
        spacing: const EdgeInsets.symmetric(horizontal: 3.0),
        activeShape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25.0)
        ),
      ),
    );
  }
}
