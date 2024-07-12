import 'package:flutter/material.dart';
import 'package:cep_eczane/widgets/bottom_navigation_bar.dart'; // Dosya yolunu projenize göre düzenleyin

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
      
      bottomNavigationBar: const CustomBottomNavigationBar(), // Burada çağırıyoruz
    
    );
    
  }
}
