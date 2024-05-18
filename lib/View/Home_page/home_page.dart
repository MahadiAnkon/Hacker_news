import 'package:flutter/material.dart';
import 'package:hacker_news/Model/app_bar.dart';
import 'package:hacker_news/Model/bottom_nav.dart';
import 'package:hacker_news/View/Home_page/components/body.dart';

class HomePage extends StatelessWidget {
  static String routeName = '/homepage';
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: CustomAppBar(
        title: 'Hacker News',
      ),
      body: Body(),
      bottomNavigationBar: CustomBottomNavigationBar(
        selectedIndex: 0,
      ),
    );
  }
}
