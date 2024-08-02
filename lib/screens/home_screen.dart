// home_page.dart
import 'package:flutter/material.dart';
import 'package:cep_eczane/screens/yakindaki_eczaneler.dart'; // YakindakiEczaneler dosyasını import edin
import 'search_screen.dart'; // Import the search screen
import 'package:cep_eczane/widgets/news.dart'; // NewsWidget dosyasını import edin

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Anasayfa'),
        centerTitle: true,
        actions: [
          
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SearchScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start, // Align items to the start
        children: [
          Padding(
            padding: const EdgeInsets.all(2.0),
            child: ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Colors.transparent),
                elevation: MaterialStateProperty.all<double>(0),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                padding: MaterialStateProperty.all<EdgeInsets>(
                  const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                ),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => YakindakiEczaneler(),
                  ),
                );
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text("Yakındaki Eczaneler",
                      style: TextStyle(fontSize: 20, color: Colors.black)),
                  Container(
                    width: double.infinity,
                    height: 300,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      image: const DecorationImage(
                        image: AssetImage('icons/map.png'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: const Text(
                "Sağlık Haberleri",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Expanded(child: NewsWidget()), // NewsWidget'ı ekleyin
        ],
      ),
    );
  }
}
