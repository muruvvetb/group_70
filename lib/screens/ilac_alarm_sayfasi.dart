import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/alarm.dart';
import '../services/notification_service.dart';
import '../widgets/ takvim_widget.dart';
import 'alarm_ekleme_sayfasi.dart';
import 'package:cep_eczane/widgets/bottom_navigation_bar.dart';

class IlacAlarmSayfasi extends StatefulWidget {
  final NotificationService notificationService;
  final int selectedIndex;

  const IlacAlarmSayfasi({
    super.key,
    required this.notificationService,
    required this.selectedIndex,
  });

  @override
  IlacAlarmSayfasiState createState() => IlacAlarmSayfasiState();
}

class IlacAlarmSayfasiState extends State<IlacAlarmSayfasi> {
  late int _selectedIndex;
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

  void _onAlarmFinished(DateTime date) {
    setState(() {
      _alarms.removeWhere((alarm) => alarm.startDate == date);
    });
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
              alignment: Alignment.centerLeft,
              child: Text(
                'Alarmlar',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              itemCount: _alarms.length,
              itemBuilder: (context, index) {
                final alarm = _alarms[index];
                final startTime = DateFormat('HH:mm').format(DateTime(
                  _selectedDay.year,
                  _selectedDay.month,
                  _selectedDay.day,
                  alarm.time.hour,
                  alarm.time.minute,
                ));
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: Dismissible(
                    key: Key(
                        '${alarm.id}_${alarm.title}_${alarm.startDate}_${alarm.time}'),
                    onDismissed: (direction) {
                      final removedAlarm = _alarms[index];
                      setState(() {
                        widget.notificationService
                            .cancelNotification(removedAlarm.id);
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
                        color: const Color(0xFFD5E7F2),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: ListTile(
                        title: Text(
                          '$startTime - ${alarm.title}',
                        ),
                        subtitle: Text(
                          'Başlangıç: ${DateFormat.yMMMd().format(alarm.startDate!)} - Bitiş: ${DateFormat.yMMMd().format(alarm.endDate!)}',
                        ),
                        trailing: Switch(
                          activeColor: Colors.blue,
                          inactiveThumbColor: Colors.white,
                          value: alarm.isActive,
                          onChanged: (value) {
                            setState(() {
                              alarm.isActive = value;
                            });
                            if (value) {
                              widget.notificationService.scheduleNotification(
                                alarm.id,
                                'İlaç Hatırlatıcısı',
                                alarm.title,
                                DateTime(
                                  _selectedDay.year,
                                  _selectedDay.month,
                                  _selectedDay.day,
                                  alarm.time.hour,
                                  alarm.time.minute,
                                ),
                                'test_payload',
                              );
                            } else {
                              widget.notificationService
                                  .cancelNotification(alarm.id);
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
        backgroundColor: const Color.fromARGB(255, 133, 187, 222),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50),
        ),
        onPressed: () async {
          final newAlarm = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AlarmEklemeSayfasi(
                notificationService: widget.notificationService,
                onAlarmFinished: _onAlarmFinished,
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
      // bottomNavigationBar:
      //   CustomBottomNavigationBar(selectedIndex: _selectedIndex),
    ); //
  }
}
