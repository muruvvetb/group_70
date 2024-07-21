import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  final List<Widget> _pages = [
    Container(color: Colors.red),
    Container(color: Colors.blue),
    Container(color: Colors.black),
    Container(color: Colors.pink),
    Container(color: Colors.green),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Anasayfa'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              // padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                  style: ButtonStyle(
                      foregroundColor:
                          WidgetStateProperty.all<Color>(Colors.white),
                      backgroundColor: WidgetStateProperty.all(Colors.indigo),
                      shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10))),
                      padding: WidgetStateProperty.all<EdgeInsets>(
                          EdgeInsets.symmetric(vertical: 20, horizontal: 20))),
                  onPressed: () => {},
                  child: Column(
                    children: [
                      Text("Yakindaki Eczaneler",
                          style: TextStyle(fontSize: 20)),
                      Image.asset(
                        'icons/map.png', // Placeholder for the map
                        // fit: BoxFit.cover,
                        fit: BoxFit.fill,
                      )
                    ],
                  )),
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
                        foregroundColor:
                            WidgetStateProperty.all<Color>(Colors.white),
                        backgroundColor: WidgetStateProperty.all(Colors.green),
                        shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ))),
                    child: const Column(
                      children: [
                        Text(
                          'İlacı Bul',
                          style: TextStyle(fontSize: 16, color: Colors.white),
                          textAlign: TextAlign.left,
                        ),
                        // Icon(Icons.medication, size: 50),
                        Image(
                          image: AssetImage('icons/medicine.png'),
                          height: 60,
                          // width: 60,
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
                        foregroundColor:
                            WidgetStateProperty.all<Color>(Colors.white),
                        backgroundColor:
                            WidgetStateProperty.all(const Color(0xffC64A4A)),
                        shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)))),
                    child: const Column(
                      children: [
                        Text('Sipariş ver', style: TextStyle(fontSize: 16)),
                        Image(
                          image: AssetImage('icons/cart.png'),
                          height: 60,
                          // width: 60,
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

      /* Buradaki navigation bar ismail'in navigationbar'i kullanilacagi icin yorum satirina alindi. */
      // bottomNavigationBar: BottomAppBar(
      //   color: const Color(0xffD5E7F2),
      //   child: Row(
      //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      //     children: <Widget>[
      //       _buildBottomNavigationBarItem(Icons.home, 'Anasayfa', 0),
      //       _buildBottomNavigationBarItem(
      //           Icons.local_pharmacy, 'Ecza Kutusu', 1),
      //       _buildBottomNavigationBarItem(Icons.camera_alt, '', 2),
      //       _buildBottomNavigationBarItem(Icons.alarm, 'İlaç Alarmı', 3),
      //       _buildBottomNavigationBarItem(Icons.person, 'Profilim', 4),
      //     ],
      //   ),
      // ),,
    );
  }

  Widget _buildBottomNavigationBarItem(IconData icon, String label, int index) {
    bool isSelected = _selectedIndex == index;
    return GestureDetector(
      onTap: () => _onItemTapped(index),
      child: Flexible(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              decoration: isSelected
                  ? BoxDecoration(
                      // shape: BoxShape.circle,

                      border: Border.all(
                          color: const Color(0xff93ABBF), width: 0.0),
                      borderRadius: BorderRadius.circular(20),
                      color: const Color(0xff93ABBF),
                    )
                  : const BoxDecoration(),
              padding:
                  const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
              child: Icon(icon, color: Colors.black),
            ),
            if (label.isNotEmpty) Text(label),
          ],
        ),
      ),
    );
  }
}
