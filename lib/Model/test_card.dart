import 'package:flutter/material.dart';
import 'package:hacker_news/size.dart';

class Newcard extends StatelessWidget {
  final double width;
  final double aspectRetio;
  final String? heroTag;
  const Newcard({
    super.key,
    this.width = double.infinity,
    this.aspectRetio = 1.1,
    this.heroTag,
  });

  @override
  Widget build(BuildContext context) {
    final uniqueHeroTag = heroTag ?? UniqueKey().toString();
    return Padding(
      padding: EdgeInsets.all(getProportionateScreenWidth(10)),
      child: SizedBox(
        width: width,
        child: GestureDetector(
          onTap: () {
            Navigator.pushNamed(context, '/');
          },
          child: AspectRatio(
            aspectRatio: 1.2,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.redAccent.withOpacity(0.1),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Hero(
                tag: uniqueHeroTag,
                child: Column(
                  children: [
                    Stack(
                      children: <Widget>[
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.network(
                            'https://via.placeholder.com/400', // Placeholder image URL
                            fit: BoxFit.fitWidth,
                            height: getProportionateScreenHeight(110),
                            width: double.infinity,
                          ),
                        ),
                        const Text("0"),
                      ],
                    ),
                    Expanded(
                      child: Container(
                        decoration: const BoxDecoration(
                          color: Colors.white70,
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(15),
                            bottomRight: Radius.circular(15),
                          ),
                        ),
                        child: Column(
                          children: [
                            const Spacer(),
                            const Text(
                              'Store Title',
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                              maxLines: 2,
                            ),
                            const Text(
                              "Store Address, Subdistrict",
                              textAlign: TextAlign.center,
                              maxLines: 2,
                            ),
                            const Spacer(),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                // Replace this with your distance calculation logic
                                Text(
                                  "Distance Placeholder",
                                  style: TextStyle(
                                    fontSize: getProportionateScreenWidth(14),
                                    color: Colors.amber,
                                  ),
                                ),
                                // Replace this with your favorite button logic
                                IconButton(
                                  onPressed: () {
                                    // Handle favorite button tap
                                  },
                                  icon: const Icon(
                                    Icons.favorite_border,
                                    color: Colors.redAccent,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
