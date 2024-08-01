import 'package:flutter/material.dart';
import 'search_history.dart'; // Import the search history model

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<String> _filteredHistory = [];

  @override
  void initState() {
    super.initState();
    _filteredHistory = SearchHistory.history;
  }

  void _onSearchChanged(String value) {
    setState(() {
      _filteredHistory = SearchHistory.history
          .where((query) => query.toLowerCase().contains(value.toLowerCase()))
          .toList();
    });
  }

  void _onSearchSubmitted(String value) {
    setState(() {
      SearchHistory.add(value);
      _searchController.clear();
      _filteredHistory = SearchHistory.history;
    });
  }

  void _clearHistory() {
    setState(() {
      SearchHistory.clear();
      _filteredHistory = [];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('İlaç Arama'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: _clearHistory,
            tooltip: 'Arama geçmişini temizle',
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Ara',
                border: OutlineInputBorder(),
                suffixIcon: GestureDetector(
                  onTap: () => _onSearchSubmitted(_searchController.text),
                  child: Icon(Icons.search),
                ),
              ),
              onChanged: _onSearchChanged,
              onSubmitted: _onSearchSubmitted,
            ),
            const SizedBox(height: 20),
            if (_searchController.text.isEmpty)
              Expanded(
                child: ListView.builder(
                  itemCount: _filteredHistory.length,
                  itemBuilder: (context, index) {
                    final query = _filteredHistory[index];
                    return ListTile(
                      title: Text(query),
                      onTap: () {
                        _searchController.text = query;
                      },
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}
