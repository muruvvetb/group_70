import 'package:flutter/material.dart';
import 'package:cep_eczane/screens/home_screen.dart';
import 'package:cep_eczane/screens/profile_page.dart';
import 'package:cep_eczane/screens/ilac_alarm_sayfasi.dart';
import 'package:cep_eczane/screens/medicine_box.dart';
import 'package:cep_eczane/services/notification_service.dart';

class CustomBottomNavigationBar extends StatefulWidget {
  final NotificationService notificationService;

  const CustomBottomNavigationBar({Key? key, required this.notificationService}) : super(key: key);

  @override
  _CustomBottomNavigationBarState createState() => _CustomBottomNavigationBarState();
}

class _CustomBottomNavigationBarState extends State<CustomBottomNavigationBar> {
  int _selectedIndex = 0;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    _pageController.jumpToPage(index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        children: <Widget>[
          HomePage(),
          MedicineBox(),
          Container(), // Placeholder for camera, replace with actual screen
          IlacAlarmPageWrapper(notificationService: widget.notificationService),
          ProfilePage(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
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
            icon: Container(), // Empty space for floating action button
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
      floatingActionButton: FloatingActionButton(
        heroTag: 'cameraButton',
        onPressed: () => _onItemTapped(2),
        backgroundColor: const Color(0xFF1F3C51),
        child: const Icon(Icons.camera_alt, size: 28, color: Color.fromARGB(255, 0, 0, 0)),
        shape: const CircleBorder(),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
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

class IlacAlarmPageWrapper extends StatelessWidget {
  final NotificationService notificationService;

  const IlacAlarmPageWrapper({Key? key, required this.notificationService}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IlacAlarmSayfasi(notificationService: notificationService);
  }
}
