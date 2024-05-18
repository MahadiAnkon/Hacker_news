import 'package:flutter/material.dart';
import 'package:hacker_news/View/Home_page/home_page.dart';
import 'package:hacker_news/View/Splash_screen/Splash_screen.dart';
import 'package:hacker_news/main.dart';

final Map<String, WidgetBuilder> routes = {
  SplashScreen.routeName: (context) => const SplashScreen(),
  HomePage.routeName: (context) => const HomePage(),
  '/': (context) => const MyHomePage(title: 'Hacker News Home'),
};
