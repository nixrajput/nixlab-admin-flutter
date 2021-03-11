import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:nixlab_admin/constants/colors.dart';

class LoadingIndicator extends StatefulWidget {
  @override
  _LoadingIndicatorState createState() => _LoadingIndicatorState();
}

class _LoadingIndicatorState extends State<LoadingIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
    );
    _animation = Tween(begin: 1.0, end: 1.2)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));
    _controller.repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: _animation,
        builder: (ctx, widget) {
          return Transform.rotate(
            angle: _controller.status == AnimationStatus.forward
                ? (math.pi * 2) * _controller.value
                : -(math.pi * 2) * _controller.value,
            child: Container(
              width: 40.0,
              height: 40.0,
              child: CustomPaint(
                painter: LoaderCanvas(radius: _animation.value),
              ),
            ),
          );
        });
  }
}

class LoaderCanvas extends CustomPainter {
  double radius;

  LoaderCanvas({required this.radius});

  @override
  void paint(Canvas canvas, Size size) {
    Paint _arc = Paint()
      ..color = secondColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4.0;

    Paint _circle = Paint()
      ..color = Colors.grey.shade300
      ..style = PaintingStyle.fill;

    Offset _center = Offset(size.width / 2, size.height / 2);

    canvas.drawCircle(_center, size.width / 2, _circle);

    canvas.drawArc(
        Rect.fromCenter(
          center: _center,
          width: size.width * radius,
          height: size.height * radius,
        ),
        math.pi / 4,
        math.pi / 2,
        false,
        _arc);

    canvas.drawArc(
        Rect.fromCenter(
          center: _center,
          width: size.width * radius,
          height: size.height * radius,
        ),
        -math.pi / 4,
        -math.pi / 2,
        false,
        _arc);
  }

  @override
  bool shouldRepaint(LoaderCanvas oldPaint) {
    return true;
  }
}
