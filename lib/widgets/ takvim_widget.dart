import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class TakvimWidget extends StatefulWidget {
  final DateTime initialSelectedDay;
  final Function(DateTime, DateTime) onDaySelected;
  final List<DateTime> markedDates;
  final List<DateTime> finishedDates;

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

  @override
  void initState() {
    super.initState();
    _focusedDay = widget.initialSelectedDay;
    _selectedDay = widget.initialSelectedDay;
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
            return widget.markedDates
                    .where((markedDay) => isSameDay(day, markedDay))
                    .isNotEmpty
                ? ['marked']
                : [];
          },
          calendarStyle: CalendarStyle(
            outsideDaysVisible: false,
            todayDecoration: BoxDecoration(
              color: Colors.blue, // Bugünün rengi mavi
              shape: BoxShape.circle,
            ),
          ),
          daysOfWeekVisible: true,
          headerVisible: false, // Navigation bar'ı kaldırmak için
          calendarBuilders: CalendarBuilders(
            markerBuilder: (context, day, events) {
              if (events.isNotEmpty) {
                bool isFinished = widget.finishedDates.contains(day);
                return Container(
                  margin: const EdgeInsets.all(6.0),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: isFinished
                        ? Colors.green
                        : Colors.grey, // Alarmlar bittiyse yeşil, değilse gri
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
            _getMonthYearString(
                _focusedDay), // Ay ve yıl ismi ile güncellemek için
            style: const TextStyle(fontSize: 14), // Bold değil
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
