import 'package:flutter/material.dart';
import 'package:studify/core/theme/app_colors.dart';
import 'package:studify/core/theme/app_theme.dart';

/// The app mark: an open book on the brand gradient (the website's icon.svg).
class StudyfyMark extends StatelessWidget {
  const StudyfyMark({super.key, this.size = 32});

  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        gradient: AppColors.brandGradient,
        borderRadius: BorderRadius.circular(size * 5.5 / 24),
        boxShadow: [
          BoxShadow(
            color: AppColors.indigo600.withValues(alpha: 0.3),
            blurRadius: size / 3,
            offset: Offset(0, size / 10),
          ),
        ],
      ),
      child: CustomPaint(painter: _BookPainter()),
    );
  }
}

class _BookPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    canvas.scale(size.width / 24, size.height / 24);
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.4
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final book = Path()
      ..moveTo(12, 6.75)
      ..cubicTo(10.5, 5.25, 8.25, 4.5, 6, 4.5)
      ..lineTo(6, 18)
      ..cubicTo(8.25, 18, 10.5, 18.75, 12, 20.25)
      ..cubicTo(13.5, 18.75, 15.75, 18, 18, 18)
      ..lineTo(18, 4.5)
      ..cubicTo(15.75, 4.5, 13.5, 5.25, 12, 6.75)
      ..close()
      ..moveTo(12, 6.75)
      ..lineTo(12, 19.5);
    canvas.drawPath(book, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// "Studyfy" with the "fy" in the brand colour, as in the logo.
class StudyfyWordmark extends StatelessWidget {
  const StudyfyWordmark({super.key, this.fontSize = 20});

  final double fontSize;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final style = Theme.of(context).textTheme.titleLarge!
        .copyWith(fontSize: fontSize, letterSpacing: -0.5)
        .weight(FontWeight.w800);
    return Text.rich(
      TextSpan(
        style: style,
        children: [
          const TextSpan(text: 'Study'),
          TextSpan(
            text: 'fy',
            style: TextStyle(color: scheme.primary),
          ),
        ],
      ),
    );
  }
}

/// Mark + wordmark, for headers.
class StudyfyLogo extends StatelessWidget {
  const StudyfyLogo({super.key, this.markSize = 30});

  final double markSize;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        StudyfyMark(size: markSize),
        SizedBox(width: markSize * 0.3),
        StudyfyWordmark(fontSize: markSize * 0.68),
      ],
    );
  }
}
