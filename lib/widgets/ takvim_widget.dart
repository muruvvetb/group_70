import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

class TakvimWidget extends StatefulWidget {
  final DateTime initialSelectedDay;
  final Function(DateTime, DateTime) onDaySelected;
  final List<DateTime> markedDates; // Alarm zamanlarının olduğu günler
  final List<DateTime> finishedDates; // Alarm zamanlarının geldiği günler

  const TakvimWidget({
    super.key,
    required this.initialSelectedDay,
    required this.onDaySelected,
    required this.markedDates,
    required this.finishedDates,
  });

  @override
  _TakvimWidgetState createState() => _TakvimWidgetState();
}

class _TakvimWidgetState extends State<TakvimWidget> {
  late DateTime _focusedDay;
  late DateTime _selectedDay;
  late List<DateTime> _markedDates;
  late List<DateTime> _finishedDates;

  @override
  void initState() {
    super.initState();
    _focusedDay = widget.initialSelectedDay;
    _selectedDay = widget.initialSelectedDay;
    _markedDates = List.from(widget.markedDates);
    _finishedDates = List.from(widget.finishedDates);
    tz.initializeTimeZones(); // Initialize time zones
  }

  @override
  void didUpdateWidget(covariant TakvimWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.markedDates != oldWidget.markedDates) {
      setState(() {
        _markedDates = List.from(widget.markedDates);
      });
    }
    if (widget.finishedDates != oldWidget.finishedDates) {
      setState(() {
        _finishedDates = List.from(widget.finishedDates);
      });
    }
  }

  bool _isAlarmTime(DateTime date) {
    final now = tz.TZDateTime.now(tz.local);
    for (var markedDate in _markedDates) {
      if (isSameDay(markedDate, date) &&
          now.isAfter(DateTime(
            markedDate.year,
            markedDate.month,
            markedDate.day,
            markedDate.hour,
            markedDate.minute,
          ))) {
        return true;
      }
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TableCalendar(
          firstDay: DateTime.utc(2010, 10, 16),
          lastDay: DateTime.utc(2030, 3, 14),
          focusedDay: _focusedDay,
          selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
          onDaySelected: (selectedDay, focusedDay) {
            if (!isSameDay(_selectedDay, selectedDay)) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });
              widget.onDaySelected(selectedDay, focusedDay);
            }
          },
          onPageChanged: (focusedDay) {
            setState(() {
              _focusedDay = focusedDay;
            });
          },
          calendarFormat: CalendarFormat.week,
          eventLoader: (day) {
            return _markedDates
                    .where((markedDay) => isSameDay(day, markedDay))
                    .isNotEmpty
                ? ['marked']
                : [];
          },
          calendarStyle: CalendarStyle(
            outsideDaysVisible: false,
            todayDecoration: BoxDecoration(
              color: Colors.blue,
              shape: BoxShape.circle,
            ),
          ),
          daysOfWeekVisible: true,
          headerVisible: false,
          calendarBuilders: CalendarBuilders(
            markerBuilder: (context, day, events) {
              if (events.isNotEmpty) {
                bool isAlarm = _isAlarmTime(day);
                return Container(
                  margin: const EdgeInsets.all(6.0),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: isAlarm ? Colors.green : Colors.grey,
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    '${day.day}',
                    style: const TextStyle(color: Colors.white),
                  ),
                );
              }
              return null;
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            _getMonthYearString(_focusedDay),
            style: const TextStyle(fontSize: 14),
          ),
        ),
      ],
    );
  }

  String _getMonthYearString(DateTime date) {
    List<String> months = [
      "Ocak",
      "Şubat",
      "Mart",
      "Nisan",
      "Mayıs",
      "Haziran",
      "Temmuz",
      "Ağustos",
      "Eylül",
      "Ekim",
      "Kasım",
      "Aralık"
    ];
    return "${months[date.month - 1]} ${date.year}";
  }
}
