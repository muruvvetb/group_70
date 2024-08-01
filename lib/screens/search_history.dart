// search_history.dart
class SearchHistory {
  static List<String> _history = [];

  static List<String> get history => _history;

  static void add(String query) {
    if (query.isNotEmpty) {
      // Add new query at the beginning
      _history.insert(0, query);
      // Remove duplicates and limit history size if necessary
      _history = _history.toSet().toList();
    }
  }

  static void clear() {
    _history.clear();
  }

  static void remove(String query) {
    _history.remove(query);
  }
}
