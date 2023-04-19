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
    onPreviousMinDateTapped: (date) {},
    onAfterMaxDateTapped: (date) {},
    weekdayStart: DateTime.sunday,
    minRange: 6,
    onMinRangeSelected: (minRange) {
      print('onMinRangeSelected minRange $minRange');
    }
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
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14.0),
          child: ScrollableCleanCalendar(
            locale: 'ko',
            calendarController: calendarController,
            showWeekdays: false,
            layout: Layout.BEAUTY,
            padding: EdgeInsets.zero,
            calendarCrossAxisSpacing: 0,
            spaceBetweenMonthAndCalendar: 0,
            calendarMainAxisSpacing: 6,
            spaceBetweenCalendars: 30,
            monthTextAlign: TextAlign.left,
            monthTextStyle: const TextStyle(
              color: Color(0xFF3A3A3A),
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
            dayTextStyle: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w400,
              fontSize: 14,
            ),
            daySelectedBackgroundColor: Color(0xFF4765FF),
            daySelectedBackgroundColorBetween: Color(0xFFF6F6F6),
            dayRadius: 46,
            todayColor: Color(0xFFFF9D4D),
            dayDisableColor: Color(0xFFDDDDDD),
          ),
        ),
      ),
    );
  }
}
