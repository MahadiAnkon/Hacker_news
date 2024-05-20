// api.dart

import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiService {
  static Future<List<dynamic>> fetchTopStories() async {
    final response = await http.get(Uri.parse(
        'https://hacker-news.firebaseio.com/v0/topstories.json?print=pretty'));
    if (response.statusCode == 200) {
      List<dynamic> storyIds = json.decode(response.body);
      return storyIds.take(5).toList(); // Show only top 5
    } else {
      throw Exception('Failed to load top stories');
    }
  }

  static Future<List<dynamic>> fetchLatestStories() async {
    final response = await http.get(Uri.parse(
        'https://hacker-news.firebaseio.com/v0/newstories.json?print=pretty'));
    if (response.statusCode == 200) {
      List<dynamic> storyIds = json.decode(response.body);
      return storyIds.take(5).toList(); // Show only latest 5
    } else {
      throw Exception('Failed to load latest stories');
    }
  }

  static Future<Map<String, dynamic>> fetchStoryDetails(int id) async {
    final response = await http.get(Uri.parse(
        'https://hacker-news.firebaseio.com/v0/item/$id.json?print=pretty'));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load story details');
    }
  }

  static Future<List<Map<String, dynamic>>> fetchComments(List<int> commentIds) async {
    List<Map<String, dynamic>> comments = [];
    for (int id in commentIds) {
      final response = await http.get(Uri.parse(
          'https://hacker-news.firebaseio.com/v0/item/$id.json?print=pretty'));
      if (response.statusCode == 200) {
        Map<String, dynamic> comment = json.decode(response.body);
        comments.add(comment);
      }
    }
    return comments;
  }
}
