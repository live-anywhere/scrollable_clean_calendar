import 'package:flutter/material.dart';
import 'package:scrollable_clean_calendar/controllers/clean_calendar_controller.dart';
import 'package:scrollable_clean_calendar/scrollable_clean_calendar.dart';
import 'package:scrollable_clean_calendar/utils/enums.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final calendarController = CleanCalendarController(
    minDate: DateTime.now(),
    maxDate: DateTime.now().add(const Duration(days: 365)),
    onRangeSelected: (firstDate, secondDate) {},
    onDayTapped: (date) {},
    // readOnly: true,
    onPreviousMinDateTapped: (date) {},
    onAfterMaxDateTapped: (date) {},
    weekdayStart: DateTime.sunday,
    // initialFocusDate: DateTime(2023, 5),
    // initialDateSelected: DateTime(2022, 3, 15),
    // endDateSelected: DateTime(2022, 3, 20),
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Scrollable Clean Calendar',
      theme: ThemeData(
        colorScheme: const ColorScheme(
          primary: Color(0xFF3F51B5),
          primaryContainer: Color(0xFF002984),
          secondary: Color(0xFFD32F2F),
          secondaryContainer: Color(0xFF9A0007),
          surface: Color(0xFFDEE2E6),
          background: Color(0xFFF8F9FA),
          error: Color(0xFF96031A),
          onPrimary: Colors.white,
          onSecondary: Colors.white,
          onSurface: Colors.black,
          onBackground: Colors.black,
          onError: Colors.white,
          brightness: Brightness.light,
        ),
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Scrollable Clean Calendar'),
          actions: [
            IconButton(
              onPressed: () {
                calendarController.clearSelectedDates();
              },
              icon: const Icon(Icons.clear),
            )
          ],
        ),
        // floatingActionButton: FloatingActionButton(
        //   child: const Icon(Icons.arrow_downward),
        //   onPressed: () {
        //     calendarController.jumpToMonth(date: DateTime(2022, 8));
        //   },
        // ),
        body: ScrollableCleanCalendar(
          locale: 'ko',
          calendarController: calendarController,
          showWeekdays: false,
          layout: Layout.BEAUTY,
          calendarCrossAxisSpacing: 0,
          monthTextAlign: TextAlign.left,
          // monthBuilder: (context, month) {
          //   return Text(DateFormat('yyyy년 M월').format(DateTime.parse(month)));
          // },
          // dayBuilder: (context, values) {
          //   // print('values ${values.day}');
          //   return Text(values.day.weekday.toString());
          // },
          // dayTextStyle: TextStyle(color: Colors.yellow),
          daySelectedBackgroundColor: Color(0xFF4765FF),
          daySelectedBackgroundColorBetween: Color(0xFFF6F6F6),
          // daySelectedBackgroundColorBetween: Colors.pink,
          dayRadius: 500,
          // dayDisableBackgroundColor: Colors.amberAccent,
          // dayDisableColor: Colors.amber,
        ),
      ),
    );
  }
}
