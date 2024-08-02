import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class NewsWidget extends StatefulWidget {
  const NewsWidget({Key? key}) : super(key: key);

  @override
  _NewsWidgetState createState() => _NewsWidgetState();
}

class _NewsWidgetState extends State<NewsWidget> {
  List<dynamic> _news = [];

  @override
  void initState() {
    super.initState();
    fetchNews();
  }

  Future<void> fetchNews() async {
    final url = Uri.parse('https://api.collectapi.com/news/getNews?country=tr&tag=health');
    final response = await http.get(
      url,
      headers: {
        'authorization': 'apikey 3ciothvSUzAV9LYyNA7D7c:0AM5vokmwcOJasCd7xtlZC',
        'content-type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (mounted) {
        setState(() {
          _news = data['result'];
        });
      }
    } else {
      print('Request failed with status: ${response.statusCode}.');
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _news.isEmpty
        ? Center(child: CircularProgressIndicator())
        : ListView.builder(
            itemCount: _news.length,
            itemBuilder: (context, index) {
              final newsItem = _news[index];
              return GestureDetector(
                onTap: () async {
                  final url = newsItem['url'];
                  if (await canLaunch(url)) {
                    await launch(url);
                  } else {
                    throw 'Could not launch $url';
                  }
                },
                child: Card(
                  margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      newsItem['image'] != null
                          ? Image.network(newsItem['image'], width: 100, height: 100, fit: BoxFit.cover)
                          : Container(width: 100, height: 100, color: Colors.grey),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                newsItem['name'],
                                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: 5),
                              
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
  }

  String _shortenText(String text) {
    const maxLength = 50;
    if (text.length > maxLength) {
      return text.substring(0, maxLength) + '...';
    } else {
      return text;
    }
  }
}
