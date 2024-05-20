import 'package:flutter/material.dart';
import 'package:hacker_news/Controller/news.dart';
import 'package:hacker_news/Model/news_card.dart';
import 'package:hacker_news/Model/parser.dart';
import 'package:hacker_news/size.dart';
import 'package:hacker_news/Model/api.dart'; // Import ApiService

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

    try {
      List<dynamic> fetchedStoryIds = await ApiService.fetchLatestStories();
      int nextPage = currentPage + 1;
      List<dynamic> nextStories =
          fetchedStoryIds.skip(currentPage * 5).take(5).toList();

      setState(() {
        if (nextStories.isEmpty) {
          hasMoreStories = false;
        } else {
          storyIds.addAll(nextStories);
          currentPage = nextPage;
        }
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      throw Exception('Failed to load latest stories');
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
                future: ApiService.fetchStoryDetails(storyIds[index]),
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
                          List<Map<String, dynamic>> comments =
                              commentSnapshot.data!;
                          return Padding(
                            padding: EdgeInsets.all(
                                getProportionateScreenWidth(10)),
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
                                          'text': parseHtmlString(
                                              comment['text'] ?? '')
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
            }
          },
        ),
      ),
    );
  }
}
