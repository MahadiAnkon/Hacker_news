import 'package:flutter/material.dart';
import 'package:hacker_news/View/Home_page/components/latest.dart';
import 'package:hacker_news/View/Home_page/components/top.dart';
import 'package:hacker_news/size.dart';

class Body extends StatelessWidget {
  const Body({super.key});

  @override
  Widget build(BuildContext context) {
    
    return SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(getProportionateScreenWidth(10)),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Top(),
              SizedBox(height: 20),
              Latest(),
            ],
          ),
        ),
      ),
    );
  }
}
