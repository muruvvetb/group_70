import 'package:flutter/material.dart';
import 'package:cep_eczane/screens/yakindaki_eczaneler.dart';
import 'search_screen.dart';
import 'weight_tracking_page.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Map<String, dynamic>> _weightEntries = [];

  @override
  void initState() {
    super.initState();
    _fetchWeightEntries();
  }

  Future<void> _fetchWeightEntries() async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId != null) {
      final QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('weight_entries')
          .doc(userId)
          .collection('entries')
          .orderBy('date')
          .get();
      final List<Map<String, dynamic>> fetchedEntries = snapshot.docs
          .map((doc) => {
                'date': (doc['date'] as Timestamp).toDate(),
                'weight': doc['weight'],
              })
          .toList();
      setState(() {
        _weightEntries = fetchedEntries;
      });
    }
  }

  List<FlSpot> _generateSpots() {
    if (_weightEntries.isEmpty) {
      return [FlSpot(0, 78)];
    }
    return _weightEntries
        .asMap()
        .entries
        .map((entry) => FlSpot(
              entry.key.toDouble(),
              entry.value['weight'],
            ))
        .toList();
  }

  void _onWeightEntryAdded() {
    setState(() {
      _fetchWeightEntries();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Anasayfa'),
        centerTitle: true,
        actions: [
          
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SearchScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Colors.transparent),
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
          GestureDetector(
            onTap: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => WeightTrackingPage(
                    onWeightEntryAdded: _onWeightEntryAdded,
                  ),
                ),
              );
              _onWeightEntryAdded(); // Bu satır eklendi
            },
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                width: double.infinity,
                height: 250,
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Theme.of(context).scaffoldBackgroundColor, // Ana ekranın arka plan rengiyle aynı
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: LineChart(
                  LineChartData(
                    backgroundColor: Colors.transparent,
                    gridData: FlGridData(
                      show: true, // Gridleri göster
                      horizontalInterval: 1,
                      verticalInterval: 1,
                      getDrawingHorizontalLine: (value) {
                        return FlLine(
                          color: Colors.grey.withOpacity(0.5),
                          strokeWidth: 1,
                        );
                      },
                      getDrawingVerticalLine: (value) {
                        return FlLine(
                          color: Colors.grey.withOpacity(0.5),
                          strokeWidth: 1,
                        );
                      },
                    ),
                    titlesData: FlTitlesData(
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 40,
                          getTitlesWidget: (value, meta) {
                            return Text(
                              value.toString(),
                              style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 12,
                              ),
                            );
                          },
                        ),
                      ),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(showTitles: false), // Alttaki tarihleri gizlemek için
                      ),
                      rightTitles: AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      topTitles: AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                    ),
                    borderData: FlBorderData(
                      show: true,
                      border: Border.all(color: Colors.transparent, width: 2), // Kenarlıkları kaldır
                    ),
                    minX: 0,
                    maxX: (_weightEntries.isNotEmpty
                            ? _weightEntries.length - 1
                            : 1)
                        .toDouble(),
                    minY: _weightEntries.isNotEmpty
                        ? _weightEntries
                                .map((entry) => entry['weight'])
                                .reduce((a, b) => a < b ? a : b) -
                            2
                        : 75,
                    maxY: _weightEntries.isNotEmpty
                        ? _weightEntries
                                .map((entry) => entry['weight'])
                                .reduce((a, b) => a > b ? a : b) +
                            2
                        : 85,
                    lineBarsData: [
                      LineChartBarData(
                        spots: _generateSpots(),
                        isCurved: true,
                        color: Color.fromARGB(255, 148, 189, 222),
                        barWidth: 4,
                        dotData: FlDotData(show: true),
                        belowBarData: BarAreaData(
                          show: true,
                          gradient: LinearGradient(
                            colors: [
                              Colors.blue.withOpacity(0.3),
                              Colors.blue.withOpacity(0.0),
                            ],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

void main() {
  runApp(const MaterialApp(
    home: HomePage(),
  ));
}
