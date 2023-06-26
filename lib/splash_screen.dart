import 'package:ebooks/welcome/welcome_page.dart';
import 'package:flutter/material.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:page_transition/page_transition.dart';

class Splash extends StatelessWidget {
  const Splash({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: '',
        home: AnimatedSplashScreen(
            splashIconSize: 200.0,
            duration: 2000,
            centered: true,
            splash: 'img/CK_logo.png',
            nextScreen: const Welcome(),
            splashTransition: SplashTransition.scaleTransition,
            pageTransitionType: PageTransitionType.bottomToTop,
            backgroundColor: Colors.white));
  }
}
