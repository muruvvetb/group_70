import 'package:flutter/material.dart';

class Alarm {
  static int _idCounter = 0;

  final int id; // Bildirim kimliği için kullanılır
  String? firestoreId; // Firestore'daki belge ID'sini tutar
  String title;
  TimeOfDay time;
  List<bool> days;
  DateTime? startDate;
  DateTime? endDate;
  bool isActive;

  Alarm({
    required this.title,
    required this.time,
    required this.days,
    this.startDate,
    this.endDate,
    this.isActive = true,
  }) : id = _idCounter++;

  Map<String, dynamic> toMap() {
    return {
      'id': id, // Bildirim için ID
      'title': title,
      'time': {'hour': time.hour, 'minute': time.minute},
      'days': days,
      'startDate': startDate?.millisecondsSinceEpoch,
      'endDate': endDate?.millisecondsSinceEpoch,
      'isActive': isActive,
    };
  }

  // Firestore'dan belge id'sini ve belge verilerini alır
  factory Alarm.fromMap(Map<String, dynamic> map, String? firestoreId) {
    final alarm = Alarm(
      title: map['title'],
      time: TimeOfDay(hour: map['time']['hour'], minute: map['time']['minute']),
      days: List<bool>.from(map['days']),
      startDate: map['startDate'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['startDate'])
          : null,
      endDate: map['endDate'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['endDate'])
          : null,
      isActive: map['isActive'],
    );
    alarm.firestoreId = firestoreId; // Firestore ID'sini set eder
    return alarm;
  }
}
