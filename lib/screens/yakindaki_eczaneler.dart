import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

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
      body: Column(
        children: [
          Expanded(
            flex: 2,
            child: GoogleMap(
              initialCameraPosition: const CameraPosition(
                target: LatLng(41.015137, 28.979530), // İstanbul koordinatları
                zoom: 14.0,
              ),
              markers: {
                const Marker(
                  markerId: MarkerId('eczane1'),
                  position: LatLng(41.015137, 28.979530), // örnek koordinat
                  infoWindow: InfoWindow(title: 'Hayat Ağacı Eczanesi'),
                ),
                const Marker(
                  markerId: MarkerId('eczane2'),
                  position: LatLng(41.021937, 28.987130), // örnek koordinat
                  infoWindow: InfoWindow(title: 'Elif Eczanesi'),
                ),
              },
            ),
          ),
          Expanded(
            flex: 1,
            child: ListView(
              children: const [
                ListTile(
                  leading: Image(
                    image: AssetImage('assets/images/pharmacy_icon.png'),
                  ),
                  title: Text('Hayat Ağacı Eczanesi'),
                  trailing: Text('1.2 Km'),
                ),
                ListTile(
                  leading: Image(
                    image: AssetImage('assets/images/pharmacy_icon.png'),
                  ),
                  title: Text('Elif Eczanesi'),
                  trailing: Text('2.4 Km'),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: ""),
          BottomNavigationBarItem(
            icon: Icon(Icons.medical_services),
            label: 'Ecza Kutusu',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: 'Profilim',
          ),
        ],
      ),
    );
  }
}
