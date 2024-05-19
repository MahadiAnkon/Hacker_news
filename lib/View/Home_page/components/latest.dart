import 'package:flutter/material.dart';
import 'package:hacker_news/Controller/news.dart';
import 'package:hacker_news/Model/api.dart';
import 'package:hacker_news/Model/news_card.dart';
import 'package:hacker_news/View/Latest_news/latest_news.dart';
import 'package:hacker_news/size.dart';

class latest extends StatelessWidget {
  const latest({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Latest News',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, LatestNewsPage.routeName);
              },
              child: const Text(
                'See All',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue),
              ),
            ),
          ],
        ),
        SizedBox(
          height: getProportionateScreenHeight(10),
        ),
        FutureBuilder(
          future: ApiService.fetchLatestStories(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              List<dynamic> storyIds = snapshot.data!;
              return SizedBox(
                height: getProportionateScreenHeight(300),
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: storyIds.length,
                  itemBuilder: (context, index) {
                    return FutureBuilder(
                      future: ApiService.fetchStoryDetails(storyIds[index]),
                      builder: (context, storySnapshot) {
                        if (storySnapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: CircularProgressIndicator());
                        } else if (storySnapshot.hasError) {
                          return Text('Error: ${storySnapshot.error}');
                        } else {
                          Map<String, dynamic> story = storySnapshot.data!;
                          return SizedBox(
                            width: getProportionateScreenWidth(300),
                            child: NewsCard(
                              news: News(
                                title: story['title'],
                                author: story['by'],
                                imageUrl: 'https://via.placeholder.com/400',
                                time: DateTime.fromMillisecondsSinceEpoch(
                                    story['time'] * 1000),
                              ),
                            ),
                          );
                        }
                      },
                    );
                  },
                ),
              );
            }
          },
        ),
      ],
    );
  }
}
