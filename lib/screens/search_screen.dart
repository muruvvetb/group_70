import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'search_history.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<String> _filteredHistory = [];
  List<Map<String, dynamic>> _searchResults = [];

  @override
  void initState() {
    super.initState();
    _filteredHistory = SearchHistory.history;
  }

  void _onSearchChanged(String query) async {
    setState(() {
      _filteredHistory = SearchHistory.history
          .where((item) => item.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });

    if (query.isNotEmpty) {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('Prospectuses')
          .where('medicine_name', isGreaterThanOrEqualTo: query)
          .where('medicine_name', isLessThanOrEqualTo: query + '\uf8ff')
          .get();

      setState(() {
        _searchResults = snapshot.docs
            .map((doc) => {
                  'medicine_name': doc['medicine_name'],
                  'content': doc['content'],
                })
            .toList();
      });
    } else {
      setState(() {
        _searchResults = [];
      });
    }
  }

  void _onSearchSubmitted(String value) {
    setState(() {
      SearchHistory.add(value);
      _searchController.clear();
      _filteredHistory = SearchHistory.history;
      _onSearchChanged(value);
    });
  }

  void _clearHistory() {
    setState(() {
      SearchHistory.clear();
      _filteredHistory = [];
    });
  }

  void _showProspectus(String content) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Text(content),
        ),
      ),
    );
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
            if (_searchResults.isNotEmpty)
              Expanded(
                child: ListView.builder(
                  itemCount: _searchResults.length,
                  itemBuilder: (context, index) {
                    final result = _searchResults[index];
                    return ListTile(
                      title: Text(result['medicine_name']),
                      onTap: () => _showProspectus(result['content']),
                    );
                  },
                ),
              ),
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
                        _onSearchChanged(query);
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
