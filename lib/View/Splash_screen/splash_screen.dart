import 'package:flutter/material.dart';
import 'package:hacker_news/View/Splash_screen/components/body.dart';
import 'package:hacker_news/size.dart';

class SplashScreen extends StatelessWidget {
  static String routeName = '/splash';
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return const Scaffold(
      body: Body(),
    );
  }
}
