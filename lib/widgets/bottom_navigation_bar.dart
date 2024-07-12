
import 'package:flutter/material.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  const CustomBottomNavigationBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(icon: Icon(Icons.home), label: "Anasayfa"),
        BottomNavigationBarItem(
          icon: Icon(Icons.medical_services),
          label: 'Ecza Kutusu',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.camera_alt),
          label: 'Kamera',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.notifications),
          label: 'İlaç Alarmı',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.account_circle),
          label: 'Profilim',
        ),
      ],
    );
  }
}
