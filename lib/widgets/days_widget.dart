import 'package:flutter/material.dart';
import 'package:scrollable_clean_calendar/controllers/clean_calendar_controller.dart';
import 'package:scrollable_clean_calendar/models/day_values_model.dart';
import 'package:scrollable_clean_calendar/utils/enums.dart';
import 'package:scrollable_clean_calendar/utils/extensions.dart';

class DaysWidget extends StatelessWidget {
  final CleanCalendarController cleanCalendarController;
  final DateTime month;
  final double calendarCrossAxisSpacing;
  final double calendarMainAxisSpacing;
  final Layout? layout;
  final Widget Function(
    BuildContext context,
    DayValues values,
  )? dayBuilder;
  final Color? todayColor;
  final Color? selectedBackgroundColor;
  final Color? backgroundColor;
  final Color? selectedBackgroundColorBetween;
  final Color? disableBackgroundColor;
  final Color? dayDisableColor;
  final double radius;
  final TextStyle? textStyle;

  const DaysWidget({
    Key? key,
    required this.month,
    required this.cleanCalendarController,
    required this.calendarCrossAxisSpacing,
    required this.calendarMainAxisSpacing,
    required this.layout,
    required this.dayBuilder,
    required this.todayColor,
    required this.selectedBackgroundColor,
    required this.backgroundColor,
    required this.selectedBackgroundColorBetween,
    required this.disableBackgroundColor,
    required this.dayDisableColor,
    required this.radius,
    required this.textStyle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Start weekday - Days per week - The first weekday of this month
    // 7 - 7 - 1 = -1 = 1
    // 6 - 7 - 1 = -2 = 2

    // What it means? The first weekday does not change, but the start weekday have changed,
    // so in the layout we need to change where the calendar first day is going to start.
    int monthPositionStartDay = (cleanCalendarController.weekdayStart -
            DateTime.daysPerWeek -
            DateTime(month.year, month.month).weekday)
        .abs();
    monthPositionStartDay = monthPositionStartDay > DateTime.daysPerWeek
        ? monthPositionStartDay - DateTime.daysPerWeek
        : monthPositionStartDay;

    final start = monthPositionStartDay == 7 ? 0 : monthPositionStartDay;

    // If the monthPositionStartDay is equal to 7, then in this layout logic will cause a trouble, beacause it will
    // have a line in blank and in this case 7 is the same as 0.

    return LayoutBuilder(builder: (context, constraintType) {
      return GridView.count(
        crossAxisCount: DateTime.daysPerWeek,
        physics: const NeverScrollableScrollPhysics(),
        addRepaintBoundaries: false,
        padding: EdgeInsets.zero,
        crossAxisSpacing: calendarCrossAxisSpacing,
        mainAxisSpacing: calendarMainAxisSpacing,
        childAspectRatio: (constraintType.maxWidth / DateTime.daysPerWeek) / 46 ,
        shrinkWrap: true,
        children: List.generate(
            DateTime(month.year, month.month + 1, 0).day + start, (index) {
          if (index < start) return const SizedBox.shrink();
          final day = DateTime(month.year, month.month, (index + 1 - start));
          final text = (index + 1 - start).toString();

          bool isSelected = false;

          if (cleanCalendarController.rangeMinDate != null) {
            if (cleanCalendarController.rangeMinDate != null &&
                cleanCalendarController.rangeMaxDate != null) {
              isSelected = day
                  .isSameDayOrAfter(cleanCalendarController.rangeMinDate!) &&
                  day.isSameDayOrBefore(cleanCalendarController.rangeMaxDate!);
            } else {
              isSelected =
                  day.isAtSameMomentAs(cleanCalendarController.rangeMinDate!);
            }
          }

          Widget widget;
          final DateTime toDay = DateTime.now();
          final dayValues = DayValues(
            day: day,
            isFirstDayOfWeek: day.weekday == cleanCalendarController.weekdayStart,
            isLastDayOfWeek: day.weekday == cleanCalendarController.weekdayEnd,
            isFirstDayOfMonth: DateTime(day.year, day.month, 1),
            isLastDayOfMonth: DateTime(day.year, day.month + 1, 0),
            isSelected: isSelected,
            maxDate: cleanCalendarController.maxDate,
            minDate: cleanCalendarController.minDate,
            text: text,
            selectedMaxDate: cleanCalendarController.rangeMaxDate,
            selectedMinDate: cleanCalendarController.rangeMinDate,
          );

          if (dayBuilder != null) {
            widget = dayBuilder!(context, dayValues);
          } else {
            widget = <Layout, Widget Function()>{
              Layout.DEFAULT: () => _pattern(context, dayValues),
              Layout.BEAUTY: () => _beauty(context, dayValues, toDay),
            }[layout]!();
          }

          return GestureDetector(
            onTap: () {
              if (day.isBefore(cleanCalendarController.minDate) &&
                  !day.isSameDay(cleanCalendarController.minDate)) {
                if (cleanCalendarController.onPreviousMinDateTapped != null) {
                  cleanCalendarController.onPreviousMinDateTapped!(day);
                }
              } else if (day.isAfter(cleanCalendarController.maxDate)) {
                if (cleanCalendarController.onAfterMaxDateTapped != null) {
                  cleanCalendarController.onAfterMaxDateTapped!(day);
                }
              } else {
                if (!cleanCalendarController.readOnly) {
                  cleanCalendarController.onDayClick(day);
                }
              }
            },
            child: widget,
          );
        }),
      );
    });
  }

  Widget _pattern(BuildContext context, DayValues values) {
    Color bgColor = backgroundColor ?? Theme.of(context).colorScheme.surface;
    TextStyle txtStyle =
        (textStyle ?? Theme.of(context).textTheme.bodyText1)!.copyWith(
      color: backgroundColor != null
          ? backgroundColor!.computeLuminance() > .5
              ? Colors.black
              : Colors.white
          : Theme.of(context).colorScheme.onSurface,
    );

    if (values.isSelected) {
      if ((values.selectedMinDate != null &&
              values.day.isSameDay(values.selectedMinDate!)) ||
          (values.selectedMaxDate != null &&
              values.day.isSameDay(values.selectedMaxDate!))) {
        bgColor =
            selectedBackgroundColor ?? Theme.of(context).colorScheme.primary;
        txtStyle =
            (textStyle ?? Theme.of(context).textTheme.bodyText1)!.copyWith(
          color: selectedBackgroundColor != null
              ? selectedBackgroundColor!.computeLuminance() > .5
                  ? Colors.black
                  : Colors.white
              : Theme.of(context).colorScheme.onPrimary,
        );
      } else {
        bgColor = selectedBackgroundColorBetween ??
            Theme.of(context).colorScheme.primary.withOpacity(.3);
        txtStyle =
            (textStyle ?? Theme.of(context).textTheme.bodyText1)!.copyWith(
          color: selectedBackgroundColor != null &&
                  selectedBackgroundColor == selectedBackgroundColorBetween
              ? selectedBackgroundColor!.computeLuminance() > .5
                  ? Colors.black
                  : Colors.white
              : selectedBackgroundColor ??
                  Theme.of(context).colorScheme.primary,
        );
      }
    } else if (values.day.isSameDay(values.minDate)) {
      bgColor = Colors.transparent;
      txtStyle = (textStyle ?? Theme.of(context).textTheme.bodyText1)!.copyWith(
        color: selectedBackgroundColor ?? Theme.of(context).colorScheme.primary,
      );
    } else if (values.day.isBefore(values.minDate) ||
        values.day.isAfter(values.maxDate)) {
      bgColor = disableBackgroundColor ??
          Theme.of(context).colorScheme.surface.withOpacity(.4);
      txtStyle = (textStyle ?? Theme.of(context).textTheme.bodyText1)!.copyWith(
        color: dayDisableColor ??
            Theme.of(context).colorScheme.onSurface.withOpacity(.5),
      );
    }

    return Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(radius),
        border: values.day.isSameDay(values.minDate)
            ? Border.all(
                color: selectedBackgroundColor ??
                    Theme.of(context).colorScheme.primary,
                width: 2,
              )
            : null,
      ),
      child: Text(
        values.text,
        textAlign: TextAlign.center,
        style: txtStyle,
      ),
    );
  }

  Color _setWeekendColor(DateTime date) {
    switch(date.weekday) {
      case 6:
        return const Color(0xFF3C6FFA);
      case 7:
        return const Color(0xFFED2A61);
      default:
        return const Color(0xFF3A3A3A);
    }
  }

  Widget _beauty(BuildContext context, DayValues values, DateTime today) {
    BorderRadiusGeometry? borderRadius;
    // Color bgCellColor = Colors.transparent;
    LinearGradient gradientLeft = LinearGradient(colors: [
      selectedBackgroundColorBetween!,
      selectedBackgroundColorBetween!,
      Colors.transparent,
      Colors.transparent
    ], stops: const [
      0,
      0.5,
      0.5,
      1
    ]);
    LinearGradient gradientRight = LinearGradient(colors: [
      Colors.transparent,
      Colors.transparent,
      selectedBackgroundColorBetween!,
      selectedBackgroundColorBetween!,
    ], stops: const [
      0,
      0.5,
      0.5,
      1,
    ]);
    LinearGradient gradientFull = LinearGradient(colors: [
      selectedBackgroundColorBetween!,
      selectedBackgroundColorBetween!,
    ], stops: const [
      0,
      1
    ]);
    TextStyle txtStyle =
    (textStyle ?? Theme.of(context).textTheme.bodyText1)!.copyWith(
      color: backgroundColor != null
          ? backgroundColor!.computeLuminance() > .5
          ? Colors.black
          : Colors.white
          : Theme.of(context).colorScheme.onSurface,
      fontSize: 16,
    );
    if (values.isSelected) {
      // print('selected 1 if day is ${values.day}');
      borderRadius = BorderRadius.only(
        topLeft: Radius.circular(values.isFirstDayOfWeek || values.day.isSameDay(values.isFirstDayOfMonth) ? radius : 0),
        bottomLeft: Radius.circular(values.isFirstDayOfWeek || values.day.isSameDay(values.isFirstDayOfMonth) ? radius : 0),
        topRight: Radius.circular(values.isLastDayOfWeek || values.day.isSameDay(values.isLastDayOfMonth) ? radius : 0),
        bottomRight: Radius.circular(values.isLastDayOfWeek || values.day.isSameDay(values.isLastDayOfMonth) ? radius : 0),
      );

      if ((values.selectedMinDate != null &&
          values.day.isSameDay(values.selectedMinDate!)) ||
          (values.selectedMaxDate != null &&
              values.day.isSameDay(values.selectedMaxDate!))) {
        // print('selected 2 if day is ${values.day} ${values.selectedMinDate} ${values.selectedMaxDate}');
        // bgCellColor = values.selectedMaxDate == null ? Colors.transparent : selectedBackgroundColorBetween ?? Theme.of(context).colorScheme.primary;

        txtStyle =
            (textStyle ?? Theme.of(context).textTheme.bodyText1)!.copyWith(
                color: selectedBackgroundColor != null
                    ? selectedBackgroundColor!.computeLuminance() > .5
                    ? Colors.black
                    : Colors.white
                    : Theme.of(context).colorScheme.onPrimary,
                fontWeight: FontWeight.bold
            );

        if (values.selectedMinDate == values.selectedMaxDate) {
          borderRadius = BorderRadius.circular(radius);
        } else if (values.selectedMinDate != null &&
            values.day.isSameDay(values.selectedMinDate!)) {
          borderRadius = BorderRadius.only(
            topLeft: Radius.circular(radius),
            bottomLeft: Radius.circular(radius),
            topRight: Radius.circular(values.selectedMaxDate == null ? radius : 0),
            bottomRight: Radius.circular(values.selectedMaxDate == null ? radius : 0),
          );
        } else if (values.selectedMaxDate != null &&
            values.day.isSameDay(values.selectedMaxDate!)) {
          borderRadius = BorderRadius.only(
            topRight: Radius.circular(radius),
            bottomRight: Radius.circular(radius),
          );
        }
      } else {
        // print('selected else day is ${values.day}');
        // bgCellColor = selectedBackgroundColorBetween ??
        //     Theme.of(context).colorScheme.primary.withOpacity(.3);
        txtStyle =
            (textStyle ?? Theme.of(context).textTheme.bodyText1)!.copyWith(
              color:
              _setWeekendColor(values.day),
            );
      }
    } else if (values.day.isSameDay(values.minDate)) {
      txtStyle = (textStyle ?? Theme.of(context).textTheme.bodyText1)!.copyWith(color: todayColor?? txtStyle.color);
    } else if (values.day.isBefore(values.minDate) ||
        values.day.isAfter(values.maxDate)) {
      txtStyle = (textStyle ?? Theme.of(context).textTheme.bodyText1)!.copyWith(
        color: dayDisableColor ??
            Theme.of(context).colorScheme.onSurface.withOpacity(.5),
      );
    } else {
      txtStyle = (textStyle ?? Theme.of(context).textTheme.bodyText1)!.copyWith(
        color: _setWeekendColor(values.day),
      );
    }



    return Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          // color: bgCellColor,
            borderRadius: borderRadius,
            gradient: getGradient(values, gradientLeft, gradientRight, gradientFull)
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [

            values.isSelected &&
                (values.isFirstDayOfWeek ||
                    values.isLastDayOfWeek ||
                    values.day.isSameDay(values.isFirstDayOfMonth) ||
                    values.day.isSameDay(values.isLastDayOfMonth)
                ) ? Container(
                alignment: Alignment.center,
                width: 46,
                decoration: BoxDecoration(
                  color: selectedBackgroundColorBetween,
                  borderRadius: borderRadius = BorderRadius.all(Radius.circular(radius)),
                )) : const SizedBox.shrink(),

            values.isSelected &&
                (values.selectedMinDate != null &&
                    values.day.isSameDay(values.selectedMinDate!)) ||
                (values.selectedMaxDate != null &&
                    values.day.isSameDay(values.selectedMaxDate!)) ? Container(
                alignment: Alignment.center,
                width: 46,
                decoration: BoxDecoration(
                  color: selectedBackgroundColor,
                  borderRadius: borderRadius = BorderRadius.all(Radius.circular(radius)),
                )) : const SizedBox.shrink(),
            Center(
              child: Stack(
                children: [
                  CustomPaint(
                    painter: !values.day.isSameDay(values.minDate) && values.day.isBefore(values.minDate) ||
                        values.day.isAfter(values.maxDate) ? DiagonalPainter(dayDisableColor ??
                        Theme.of(context).colorScheme.onSurface.withOpacity(.5)) : null,
                    child: Container(
                      constraints: const BoxConstraints(
                        minWidth: 14,
                        minHeight: 14,
                      ),
                      child: Text(
                        values.text,
                        textAlign: TextAlign.center,
                        style: txtStyle,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            values.day.isSameDay(today) && !values.isSelected
                ? Positioned(
                bottom: 6,
                child: Text(
                  '오늘',
                  style: txtStyle.copyWith(fontSize: 10, fontWeight: FontWeight.w500),
                ))
                : const SizedBox.shrink()
          ],
        )
    );
  }

  Gradient? getGradient(DayValues values, gradientLeft, gradientRight, gradientFull) {

    if(values.isSelected) {
      if(values.selectedMaxDate == null) {
        return null;
      } else {
        if(values.isFirstDayOfWeek) {
          if(values.day.isSameDay(values.isFirstDayOfMonth) || values.day.isSameDay(values.isLastDayOfMonth)) {
            return null;
          } else {
            if(values.day.isSameDay(values.selectedMaxDate!)) {
              return null;
            } else {
              return gradientRight;
            }

          }
        } else if(values.isLastDayOfWeek) {
          if(values.day.isSameDay(values.isFirstDayOfMonth) || values.day.isSameDay(values.isLastDayOfMonth)) {
            return null;
          } else {
            if(values.day.isSameDay(values.selectedMinDate!)) {
              return null;
            } else {
              return gradientLeft;
            }
          }

        } else if(values.day.isSameDay(values.isFirstDayOfMonth)) {
          if(values.day.isSameDay(values.selectedMaxDate!)) {
            return null;
          } else {
            return gradientRight;
          }
        } else if(values.day.isSameDay(values.isLastDayOfMonth)) {
          if(values.day.isSameDay(values.selectedMinDate!)) {
            return null;
          } else {
            return gradientLeft;
          }
        } else {
          if(values.day.isSameDay(values.selectedMaxDate!)) {
            return gradientLeft;
          } else if(values.day.isSameDay(values.selectedMinDate!)) {
            return gradientRight;
          } else {
            return gradientFull;
          }
        }
      }
    } else {
      return null;
    }
  }
}

class DiagonalPainter extends CustomPainter {

  Color dayDisableColor;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = dayDisableColor
      ..strokeWidth = 0.5;

    canvas.drawLine(
      Offset(0, size.height),
      Offset(size.width, 0),
      paint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;

  DiagonalPainter(this.dayDisableColor);
}



