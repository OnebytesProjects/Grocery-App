import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class Calendar extends StatefulWidget {
  const Calendar({Key? key}) : super(key: key);

  @override
  State<Calendar> createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  CalendarController _calendarController = CalendarController();

  void initState() {
    super.initState();
    _calendarController = CalendarController();
  }

  Widget calendar() {
    return Container(
      margin: EdgeInsets.fromLTRB(10, 0, 10, 10),
      width: double.infinity,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(6),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: Colors.black12,
              blurRadius: 5,
              offset: Offset(0, 5),
            )
          ]),
      child: TableCalendar(
        headerStyle: HeaderStyle(
          formatButtonVisible: false,
        ),
        calendarController: _calendarController,
        calendarStyle: CalendarStyle(
          canEventMarkersOverflow: true,
          markersColor: Theme.of(context).primaryColor,
          selectedColor: Colors.grey,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ListView(
      children: [
        calendar(),
        SizedBox(
          height: 5,
        ),
        Container(
            padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
            child: Text(
              "Details",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
            )),
        cardVeiw("Milk"),
      ],
    ));
  }

  Widget cardVeiw(String title) {
    return Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            Column(
              children: [
                FlatButton(
                  child: Text("Skip Delivery"),
                  onPressed: () {},
                  color: Colors.orange[300],
                ),
              ],
            )
          ],
        ),
      );
  }
}
