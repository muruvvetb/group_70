import 'package:flutter/material.dart';
import 'package:cep_eczane/widgets/pharmacy_tile.dart'; // PharmacyTile dosyasını import edin
import 'package:cep_eczane/widgets/yakindaki_map.dart'; // Import the YakindakiMap widget

class YakindakiEczaneler extends StatelessWidget {
  const YakindakiEczaneler({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text('Yakındaki Eczaneler'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // Arama fonksiyonu buraya eklenecek
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Replace the grey square Container with the YakindakiMap widget
            Container(
              width: double.infinity,
              height: MediaQuery.of(context).size.height * 0.6, // Yüksekliği artırıyoruz
              child: MapPage(),
            ),
            const SizedBox(height: 20),
            // Metinlerin olduğu Container'lar
            Expanded(
              child: ListView(
                children: const [
                  PharmacyTile(name: 'Hayat Ağacı Eczanesi', distance: '1.2 Km'),
                  PharmacyTile(name: 'Elif Eczanesi', distance: '2.4 Km'),
                  // Daha fazla eczane ekleyebilirsiniz
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
