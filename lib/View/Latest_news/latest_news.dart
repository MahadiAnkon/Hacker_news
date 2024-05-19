import 'package:flutter/material.dart';
import 'package:hacker_news/Controller/news.dart';
import 'package:hacker_news/Model/news_card.dart';
import 'package:hacker_news/size.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LatestNewsPage extends StatefulWidget {
  static String routeName = '/latestNews';

  const LatestNewsPage({super.key});

  @override
  _LatestNewsPageState createState() => _LatestNewsPageState();
}

class _LatestNewsPageState extends State<LatestNewsPage> {
  List<dynamic> storyIds = [];
  int currentPage = 0;
  bool isLoading = false;
  bool hasMoreStories = true;

  @override
  void initState() {
    super.initState();
    fetchMoreStories();
  }

  Future<void> fetchMoreStories() async {
    if (isLoading || !hasMoreStories) return;

    setState(() {
      isLoading = true;
    });

    final response = await http.get(Uri.parse(
        'https://hacker-news.firebaseio.com/v0/newstories.json?print=pretty'));
    if (response.statusCode == 200) {
      List<dynamic> fetchedStoryIds = json.decode(response.body);
      int nextPage = currentPage + 1;
      List<dynamic> nextStories =
          fetchedStoryIds.skip(currentPage * 1).take(5).toList();

      setState(() {
        if (nextStories.isEmpty) {
          hasMoreStories = false;
        } else {
          storyIds.addAll(nextStories);
          currentPage = nextPage;
        }
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
      throw Exception('Failed to load latest stories');
    }
  }

  Future<Map<String, dynamic>> fetchStoryDetails(int id) async {
    final response = await http.get(Uri.parse(
        'https://hacker-news.firebaseio.com/v0/item/$id.json?print=pretty'));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load story details');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Latest News'),
      ),
      body: NotificationListener<ScrollNotification>(
        onNotification: (ScrollNotification scrollInfo) {
          if (!isLoading &&
              hasMoreStories &&
              scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent) {
            fetchMoreStories();
            return true;
          }
          return false;
        },
        child: ListView.builder(
          itemCount: storyIds.length + (hasMoreStories ? 1 : 0),
          itemBuilder: (context, index) {
            if (index == storyIds.length) {
              return const Center(child: CircularProgressIndicator());
            } else {
              return FutureBuilder(
                future: fetchStoryDetails(storyIds[index]),
                builder: (context, storySnapshot) {
                  if (storySnapshot.connectionState ==
                      ConnectionState.waiting) {
                    return const SizedBox(
                      height: 200,
                      child: Center(child: CircularProgressIndicator()),
                    );
                  } else if (storySnapshot.hasError) {
                    return Text('Error: ${storySnapshot.error}');
                  } else {
                    Map<String, dynamic> story = storySnapshot.data!;
                    return Padding(
                      padding: EdgeInsets.all(getProportionateScreenWidth(10)),
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
            }
          },
        ),
      ),
    );
  }
}
