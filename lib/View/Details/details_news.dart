import 'package:flutter/material.dart';
import 'package:hacker_news/Controller/news.dart';
import 'package:hacker_news/Model/app_bar.dart';
import 'package:hacker_news/Model/parser.dart';
import 'package:intl/intl.dart';

class NewsDetailPage extends StatelessWidget {
  static String routeName = '/detailsPage';
  final News news;

  const NewsDetailPage({
    super.key,
    required this.news,
  });

  @override
  Widget build(BuildContext context) {
    final formattedTime = DateFormat('HH:mm').format(news.time);
    final formattedDate = DateFormat('d MMM, yyyy').format(news.time);

    return SafeArea(
      child: Scaffold(
        appBar: const CustomAppBar(
          title: "Hacker News",
          back: true,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  news.title,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'by ${news.author}',
                  style: const TextStyle(
                    fontSize: 18,
                    color: Colors.black54,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  '$formattedTime, $formattedDate',
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black54,
                  ),
                ),
                const SizedBox(height: 16),
                if (news.text != null && news.text!.isNotEmpty)
                  Text(
                    parseHtmlString(news.text!),
                    style: const TextStyle(
                      fontSize: 16,
                    ),
                  ),
                const SizedBox(height: 16),
                const Text(
                  'Comments:',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: news.comments.length,
                  itemBuilder: (context, index) {
                    final comment = news.comments[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Container(
                        padding: const EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'by ${comment['author']}',
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.black54,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              comment['text'],
                              style: const TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
