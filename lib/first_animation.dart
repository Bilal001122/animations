import 'package:flutter/material.dart';
import 'dart:math' show pi;

class AnimationFirstOne extends StatefulWidget {
  const AnimationFirstOne({Key? key}) : super(key: key);

  @override
  State<AnimationFirstOne> createState() => _AnimationFirstOneState();
}

class _AnimationFirstOneState extends State<AnimationFirstOne>
    with SingleTickerProviderStateMixin {

  /*
    0.0 = 0 degrees
    0.5 = 180 degrees
    1.0 = 360 degrees
  */

  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(
        seconds: 2,
      ),
    );

    _animation =
        Tween<double>(begin: 0.0, end: 2 * pi).animate(_animationController);

    _animationController.repeat();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: AnimatedBuilder(
          animation: _animationController,
          builder: (context, child) {
            return Transform(
              alignment: Alignment.center,
              transform: Matrix4.identity()..rotateZ(_animation.value),
              child: Container(
                height: 100,
                width: 100,
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}