import 'package:flutter/material.dart';

class Alarm {
  static int _idCounter = 0;

  final int id;
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

  DateTime get startTime {
    return DateTime(startDate!.year, startDate!.month, startDate!.day,
        time.hour, time.minute);
  }
}
