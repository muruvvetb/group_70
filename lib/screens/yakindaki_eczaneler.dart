import 'package:flutter/material.dart';
import 'package:cep_eczane/widgets/pharmacy_tile.dart'; // PharmacyTile dosyasını import edin
import 'package:cep_eczane/widgets/yakindaki_map.dart'; // Import the YakindakiMap widget

class YakindakiEczaneler extends StatefulWidget {
  const YakindakiEczaneler({super.key});

  @override
  State<YakindakiEczaneler> createState() => _YakindakiEczanelerState();
}

class _YakindakiEczanelerState extends State<YakindakiEczaneler> {
  List<dynamic> _pharmacies = [];

  void _updatePharmacies(List<dynamic> pharmacies) {
    setState(() {
      _pharmacies = pharmacies;
    });
  }

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
              height: MediaQuery.of(context).size.height * 0.55, // Yüksekliği artırıyoruz
              child: MapPage(onPharmaciesFetched: _updatePharmacies),
            ),
            const SizedBox(height: 20),
            // Metinlerin olduğu Container'lar
            Expanded(
              child: ListView.builder(
                itemCount: _pharmacies.length,
                itemBuilder: (context, index) {
                  var pharmacy = _pharmacies[index];
                  return PharmacyTile(
                    name: pharmacy['pharmacyName'] ?? 'No name',
                    distance: pharmacy['distanceKm']?.toString() ?? 'Unknown',
                    address: pharmacy['address'] ?? 'No address',
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
