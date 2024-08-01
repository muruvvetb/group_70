import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import '../models/alarm.dart';
import '../services/notification_service.dart';

class AlarmEklemeSayfasi extends StatefulWidget {
  final NotificationService notificationService;
  final Function(DateTime) onAlarmFinished;
  final String medicineName; // İlaç adı eklendi

  const AlarmEklemeSayfasi({
    Key? key,
    required this.notificationService,
    required this.onAlarmFinished,
    required this.medicineName, // İlaç adı parametresi eklendi
  }) : super(key: key);

  @override
  AlarmEklemeSayfasiState createState() => AlarmEklemeSayfasiState();
}

class AlarmEklemeSayfasiState extends State<AlarmEklemeSayfasi> {
  final TextEditingController _baslikController = TextEditingController();
  DateTime _selectedTime = DateTime.now();
  DateTime? _startDate;
  DateTime? _endDate;
  Alarm? newAlarm; // newAlarm nesnesi dışarıda tanımlandı

  @override
  void initState() {
    super.initState();
    _baslikController.text =
        widget.medicineName; // İlaç adı varsayılan olarak ayarlandı
    Future.microtask(() => _showTimePicker(context));
  }

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

  Future<void> _scheduleNotification() async {
    if (_startDate == null) {
      return;
    }

    DateTime scheduledDate = DateTime(
      _startDate!.year,
      _startDate!.month,
      _startDate!.day,
      _selectedTime.hour,
      _selectedTime.minute,
    );

    if (scheduledDate.isBefore(DateTime.now())) {
      return;
    }

    newAlarm = Alarm(
      title: _baslikController.text,
      time: TimeOfDay(hour: _selectedTime.hour, minute: _selectedTime.minute),
      days: List.filled(7, false),
      startDate: _startDate,
      endDate: _endDate,
      isActive: true,
    );

    await widget.notificationService.scheduleNotification(
      0, // Bildirim ID'si, her alarm için benzersiz olmalıdır
      _baslikController.text,
      'İlaç hatırlatıcı bildirimi',
      scheduledDate,
      'ilac_alarm',
      newAlarm!.isActive, // isActive argümanı eklendi
    );

    print('New Alarm Created: ${newAlarm!.toMap()}'); // Debug için
    widget.onAlarmFinished(scheduledDate); // Alarm bitiş fonksiyonu çağrılır
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
                    : 'Başlangıç: ${DateFormat('dd-MM-yyyy').format(_startDate!)}',
                style: const TextStyle(
                  color: Colors.blue,
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () => _selectDate(context, isStartDate: false),
              child: Text(
                _endDate == null
                    ? 'Bitiş Tarihi Seç'
                    : 'Bitiş: ${DateFormat('dd-MM-yyyy').format(_endDate!)}',
                style: const TextStyle(
                  color: Colors.blue,
                ),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                await _scheduleNotification();
                Navigator.pop(
                    context, newAlarm); // newAlarm nesnesini geri döndür
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
