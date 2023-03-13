import 'package:afar_cabs_user/onboarding_page/view/sign_in_up_intro.dart';
import 'package:flutter/material.dart';
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
          title: "Request & Track Your Ride",
          body: "Book ride and get picked up at your doorstep",
          image: Image.asset("assets/onboard/tut_1.png", height: 270.0, width: 320.0,),
          decoration: PageDecoration(
              imagePadding: EdgeInsets.only(top: size.height * 0.25),
              titlePadding: const EdgeInsets.only(bottom: 24.0),
              bodyFlex: 0,
              imageFlex: 0,
              bodyAlignment: Alignment.bottomCenter,
              imageAlignment: Alignment.center
          ),
        ),
        PageViewModel(
          title: "Select your route",
          body: "Travel with Safety - Share your locations to Lovable Person",
          image: Image.asset("assets/onboard/tut_2.png", height: 270.0),
          decoration: PageDecoration(
              imagePadding: EdgeInsets.only(top: size.height * 0.25),
              titlePadding: const EdgeInsets.only(bottom: 24.0),
              bodyFlex: 0,
              imageFlex: 0,
              bodyAlignment: Alignment.bottomCenter,
              imageAlignment: Alignment.center
          ),
        ),
        PageViewModel(
          title: "Express courier delivery",
          body: "Get your packages delivered at the earliest",
          image: Image.asset("assets/onboard/tut_3.png", height: 270.0),
          decoration: PageDecoration(
              imagePadding: EdgeInsets.only(top: size.height * 0.25),
              titlePadding: const EdgeInsets.only(bottom: 24.0),
              bodyFlex: 0,
              imageFlex: 0,
              bodyAlignment: Alignment.bottomCenter,
              imageAlignment: Alignment.center
          ),
        ),
      ],
      showNextButton: true,
      showSkipButton: true,
      done: const Text("Get Started", style: TextStyle(color: Colors.black),),
      skip: const Text("Skip", style: TextStyle(color: Colors.black),),
      next: const Text("Next", style: TextStyle(color: Colors.black),),
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
