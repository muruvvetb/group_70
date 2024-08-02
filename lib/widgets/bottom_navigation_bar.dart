import 'dart:developer';
import 'package:cep_eczane/screens/text_bulma.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cep_eczane/screens/home_screen.dart';
import 'package:cep_eczane/screens/profile_page.dart';
import 'package:cep_eczane/screens/ilac_alarm_sayfasi.dart';
import 'package:cep_eczane/screens/medicine_box.dart';
import 'package:cep_eczane/services/notification_service.dart';
import 'package:cep_eczane/services/firestore_service.dart'; // FirestoreService import edildi
import 'package:cep_eczane/utils/image_cropper.dart';
import 'package:cep_eczane/utils/image_picker_class.dart';
import 'package:cep_eczane/widgets/dialog_widget.dart';

class CustomBottomNavigationBar extends StatefulWidget {
  final NotificationService notificationService;
  final FirestoreService firestoreService; // FirestoreService parametresi eklendi

  const CustomBottomNavigationBar({
    Key? key,
    required this.notificationService,
    required this.firestoreService,
  }) : super(key: key);

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
    if (index == 2) {
      _showImagePickerModal();
    } else {
      setState(() {
        _selectedIndex = index;
      });
      _pageController.jumpToPage(index);
    }
  }

  void _showImagePickerModal() {
    imagePickerModal(context, onCameraTap: () {
      log("Camera");
      pickImage(source: ImageSource.camera).then((value) {
        if (value != '') {
          imageCropperView(value, context).then((value) {
            if (value != '') {
              Navigator.push(
                context,
                CupertinoPageRoute(
                  builder: (_) => RecognizePage(
                    path: value,
                  ),
                ),
              );
            }
          });
        }
      });
    }, onGalleryTap: () {
      log("Gallery");
      pickImage(source: ImageSource.gallery).then((value) {
        if (value != '') {
          imageCropperView(value, context).then((value) {
            if (value != '') {
              Navigator.push(
                context,
                CupertinoPageRoute(
                  builder: (_) => RecognizePage(
                    path: value,
                  ),
                ),
              );
            }
          });
        }
      });
    });
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
          Container(), // This remains empty as the modal will handle camera/gallery
          IlacAlarmPageWrapper(
            notificationService: widget.notificationService,
            firestoreService: widget.firestoreService, // FirestoreService parametresi eklendi
          ),
          ProfilePage(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        onTap: (index) {
          if (index != 2) {
            _onItemTapped(index);
          }
        },
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
            icon: Icon(Icons.camera_alt, size: 28, color: Color.fromRGBO(213, 231, 242, 1)), // Placeholder for camera, replace with actual screen
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
        backgroundColor: Color.fromARGB(255, 213, 231, 242),
        iconSize: 24,
        selectedLabelStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
        unselectedLabelStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
      ),
      floatingActionButton: Transform.translate(
        offset: Offset(0, 15), // Adjust the offset to move the button down
        child: FloatingActionButton(
          heroTag: 'cameraButton',
          onPressed: () => _onItemTapped(2),
          backgroundColor: const Color(0xFF1F3C51),
          shape: CircleBorder(), // This makes the FloatingActionButton circular
          child: const Icon(Icons.camera_alt, size: 28, color: Color.fromARGB(255, 0, 0, 0)),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  Widget _buildIcon(IconData outlineIcon, IconData filledIcon, int index) {
    final isSelected = _selectedIndex == index;
    return Container(
      decoration: BoxDecoration(
        color: isSelected ? const Color(0xFF93ABBF) : Colors.transparent,
        shape: BoxShape.circle,
      ),
      padding: const EdgeInsets.all(8),
      child: Icon(isSelected ? filledIcon : outlineIcon),
    );
  }
}

class IlacAlarmPageWrapper extends StatelessWidget {
  final NotificationService notificationService;
  final FirestoreService firestoreService;

  const IlacAlarmPageWrapper({
    Key? key,
    required this.notificationService,
    required this.firestoreService,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IlacAlarmSayfasi(
      notificationService: notificationService,
      firestoreService: firestoreService,
    );
  }
}
