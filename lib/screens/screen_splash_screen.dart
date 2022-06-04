import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:money_management_app_using_flutter/screens/screen_navigation.dart';

class ScreenSplashScreen extends StatefulWidget {
  const ScreenSplashScreen({Key? key}) : super(key: key);

  @override
  State<ScreenSplashScreen> createState() => _ScreenSplashScreenState();
}

class _ScreenSplashScreenState extends State<ScreenSplashScreen> {
  @override
  void initState() {
    _navigateToHome();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          gradient: LinearGradient(
              colors: [Color(0xFF6DD5ED), Color(0xFF2193B0)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight)),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(
          child: SafeArea(
              child: Column(
            children: [
              const SizedBox(
                height: 20,
              ),
              AnimatedTextKit(
                animatedTexts: [
                  WavyAnimatedText('MONEY TRACKER',
                      textStyle: const TextStyle(
                          fontFamily: 'ZenDots',
                          fontSize: 30,
                          color: Color.fromARGB(255, 255, 255, 255)),
                      speed: const Duration(milliseconds: 70)),
                ],
                isRepeatingAnimation: true,
              ),
              const SizedBox(
                height: 70,
              ),
              const Image(image: AssetImage('assets/images/MoneyManager.png')),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                height: 130,
                width: 130,
                child: Lottie.asset('assets/animations/89118-money.json',
                    fit: BoxFit.fill),
              )
            ],
          )),
        ),
      ),
    );
  }

  _navigateToHome() async {
    await Future.delayed(const Duration(milliseconds: 3500));
    Get.offAll(() => ScreenNavigation());
  }
}
