import 'package:flutter/material.dart';
import 'package:komittab/constants.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarEvent extends StatelessWidget {
  const CalendarEvent({
    Key key,
    @required Map<DateTime, List> events,
    @required CalendarController controller,
  })  : _events = events,
        _controller = controller,
        super(key: key);

  final Map<DateTime, List> _events;
  final CalendarController _controller;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TableCalendar(
            events: _events,
            calendarStyle: CalendarStyle(
              todayColor: kPrimaryColor,
              todayStyle: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Colors.white),
            ),
            onDaySelected: (day, events, holidays) {
              print(
                day.toString(),
              );
            },
            builders: CalendarBuilders(
              selectedDayBuilder: (context, date, events) => Container(
                margin: const EdgeInsets.all(4.0),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.purple[300],
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Text(
                  date.day.toString(),
                  style: TextStyle(color: Colors.white),
                ),
              ),
              todayDayBuilder: (context, date, events) => Container(
                margin: const EdgeInsets.all(4.0),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: kPrimaryColor,
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Text(
                  date.day.toString(),
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
            calendarController: _controller,
          ),
        ],
      ),
    );
  }
}
