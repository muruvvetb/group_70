import 'package:flutter/material.dart';

class CustomBottomNavigationBar extends StatefulWidget {
  const CustomBottomNavigationBar({Key? key}) : super(key: key);

  @override
  _CustomBottomNavigationBarState createState() => _CustomBottomNavigationBarState();
}

class _CustomBottomNavigationBarState extends State<CustomBottomNavigationBar> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 74,
      child: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: _buildIcon(Icons.home_outlined, 0),
            label: 'Anasayfa',
          ),
          BottomNavigationBarItem(
            icon: _buildIcon(Icons.medical_services_outlined, 1),
            label: 'Ecza Kutusu',
          ),
          BottomNavigationBarItem(
            icon: _buildIcon(Icons.camera_alt, 2),
            label: 'Kamera',
            backgroundColor: Colors.red,
           

          ),
          BottomNavigationBarItem(
            icon: _buildIcon(Icons.notifications_outlined, 3),
            label: 'İlaç Alarmı',
          ),
          BottomNavigationBarItem(
            icon: _buildIcon(Icons.person_outline, 4),
            label: 'Profilim',
          ),
        ],
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.black,
        backgroundColor: const Color(0xFFD5E7F2),
        iconSize: 24, // İkonların boyutunu ayarlıyoruz
        selectedLabelStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold), // Seçili öğenin yazı boyutu
        unselectedLabelStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold), // Seçili olmayan öğelerin yazı boyutu
      ),
    );
  }

  Widget _buildIcon(IconData iconData, int index) {
    final isSelected = _selectedIndex == index;
    return Container(
      decoration: isSelected
          ? BoxDecoration(
              color: const Color(0xFF93ABBF), // Seçili öğe arka plan rengi
              borderRadius: BorderRadius.circular(20),
            )
          : null,
      padding: const EdgeInsets.all(8),
      child: Icon(iconData),
    );
  }
}
