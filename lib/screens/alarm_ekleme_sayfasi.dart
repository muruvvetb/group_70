import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../models/alarm.dart';
import '../services/notification_service.dart';

class AlarmEklemeSayfasi extends StatefulWidget {
  final NotificationService notificationService;

  const AlarmEklemeSayfasi({super.key, required this.notificationService});

  @override
  AlarmEklemeSayfasiState createState() => AlarmEklemeSayfasiState();
}

class AlarmEklemeSayfasiState extends State<AlarmEklemeSayfasi> {
  final TextEditingController _baslikController = TextEditingController();
  DateTime _selectedTime = DateTime.now();
  DateTime? _startDate;
  DateTime? _endDate;

  Future<void> _selectDate(BuildContext context,
      {required bool isStartDate}) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null) {
      setState(() {
        if (isStartDate) {
          _startDate = picked;
        } else {
          _endDate = picked;
        }
      });
    }
  }

  void _showTimePicker(BuildContext context) {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 250,
          color: const Color.fromARGB(255, 255, 255, 255),
          child: CupertinoDatePicker(
            initialDateTime: _selectedTime,
            mode: CupertinoDatePickerMode.time,
            onDateTimeChanged: (DateTime newTime) {
              setState(() {
                _selectedTime = newTime;
              });
            },
            use24hFormat: true,
          ),
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    Future.microtask(() => _showTimePicker(context));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Alarm Ekle'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _baslikController,
              decoration: const InputDecoration(
                labelText: 'Başlık',
              ),
            ),
            const SizedBox(height: 16),
            GestureDetector(
              onTap: () => _showTimePicker(context),
              child: Column(
                children: [
                  const Text(
                    'Alarm Saati',
                    style: TextStyle(color: Colors.blue),
                  ),
                  Text(
                    '${_selectedTime.hour.toString().padLeft(2, '0')}:${_selectedTime.minute.toString().padLeft(2, '0')}',
                    style: const TextStyle(fontSize: 24),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () => _selectDate(context, isStartDate: true),
              child: Text(
                _startDate == null
                    ? 'Başlangıç Tarihi Seç'
                    : 'Başlangıç: ${_startDate!.toLocal()}'.split(' ')[0],
                style: const TextStyle(color: Colors.blue),
              ),
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () => _selectDate(context, isStartDate: false),
              child: Text(
                _endDate == null
                    ? 'Bitiş Tarihi Seç'
                    : 'Bitiş: ${_endDate!.toLocal()}'.split(' ')[0],
                style: const TextStyle(color: Colors.blue),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                final newAlarm = Alarm(
                  title: _baslikController.text,
                  time: TimeOfDay(
                      hour: _selectedTime.hour, minute: _selectedTime.minute),
                  days: List.filled(7, false),
                  startDate: _startDate,
                  endDate: _endDate,
                );
                Navigator.pop(context, newAlarm);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
              ),
              child: const Text('Alarm Kur'),
            ),
          ],
        ),
      ),
    );
  }
}
