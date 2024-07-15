import 'package:flutter/material.dart';
import 'package:cep_eczane/widgets/bottom_navigation_bar.dart'; // Dosya yolunu projenize göre düzenleyin
import 'package:cep_eczane/widgets/pharmacy_tile.dart'; // PharmacyTile dosyasını import edin

class YakindakiEczaneler extends StatelessWidget {
  const YakindakiEczaneler({Key? key}) : super(key: key);

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
            // Gri renkli kare Container
            Container(
              width: double.infinity,
              height: 400,
              color: Colors.grey,
              child: const Center(
                child: Text(
                  'Gri Kare',
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
              ),
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
      bottomNavigationBar: const CustomBottomNavigationBar(), // Burada çağırıyoruz
    );
  }
}