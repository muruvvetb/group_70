import 'package:flutter/material.dart';
import 'package:cep_eczane/screens/home_screen.dart';
import 'package:cep_eczane/screens/profile_page.dart';

class CustomBottomNavigationBar extends StatefulWidget {
  final int selectedIndex;

  const CustomBottomNavigationBar({Key? key, required this.selectedIndex}) : super(key: key);

  @override
  _CustomBottomNavigationBarState createState() => _CustomBottomNavigationBarState();
}

class _CustomBottomNavigationBarState extends State<CustomBottomNavigationBar> {
  late int _selectedIndex;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.selectedIndex;
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    switch (index) {
      case 0:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomePage(selectedIndex: 0)),
        );
        break;
      case 1:
        // Ecza Kutusu ekranı
        break;
      case 2:
        // Kamera ekranı
        break;
      case 3:
        // İlaç Alarmı ekranı
        break;
      case 4:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const ProfilePage(selectedIndex: 4)),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          height: 75,
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
                icon: _buildIcon(Icons.medical_services_outlined, Icons.medical_services, 1),
                label: 'Ecza Kutusu',
              ),
              BottomNavigationBarItem(
                icon: Container(),
                label: '',
              ),
              BottomNavigationBarItem(
                icon: _buildIcon(Icons.notifications_outlined, Icons.notifications, 3),
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
            iconSize: 24,
            selectedLabelStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
            unselectedLabelStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
          ),
        ),
        Positioned(
          bottom: 35,
          left: MediaQuery.of(context).size.width / 2 - 28,
          child: FloatingActionButton(
            onPressed: () => _onItemTapped(2),
            backgroundColor: const Color(0xFF1F3C51),
            child: const Icon(Icons.camera_alt, size: 28, color: Color.fromARGB(255, 0, 0, 0)),
            shape: const CircleBorder(),
          ),
        ),
      ],
    );
  }

  Widget _buildIcon(IconData outlineIcon, IconData filledIcon, int index) {
    final isSelected = _selectedIndex == index;
    return Container(
      decoration: BoxDecoration(
        color: isSelected ? const Color(0xFF93ABBF) : Colors.transparent,
        borderRadius: BorderRadius.circular(20),
      ),
      padding: const EdgeInsets.all(8),
      child: Icon(isSelected ? filledIcon : outlineIcon),
    );
  }
}
