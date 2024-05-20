import 'package:flutter/material.dart';
import 'package:hacker_news/Controller/news.dart';
import 'package:hacker_news/Model/api.dart';
import 'package:hacker_news/Model/news_card.dart';
import 'package:hacker_news/Model/parser.dart';
import 'package:hacker_news/View/Top_news/top_news.dart';
import 'package:hacker_news/size.dart';

class Top extends StatelessWidget {
  const Top({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Top News',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, TopNewsPage.routeName);
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
        SizedBox(height: getProportionateScreenHeight(10)),
        FutureBuilder(
          future: ApiService.fetchTopStories(),
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
                          List<int> commentIds = List<int>.from(story['kids'] ?? []);
                          return FutureBuilder(
                            future: ApiService.fetchComments(commentIds),
                            builder: (context, commentSnapshot) {
                              if (commentSnapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const Center(
                                    child: CircularProgressIndicator());
                              } else if (commentSnapshot.hasError) {
                                return Text('Error: ${commentSnapshot.error}');
                              } else {
                                List<Map<String, dynamic>> comments = commentSnapshot.data!;
                                return SizedBox(
                                  width: getProportionateScreenWidth(300),
                                  child: NewsCard(
                                    news: News(
                                      title: story['title'] ?? 'No title',
                                      author: story['by'] ?? 'Unknown author',
                                      text: story['text'],
                                      time: DateTime.fromMillisecondsSinceEpoch(
                                          story['time'] * 1000),
                                      comments: comments
                                          .map((comment) => {
                                                'author': comment['by'],
                                                'text': parseHtmlString(comment['text'] ?? '')
                                              })
                                          .toList(),
                                      commentsCount: comments.length,
                                    ),
                                  ),
                                );
                              }
                            },
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
