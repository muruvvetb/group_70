import 'package:flutter/material.dart';

class CustomBottomNavigationBar extends StatefulWidget {
  const CustomBottomNavigationBar({Key? key}) : super(key: key);

  @override
  _CustomBottomNavigationBarState createState() =>
      _CustomBottomNavigationBarState();
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
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          height: 74,
          child: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            currentIndex: _selectedIndex,
            onTap: _onItemTapped,
            items: <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: _buildIcon(Icons.home_outlined, Icons.home, 0),
                label: 'Anasayfa',
              ),
              BottomNavigationBarItem(
                icon: _buildIcon(
                    Icons.medical_services_outlined, Icons.medical_services, 1),
                label: 'Ecza Kutusu',
              ),
              BottomNavigationBarItem(
                icon: Container(), // Boş bir widget olarak bırakıyoruz
                label: '',
              ),
              BottomNavigationBarItem(
                icon: _buildIcon(
                    Icons.notifications_outlined, Icons.notifications, 3),
                label: 'İlaç Alarmı',
              ),
              BottomNavigationBarItem(
                icon: _buildIcon(Icons.person_outline, Icons.person, 4),
                label: 'Profilim',
              ),
            ],
            selectedItemColor: Colors.black,
            unselectedItemColor: Colors.black,
            backgroundColor: const Color(0xFFD5E7F2),
            iconSize: 24, // İkonların boyutunu ayarlıyoruz
            selectedLabelStyle: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold), // Seçili öğenin yazı boyutu
            unselectedLabelStyle: const TextStyle(
                fontSize: 12,
                fontWeight:
                    FontWeight.bold), // Seçili olmayan öğelerin yazı boyutu
          ),
        ),
        Positioned(
          bottom: 35, // Yükseklik ayarları
          left: MediaQuery.of(context).size.width / 2 - 28, // Ortaya hizalama

          child: FloatingActionButton(
            onPressed: () => _onItemTapped(2), // Kamera ikonuna tıklanma
            backgroundColor:
                const Color(0xFF1F3C51), // Etrafındaki çemberin rengi

            child: const Icon(Icons.camera_alt,
                size: 28,
                color: Color.fromARGB(255, 255, 255, 255)), // Kamera ikonu
            // shape: CircleBorder(CircleBorder.size(40)), // Daire şeklinde buton
          ),
        ),
      ],
    );
  }

  Widget _buildIcon(IconData outlineIcon, IconData filledIcon, int index) {
    final isSelected = _selectedIndex == index;
    return Container(
      decoration: isSelected
          ? BoxDecoration(
              color: const Color(0xFF93ABBF), // Seçili öğe arka plan rengi
              borderRadius: BorderRadius.circular(20),
            )
          : null,
      padding: const EdgeInsets.all(8),
      child: Icon(isSelected ? filledIcon : outlineIcon),
    );
  }
}
