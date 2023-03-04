import 'package:flutter/material.dart';
import 'dart:math' show pi;

enum CircleSide {
  left,
  right,
}

Path toPath(Size size, CircleSide circleSide) {
  final path = Path();
  late Offset offset;
  late bool clockWise;
  switch (circleSide) {
    case CircleSide.left:
      path.moveTo(size.width, 0);
      offset = Offset(size.width, size.height);
      clockWise = false;
      break;
    case CircleSide.right:
      path.moveTo(0, 0);
      offset = Offset(0, size.height);
      clockWise = true;
      break;
  }
  path.arcToPoint(
    offset,
    radius: Radius.elliptical(size.width / 2, size.height / 2),
    clockwise: clockWise,
  );
  path.close();
  return path;
}

class HalfCircleClipper extends CustomClipper<Path> {
  final CircleSide circleSide;

  HalfCircleClipper({required this.circleSide});

  @override
  Path getClip(Size size) {
    return toPath(size, circleSide);
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true;
  }
}

class AnimationSecondOne extends StatefulWidget {
  const AnimationSecondOne({Key? key}) : super(key: key);

  @override
  State<AnimationSecondOne> createState() => _AnimationSecondOneState();
}

class _AnimationSecondOneState extends State<AnimationSecondOne>
    with TickerProviderStateMixin {

  late AnimationController _counterClockwiseRotationController;
  late Animation<double> _counterClockwiseRotationAnimation;

  late AnimationController _flipController;
  late Animation<double> _flipAnimation;

  @override
  void initState() {
    super.initState();
    _counterClockwiseRotationController = AnimationController(
      vsync: this,
      duration: const Duration(
        seconds: 1,
      ),
    );

    _flipController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );

    _counterClockwiseRotationAnimation =
        Tween<double>(begin: 0.0, end: -(pi / 2)).animate(
      CurvedAnimation(
        parent: _counterClockwiseRotationController,
        curve: Curves.bounceOut,
      ),
    );

    _flipAnimation = Tween<double>(begin: 0.0, end: pi).animate(
      CurvedAnimation(
        parent: _flipController,
        curve: Curves.bounceOut,
      ),
    );

    // status listeners

    _counterClockwiseRotationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _flipAnimation = Tween<double>(
                begin: _flipAnimation.value, end: _flipAnimation.value + pi)
            .animate(
          CurvedAnimation(
            parent: _flipController,
            curve: Curves.bounceOut,
          ),
        );
        _flipController
          ..reset()
          ..forward();
      }
    });

    _flipController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _counterClockwiseRotationAnimation = Tween<double>(
                begin: _counterClockwiseRotationAnimation.value,
                end: -(pi  / 2) +  _counterClockwiseRotationAnimation.value)
            .animate(
          CurvedAnimation(
            parent: _counterClockwiseRotationController,
            curve: Curves.bounceOut,
          ),
        );
        _counterClockwiseRotationController
          ..reset()
          ..forward();
      }
    });
  }

  @override
  void dispose() {
    _counterClockwiseRotationController.dispose();
    _flipController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Future.delayed(
      const Duration(seconds: 1),
      () {
        _counterClockwiseRotationController
          ..reset()
          ..forward();
      },
    );

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: AnimatedBuilder(
            animation: _counterClockwiseRotationController,
            builder: (context, child) {
              return Transform(
                alignment: Alignment.center,
                transform: Matrix4.identity()
                  ..rotateZ(_counterClockwiseRotationAnimation.value),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AnimatedBuilder(
                      animation: _flipController,
                      builder: (context, child) => Transform(
                        alignment: Alignment.centerRight,
                        transform: Matrix4.identity()
                          ..rotateY(_flipAnimation.value),
                        child: ClipPath(
                          clipper:
                              HalfCircleClipper(circleSide: CircleSide.left),
                          child: Container(
                            color: Colors.blue,
                            width: 100,
                            height: 100,
                          ),
                        ),
                      ),
                    ),
                    AnimatedBuilder(
                      animation: _flipController,
                      builder: (context, child) => Transform(
                        alignment: Alignment.centerLeft,
                        transform: Matrix4.identity()
                          ..rotateY(_flipAnimation.value),
                        child: ClipPath(
                          clipper:
                              HalfCircleClipper(circleSide: CircleSide.right),
                          child: Container(
                            color: Colors.yellow,
                            width: 100,
                            height: 100,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
