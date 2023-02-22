import 'package:afar_cabs_user/language_change_provider.dart';
import 'package:afar_cabs_user/onboarding_page/view/onboard_page_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'dart:math' as math;

class AppLandingPage extends StatefulWidget {
  const AppLandingPage({Key? key}) : super(key: key);

  @override
  State<AppLandingPage> createState() => _AppLandingPageState();
}

class _AppLandingPageState extends State<AppLandingPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(vsync: this, duration: const Duration(seconds: 2))..repeat();

  @override
  void dispose() {
    _controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Center(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.centerRight,
              end: Alignment.centerLeft,
              colors: [
                Colors.pink.shade100,
                Colors.lightBlue.shade300,
              ],
            ),
          ),
          child: Stack(
            // mainAxisAlignment: MainAxisAlignment.center,
            // crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Align(
                alignment: Alignment.center,
                child: Image.asset(
                  "assets/images/lang-screen.png",
                  height: double.infinity,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                top: height * 0.13,
                left: width / 2.7,
                child: AnimatedBuilder(
                  animation: _controller,
                  builder: (context, child) {
                    return Transform.rotate(
                      angle: _controller.value * 2 * math.pi,
                      child: child,
                    );
                  },
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: Image.asset(
                      "assets/icon/icon.png",
                      // height: height * 0.2,
                      width: width * 0.23,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: height * 0.2,
              ),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Align(
                      alignment: Alignment.bottomLeft,
                      child: SizedBox(
                        width: width * 0.45,
                        height: height * 0.07,
                        child: ElevatedButton(
                          onPressed: () {
                            context
                                .read<LanguageChangeProvider>()
                                .changeLocale("en");
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => OnboardingScreen(),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            onPrimary: Colors.blueAccent,
                            onSurface: Colors.white54,
                            primary: Colors.white54,
                          ),
                          child: const Text(
                            "English",
                            style: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: SizedBox(
                        width: width * 0.45,
                        height: height * 0.07,
                        child: ElevatedButton(
                          onPressed: () {
                            context
                                .read<LanguageChangeProvider>()
                                .changeLocale("ta");
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => OnboardingScreen(),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            onPrimary: Colors.blueAccent,
                            onSurface: Colors.white54,
                            primary: Colors.white54,
                          ),
                          child: const Text(
                            "தமிழ்",
                            style: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
