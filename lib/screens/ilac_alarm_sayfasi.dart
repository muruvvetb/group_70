import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/alarm.dart';
import '../services/notification_service.dart';
import '../widgets/ takvim_widget.dart';
import 'alarm_ekleme_sayfasi.dart';
import '../services/firestore_service.dart';

class IlacAlarmSayfasi extends StatefulWidget {
  final NotificationService notificationService;
  final FirestoreService firestoreService;

  const IlacAlarmSayfasi({
    super.key,
    required this.notificationService,
    required this.firestoreService,
  });

  @override
  IlacAlarmSayfasiState createState() => IlacAlarmSayfasiState();
}

class IlacAlarmSayfasiState extends State<IlacAlarmSayfasi> {
  DateTime _selectedDay = DateTime.now();
  List<Alarm> _alarms = [];
  final int maxAlarms = 2; // Maksimum alarm sayısı

  @override
  void initState() {
    super.initState();
    _loadAlarms();
  }

  Future<void> _loadAlarms() async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId != null) {
      widget.firestoreService.getAlarms(userId).listen((alarms) {
        if (mounted) {
          setState(() {
            _alarms = alarms;
          });
        }
      });
    }
  }

  Future<void> _saveAlarm(Alarm alarm) async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId != null) {
      final firestoreId = await widget.firestoreService.addAlarm(userId, alarm);
      if (mounted) {
        setState(() {
          alarm.firestoreId = firestoreId;
        });
      }
    }
  }

  Future<void> _updateAlarm(Alarm alarm) async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId != null) {
      await widget.firestoreService.updateAlarm(userId, alarm);
    }
  }

  Future<void> _deleteAlarm(String firestoreId, int notificationId) async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId != null) {
      try {
        await widget.notificationService.cancelNotification(notificationId);
        await widget.firestoreService.deleteAlarm(userId, firestoreId);
        print("Alarm başarıyla silindi: $firestoreId");
      } catch (e) {
        print("Alarm silinirken bir hata oluştu: $e");
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Alarm silinirken bir hata oluştu: $e'),
            ),
          );
        }
      }
    }
  }

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
    if (mounted) {
      setState(() {
        _alarms.removeWhere((alarm) => alarm.startDate == date);
      });
    }
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
              if (mounted) {
                setState(() {
                  _selectedDay = selectedDay;
                });
              }
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
                        '${alarm.firestoreId}_${alarm.title}_${alarm.startDate}_${alarm.time}'),
                    onDismissed: (direction) async {
                      final removedAlarm = _alarms[index];
                      if (mounted) {
                        setState(() {
                          _alarms.removeAt(index);
                        });
                      }
                      try {
                        await _deleteAlarm(
                            removedAlarm.firestoreId!, removedAlarm.id);

                        if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('${removedAlarm.title} silindi'),
                            ),
                          );
                        }
                      } catch (e) {
                        if (mounted) {
                          setState(() {
                            _alarms.insert(index,
                                removedAlarm); // Hata durumunda alarmı geri ekleyin
                          });
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content:
                                  Text('Alarm silinirken bir hata oluştu: $e'),
                            ),
                          );
                        }
                      }
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
                          activeColor: const Color.fromARGB(255, 133, 187, 222),
                          inactiveThumbColor: Colors.white,
                          value: alarm.isActive,
                          onChanged: (value) async {
                            if (!mounted) return;
                            setState(() {
                              alarm.isActive = value;
                            });
                            if (value) {
                              await widget.notificationService
                                  .scheduleNotification(
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
                                alarm.isActive, // isActive durumunu ekliyoruz
                              );
                              print(
                                  'Notification scheduled for alarm ID: ${alarm.id}');
                            } else {
                              await widget.notificationService
                                  .cancelNotification(alarm.id);
                              print(
                                  'Notification canceled for alarm ID: ${alarm.id}');
                            }
                            await _updateAlarm(
                                alarm); // Alarm Firestore'da güncellenir
                            if (mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                      '${alarm.title} alarmı ${value ? 'açıldı' : 'kapandı'}'),
                                ),
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
        heroTag: 'uniqueTag',
        backgroundColor: const Color.fromARGB(255, 133, 187, 222),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50),
        ),
        onPressed: () async {
          // Alarm sayısını kontrol et
          if (FirebaseAuth.instance.currentUser!.isAnonymous &&
              _alarms.length >= maxAlarms) {
            _showLimitReachedDialog();
            return; // Alarm ekleme işlemini engelle
          }

          final newAlarm = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AlarmEklemeSayfasi(
                notificationService: widget.notificationService,
                onAlarmFinished: _onAlarmFinished,
                medicineName: "İlaç Adı",
              ),
            ),
          );

          if (newAlarm != null) {
            if (mounted) {
              setState(() {
                _alarms.add(newAlarm);
              });
            }
            await _saveAlarm(newAlarm);
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showLimitReachedDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text(
          'Sınıra Ulaşıldı',
          textAlign: TextAlign.center,
        ),
        content: const Text(
          'Misafir olarak en fazla 2 alarm kurabilirsiniz.',
          textAlign: TextAlign.center,
        ),
        actions: <Widget>[
          Center(
            child: TextButton(
              onPressed: () {
                Navigator.of(ctx).pop();
              },
              child: const Text(
                'Tamam',
                style: TextStyle(
                  color: Color.fromARGB(255, 133, 187, 222), // Yazı rengi
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
