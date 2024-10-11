import 'package:example/calendar_tag_painter.dart';
import 'package:flutter/material.dart';
import 'package:scrollable_clean_calendar/controllers/clean_calendar_controller.dart';
import 'package:scrollable_clean_calendar/scrollable_clean_calendar.dart';
import 'package:scrollable_clean_calendar/utils/enums.dart';
import 'package:scrollable_clean_calendar/utils/extensions.dart';

void main() {
  runApp(MyApp());
}

final _calendarTags = <({int days, String title})>[
  (days: 6, title: '일주일'),
  (days: 14, title: '보름'),
  (days: 29, title: '한달'),
];

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  DateTime? _selectedStartDate;
  DateTime? _selectedEndDate;

  final _today = DateTime.now();

  late final calendarController = CleanCalendarController(
    minDate: DateTime.now(),
    maxDate: DateTime.now().add(const Duration(days: 365)),
    initialDateSelected: _selectedStartDate,
    endDateSelected: _selectedEndDate,
    onRangeSelected: (startDate, endDate) {
      setState(
        () {
          _selectedStartDate = startDate;
          _selectedEndDate = endDate;
        },
      );
    },
    onDayTapped: (date) {},
    onPreviousMinDateTapped: (date) {},
    onAfterMaxDateTapped: (date) {},
    weekdayStart: DateTime.sunday,
    minRange: 6,
    onMinRangeSelected: (minRange) {
      debugPrint('onMinRangeSelected minRange $minRange');
    },
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
          error: Color(0xFF96031A),
          onPrimary: Colors.white,
          onSecondary: Colors.white,
          onSurface: Colors.black,
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
            ),
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
              fontSize: 14,
            ),
            daySelectedBackgroundColor: const Color(0xFF4765FF),
            daySelectedBackgroundColorBetween: const Color(0xFFF6F6F6),
            dayRadius: 46,
            dayStackBuilder: (context, values) => [
              if (values.day.isSameDay(_today) && !values.isSelected)
                const Positioned(
                  bottom: 6,
                  child: Text(
                    '오늘',
                    style: TextStyle(
                      color: Color(0xFFFF9D4D),
                      fontWeight: FontWeight.w500,
                      fontSize: 10,
                    ),
                  ),
                ),
              if (_selectedStartDate != null)
                for (final tag in _calendarTags)
                  if (values.day.isSameDay(_selectedStartDate!.add(Duration(days: tag.days))))
                    Positioned(
                      top: -10,
                      child: CustomPaint(
                        painter: CalendarTagPainter(
                          text: '${tag.title} 살기',
                          textStyle: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: primary,
                          ),
                        ),
                      ),
                    ),
            ],
            todayColor: const Color(0xFFFF9D4D),
            dayDisableColor: const Color(0xFFDDDDDD),
          ),
        ),
      ),
    );
  }
}
