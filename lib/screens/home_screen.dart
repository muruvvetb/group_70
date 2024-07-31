import 'package:cep_eczane/screens/notifications_page.dart';
import 'package:cep_eczane/services/notification_helper.dart';
import 'package:cep_eczane/services/notification_service.dart';
import 'package:flutter/material.dart';
import 'package:cep_eczane/screens/yakindaki_eczaneler.dart'; // YakindakiEczaneler dosyasını import edin

class HomePage extends StatelessWidget {
  final NotificationService _notificationService = NotificationService();
  final NotificationHelper _notificationHelper = NotificationHelper();

  HomePage({super.key});

  void main() async {
    await NotificationService().init();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cep Eczanem'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.notification_important_sharp),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => NotificationsPage()),
              );
            },
          ),
          IconButton(icon: Icon(Icons.search), onPressed: () {})
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(2.0),
            child: ElevatedButton(
              style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all<Color>(Colors.transparent),
                elevation: MaterialStateProperty.all<double>(0),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                padding: MaterialStateProperty.all<EdgeInsets>(
                  const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                ),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => YakindakiEczaneler(),
                  ),
                );
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text("Yakındaki Eczaneler",
                      style: TextStyle(fontSize: 20, color: Colors.black)),
                  Container(
                    width: double.infinity,
                    height: 300,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      image: const DecorationImage(
                        image: AssetImage('icons/map.png'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.green),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    child: const Column(
                      children: [
                        Text(
                          'İlacı Bul',
                          style: TextStyle(fontSize: 16, color: Colors.white),
                          textAlign: TextAlign.left,
                        ),
                        SizedBox(height: 10),
                        Image(
                          image: AssetImage('icons/medicine.png'),
                          height: 60,
                          fit: BoxFit.contain,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Color(0xffC64A4A)),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    child: const Column(
                      children: [
                        Text('Sipariş ver',
                            style:
                                TextStyle(fontSize: 16, color: Colors.white)),
                        SizedBox(height: 10),
                        Image(
                          image: AssetImage('icons/cart.png'),
                          height: 60,
                          fit: BoxFit.contain,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
