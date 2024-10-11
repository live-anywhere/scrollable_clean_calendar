import 'package:flutter/material.dart';

const primary = Color(0xFF008FF6);

class CalendarTagPainter extends CustomPainter {
  const CalendarTagPainter({
    required this.text,
    required this.textStyle,
    this.backgroundColor = primary,
    this.borderColor = primary,
  });

  final String text;
  final Color backgroundColor;
  final Color borderColor;
  final TextStyle textStyle;

  final verticalPadding = 3.0;
  final horizontalPadding = 8.0;

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;

  @override
  void paint(Canvas canvas, Size _) {
    final textPainter = TextPainter(
      text: TextSpan(
        text: text,
        style: textStyle,
      ),
      textDirection: TextDirection.ltr,
    )..layout();

    final textWidth = textPainter.width;
    final textHeight = textPainter.height;

    final width = textWidth + horizontalPadding * 2;
    final height = textHeight + verticalPadding * 2;

    final centerX = width / 2;
    final bottomY = height;
    const arrowWidth = 5;
    final arrowY = bottomY + 5;

    final backgroundPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    final borderPaint = Paint()
      ..color = borderColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    final radius = height / 2;
    final path = Path()
      ..addRRect(RRect.fromRectAndRadius(Rect.fromLTWH(0, 0, width, height), Radius.circular(radius)))
      ..moveTo(centerX - arrowWidth, bottomY)
      ..lineTo(centerX, arrowY)
      ..lineTo(centerX + arrowWidth, bottomY)
      ..close();

    canvas.save();
    canvas.translate(-centerX, -verticalPadding);

    canvas.drawPath(path, borderPaint);
    canvas.drawPath(path, backgroundPaint);

    canvas.restore();

    textPainter.paint(canvas, Offset(-centerX + horizontalPadding, -1));
  }
}
