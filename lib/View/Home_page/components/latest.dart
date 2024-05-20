import 'package:flutter/material.dart';
import 'package:hacker_news/Controller/news.dart';
import 'package:hacker_news/Model/api.dart';
import 'package:hacker_news/Model/cache.dart';
import 'package:hacker_news/Model/news_card.dart';
import 'package:hacker_news/Model/parser.dart';
import 'package:hacker_news/View/Latest_news/latest_news.dart';
import 'package:hacker_news/size.dart';

class Latest extends StatefulWidget {
  const Latest({super.key});

  @override
  LatestState createState() => LatestState();
}

class LatestState extends State<Latest> {
  late Future<List<dynamic>> _latestStoriesFuture;

  @override
  void initState() {
    super.initState();
    _latestStoriesFuture = ApiService.fetchLatestStories();
  }

  Future<void> refresh() async {
    setState(() {
      _latestStoriesFuture = ApiService.fetchLatestStories();
    });
  }

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
          future: _latestStoriesFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              List<dynamic> storyIds = snapshot.data!.take(5).toList();
              return SizedBox(
                height: getProportionateScreenHeight(260),
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: storyIds.length,
                  itemBuilder: (context, index) {
                    return FutureBuilder(
                      future: CacheService.getStory(storyIds[index]),
                      builder: (context, storySnapshot) {
                        if (storySnapshot.connectionState ==
                            ConnectionState.waiting) {
                          return SizedBox(
                            width: getProportionateScreenWidth(300),
                            child: const Center(
                                child: CircularProgressIndicator()),
                          );
                        } else if (storySnapshot.hasError) {
                          return Text('Error: ${storySnapshot.error}');
                        } else {
                          Map<String, dynamic> story = storySnapshot.data!;
                          List<int> commentIds =
                              List<int>.from(story['kids'] ?? []);
                          return FutureBuilder(
                            future: CacheService.getComments(commentIds),
                            builder: (context, commentSnapshot) {
                              if (commentSnapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return SizedBox(
                                  width: getProportionateScreenWidth(300),
                                  child: const Center(
                                      child: CircularProgressIndicator()),
                                );
                              } else if (commentSnapshot.hasError) {
                                return Text('Error: ${commentSnapshot.error}');
                              } else {
                                List<Map<String, dynamic>> comments =
                                    commentSnapshot.data!;
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
                                                'author': comment['by'] ??
                                                    'Unknown commenter',
                                                'text': parseHtmlString(
                                                  comment['text'] ??
                                                      'no comment',
                                                )
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
