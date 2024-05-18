import 'package:flutter/material.dart';
import 'package:hacker_news/size.dart';

class CategoryCard extends StatelessWidget {
  const CategoryCard({
    super.key,
    required this.count2,
    required this.text,
    required this.press,
  });

  final String? text;
  final int count2;
  final GestureTapCallback press;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: press,
      child: SizedBox(
        width: double.infinity,
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(15),
              height: getProportionateScreenHeight(200),
              width: double.infinity,
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 88, 21, 222),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Icon(Icons.phone_android_outlined),
                  const SizedBox(height: 5),
                  Text(count2.toString(), textAlign: TextAlign.center)
                ],
              ),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
