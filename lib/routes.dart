import 'package:flutter/material.dart';
import 'package:hacker_news/View/Latest_news/latest_news.dart';
import 'package:hacker_news/View/Top_news/top_news.dart';
import 'package:hacker_news/View/Home_page/home_page.dart';
import 'package:hacker_news/View/Splash_screen/Splash_screen.dart';

final Map<String, WidgetBuilder> routes = {
  SplashScreen.routeName: (context) => const SplashScreen(),
  HomePage.routeName: (context) => const HomePage(),
  TopNewsPage.routeName: (context) => const TopNewsPage(),
  LatestNewsPage.routeName: (context) => const LatestNewsPage(),
};
