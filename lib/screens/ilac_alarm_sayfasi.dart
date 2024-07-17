import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // DateFormat için gerekli paket
import '../models/alarm.dart';
import '../services/notification_service.dart';
import '../widgets/ takvim_widget.dart';
import 'alarm_ekleme_sayfasi.dart';

class IlacAlarmSayfasi extends StatefulWidget {
  final NotificationService notificationService;

  const IlacAlarmSayfasi({super.key, required this.notificationService});

  @override
  IlacAlarmSayfasiState createState() => IlacAlarmSayfasiState();
}

class IlacAlarmSayfasiState extends State<IlacAlarmSayfasi> {
  DateTime _selectedDay = DateTime.now();
  final List<Alarm> _alarms = [];

  List<DateTime> _getMarkedDates() {
    final markedDates = <DateTime>[];
    for (var alarm in _alarms) {
      if (alarm.startDate != null && alarm.endDate != null) {
        for (var date = alarm.startDate!;
            date.isBefore(alarm.endDate!) ||
                date.isAtSameMomentAs(alarm.endDate!);
            date = date.add(const Duration(days: 1))) {
          markedDates.add(date);
        }
      }
    }
    return markedDates;
  }

  List<DateTime> _getFinishedDates() {
    final finishedDates = <DateTime>[];
    for (var alarm in _alarms) {
      if (alarm.isActive) {
        finishedDates.add(alarm.startDate!);
      }
    }
    return finishedDates;
  }

  @override
  Widget build(BuildContext context) {
    final markedDates = _getMarkedDates();
    final finishedDates = _getFinishedDates();

    return Scaffold(
      appBar: AppBar(
        title: const Text('İlaç Alarmı'),
      ),
      body: Column(
        children: [
          TakvimWidget(
            initialSelectedDay: _selectedDay,
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
              });
            },
            markedDates: markedDates,
            finishedDates: finishedDates,
          ),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Align(
              alignment: Alignment.centerLeft, // Sola yaslı
              child: Text(
                'Alarmlar',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(
                  horizontal: 8.0), // Sağdan ve soldan biraz boşluk
              itemCount: _alarms.length,
              itemBuilder: (context, index) {
                final alarm = _alarms[index];
                final startTime = DateFormat('HH:mm').format(alarm.startTime);
                return Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 4.0), // Her alarm öğesi arasında dikey boşluk
                  child: Dismissible(
                    key: Key(alarm.title),
                    onDismissed: (direction) {
                      final removedAlarm = _alarms[index];
                      setState(() {
                        _alarms.removeAt(index);
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('${removedAlarm.title} silindi'),
                        ),
                      );
                    },
                    direction: DismissDirection.endToStart,
                    background: Container(
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      color: Colors.red,
                      child: const Icon(
                        Icons.delete,
                        color: Colors.white,
                      ),
                    ),
                    dismissThresholds: const {
                      DismissDirection.endToStart: 0.25,
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.blue[50], // Açık mavi arka plan
                        borderRadius:
                            BorderRadius.circular(10.0), // Oval köşeler
                      ),
                      child: ListTile(
                        title: Text(
                          '$startTime - ${alarm.title}',
                        ),
                        subtitle: Text(
                          'Başlangıç: ${DateFormat.yMMMd().format(alarm.startDate!)} - Bitiş: ${DateFormat.yMMMd().format(alarm.endDate!)}',
                        ),
                        trailing: Switch(
                          activeColor: Colors.blue, // Lacivert açıkken
                          inactiveThumbColor: Colors.white, // Beyaz kapalıyken
                          value: alarm.isActive,
                          onChanged: (value) {
                            setState(() {
                              alarm.isActive = value;
                            });
                            if (value) {
                              widget.notificationService.showNotification(
                                index,
                                'İlaç Hatırlatıcısı',
                                alarm.title,
                                DateTime.now(),
                                alarm.days,
                              );
                            }
                          },
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue, // Lacivert arka plan
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50),
        ),
        onPressed: () async {
          final newAlarm = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AlarmEklemeSayfasi(
                notificationService: widget.notificationService,
              ),
            ),
          );

          if (newAlarm != null) {
            setState(() {
              _alarms.add(newAlarm);
            });
          }
        },
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
