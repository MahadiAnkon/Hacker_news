import 'package:flutter/material.dart';
import 'package:hacker_news/Controller/news.dart';
import 'package:hacker_news/Model/api.dart';
import 'package:hacker_news/Model/cache.dart';
import 'package:hacker_news/Model/news_card.dart';
import 'package:hacker_news/Model/parser.dart';

class TopNewsPage extends StatefulWidget {
  static String routeName = '/topNews';

  const TopNewsPage({super.key});

  @override
  _TopNewsPageState createState() => _TopNewsPageState();
}

class _TopNewsPageState extends State<TopNewsPage> {
  List<dynamic> allStoryIds = [];
  List<dynamic> storyIds = [];
  int currentPage = 0;
  bool isLoading = false;
  bool hasMoreStories = true;

  @override
  void initState() {
    super.initState();
    fetchInitialStories();
  }

  Future<void> fetchInitialStories() async {
    setState(() {
      isLoading = true;
    });

    try {
      List<dynamic> fetchedStoryIds = await ApiService.fetchTopStories();
      setState(() {
        allStoryIds = fetchedStoryIds;
        storyIds = allStoryIds.take(5).toList();
        currentPage = 1;
        hasMoreStories = allStoryIds.length > storyIds.length;
      });
    } catch (e) {
      throw Exception('Failed to load top stories');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> fetchMoreStories() async {
    if (isLoading || !hasMoreStories) return;

    setState(() {
      isLoading = true;
    });

    try {
      int start = currentPage * 5;
      List<dynamic> nextStories = allStoryIds.skip(start).take(5).toList();

      setState(() {
        if (nextStories.isEmpty) {
          hasMoreStories = false;
        } else {
          storyIds.addAll(nextStories);
          currentPage += 1;
        }
      });
    } catch (e) {
      throw Exception('Failed to load more top stories');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Top News'),
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
              return const Padding(
                padding: EdgeInsets.all(8.0),
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            } else {
              return FutureBuilder(
                future: CacheService.getStory(storyIds[index]),
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
                      future: CacheService.getComments(commentIds),
                      builder: (context, commentSnapshot) {
                        if (commentSnapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const SizedBox(
                            height: 200,
                            child: Center(child: CircularProgressIndicator()),
                          );
                        } else if (commentSnapshot.hasError) {
                          return Text('Error: ${commentSnapshot.error}');
                        } else {
                          List<Map<String, dynamic>> comments =
                              commentSnapshot.data!;
                          return Padding(
                            padding: const EdgeInsets.all(10),
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
                                            comment['text'] ?? 'no comment',
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
            }
          },
        ),
      ),
    );
  }
}
