import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class WeightTrackingPage extends StatefulWidget {
  final Function onWeightEntryAdded;

  const WeightTrackingPage({super.key, required this.onWeightEntryAdded});

  @override
  _WeightTrackingPageState createState() => _WeightTrackingPageState();
}

class _WeightTrackingPageState extends State<WeightTrackingPage> {
  final List<Map<String, dynamic>> _weightEntries = [];
  final TextEditingController _weightController = TextEditingController();
  String? userId;

  @override
  void initState() {
    super.initState();
    _initializeUserId();
    _fetchWeightEntries();
  }

  Future<void> _initializeUserId() async {
    User? user = FirebaseAuth.instance.currentUser;
    setState(() {
      userId = user?.uid;
    });
  }

  Future<void> _fetchWeightEntries() async {
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
        _weightEntries.addAll(fetchedEntries);
      });
    }
  }

  Future<void> _saveWeightEntryToFirestore(String weight) async {
    if (userId != null) {
      final DateTime now = DateTime.now();
      final Map<String, dynamic> entry = {
        'date': Timestamp.fromDate(now),
        'weight': double.parse(weight),
      };

      await FirebaseFirestore.instance
          .collection('weight_entries')
          .doc(userId)
          .collection('entries')
          .add(entry);
    }
  }

  void _addWeightEntry(String weight) async {
    await _saveWeightEntryToFirestore(weight);

    setState(() {
      _weightEntries.add({
        'date': DateTime.now(),
        'weight': double.parse(weight),
      });
      _weightEntries.sort((a, b) => a['date'].compareTo(b['date']));
    });

    widget.onWeightEntryAdded();
    _weightController.clear();
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

  List<String> _generateDates() {
    if (_weightEntries.isEmpty) {
      return ['Boş'];
    }
    return _weightEntries.map((entry) {
      return DateFormat('dd MMM').format(entry['date'] as DateTime);
    }).toList();
  }

  double getCurrentWeight() {
    if (_weightEntries.isNotEmpty) {
      return _weightEntries.last['weight'];
    }
    return 0.0;
  }

  double getProgress() {
    if (_weightEntries.length > 1) {
      return _weightEntries.last['weight'] - _weightEntries.first['weight'];
    }
    return 0.0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kilo Takibi'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                height: 250,
                child: LineChart(
                  LineChartData(
                    backgroundColor: Colors.transparent,
                    gridData: FlGridData(
                      show: true,
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
              const SizedBox(height: 20),
              Card(
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Text(
                        "${getCurrentWeight().toStringAsFixed(1)} kg",
                        style: const TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        "Güncel Kilo",
                        style: TextStyle(fontSize: 18, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Card(
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Text(
                        "${getProgress().toStringAsFixed(1)} kg",
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: getProgress() < 0 ? Colors.red : Colors.green,
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        "İlerleme",
                        style: TextStyle(fontSize: 18, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 40),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _weightController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        hintText: "Kilonuzu girin (kg)",
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: () {
                      if (_weightController.text.isNotEmpty) {
                        _addWeightEntry(_weightController.text);
                      }
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
