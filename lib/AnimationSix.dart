import 'package:flutter/material.dart';
import 'dart:math' show pi, cos, sin;

class Polygon extends CustomPainter {
  final int sides;

  Polygon({required this.sides});

  @override
  void paint(Canvas canvas, Size size) {
    var path = Path();
    var paint = Paint()
      ..color = Colors.blue
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 3;
    final center = Offset(size.width / 2, size.width / 2);
    final angle = (2 * pi) / sides;
    final angles = List.generate(sides, (index) => index * angle);
    final radius = size.width / 2;

    path.moveTo(size.width, center.dx);
    for (var angle in angles) {
      path.lineTo(
        center.dx + radius * cos(angle),
        center.dx + radius * sin(angle),
      );
    }
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return oldDelegate is Polygon && oldDelegate.sides != sides;
  }
}

class AnimationSix extends StatefulWidget {
  const AnimationSix({Key? key}) : super(key: key);

  @override
  State<AnimationSix> createState() => _AnimationSixState();
}

class _AnimationSixState extends State<AnimationSix>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late AnimationController _animationController2;
  late AnimationController _animationController3;
  late Animation<int> _animation;
  late Animation<double> _animation2;
  late Animation _animation3;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(
        seconds: 3,
      ),
    );

    _animationController2 = AnimationController(
      vsync: this,
      duration: const Duration(
        seconds: 3,
      ),
    );

    _animationController3 = AnimationController(
      vsync: this,
      duration: const Duration(
        seconds: 3,
      ),
    );

    _animation = IntTween(
      begin: 3,
      end: 10,
    ).animate(_animationController);

    _animation2 = Tween<double>(
      begin: 40.0,
      end: 400.0,
    )
        .chain(
          CurveTween(
            curve: Curves.bounceInOut,
          ),
        )
        .animate(_animationController2);

    _animation3 = Tween<double>(
      begin: 0.0,
      end: 2*pi,
    ).animate(_animationController3);

    _animationController
      ..forward()
      ..repeat(reverse: true);

    _animationController2
      ..forward()
      ..repeat(reverse: true);

    _animationController3
      ..forward()
      ..repeat(reverse: true);
  }

  @override
  void dispose() {
    _animationController.dispose();
    _animationController2.dispose();
    _animationController3.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: AnimatedBuilder(
          animation:
              Listenable.merge([_animationController, _animationController2]),
          builder: (context, child) => Transform(
            transform: Matrix4.identity()
              ..rotateX(_animation3.value)
              ..rotateY(_animation3.value)
              ..rotateZ(_animation3.value),
            alignment: Alignment.center,
            child: CustomPaint(
              painter: Polygon(sides: _animation.value),
              child: SizedBox(
                height: _animation2.value,
                width: _animation2.value,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
