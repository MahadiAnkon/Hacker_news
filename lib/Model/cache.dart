import 'package:hacker_news/Model/api.dart';

class CacheService {
  static final Map<int, Map<String, dynamic>> _storyCache = {};
  static final Map<int, Map<String, dynamic>> _commentsCache = {};

  static Future<Map<String, dynamic>> getStory(int id) async {
    if (_storyCache.containsKey(id)) {
      return _storyCache[id]!;
    } else {
      final story = await ApiService.fetchStoryDetails(id);
      _storyCache[id] = story;
      return story;
    }
  }

  static Future<List<Map<String, dynamic>>> getComments(List<int> commentIds) async {
    final List<Map<String, dynamic>> comments = [];
    for (final id in commentIds) {
      if (_commentsCache.containsKey(id)) {
        comments.add(_commentsCache[id]!);
      } else {
        final comment = await ApiService.fetchComment(id);
        _commentsCache[id] = comment;
        comments.add(comment);
      }
    }
    return comments;
  }

  static void clearCache() {
    _storyCache.clear();
    _commentsCache.clear();
  }
}
