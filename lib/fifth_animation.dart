import 'dart:math' show pi, Random;

import 'package:flutter/material.dart';

class CircleClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.reset();
    path.moveTo(size.width / 2, 0);
    path.lineTo(size.width, size.width);
    path.lineTo(0, size.width);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true;
  }
}

class AnimationFifthOne extends StatefulWidget {
  const AnimationFifthOne({Key? key}) : super(key: key);

  @override
  State<AnimationFifthOne> createState() => _AnimationFifthOneState();
}

class _AnimationFifthOneState extends State<AnimationFifthOne>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late AnimationController _controller2;
  late Animation _animation;
  late Animation _animation2;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _controller2 = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _animation = Tween<double>(
      begin: 0,
      end: 200,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.bounceOut,
      ),
    );

    _animation2 = Tween<double>(
      begin: 0,
      end: 2*pi,
    ).animate(_controller2);

    _controller.forward();

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _controller.reverse();
      } else if (status == AnimationStatus.dismissed) {
        _controller.forward();
      }
    });

    _controller2
      .forward();

    _controller2.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _animation2 = Tween<double>(
          begin: _animation2.value,
          end: _animation2.value + 2*pi,
        ).animate(_controller2);
        _controller2.reverse();
      } else if (status == AnimationStatus.dismissed) {
        _animation2 = Tween<double>(
          begin: _animation2.value +2*pi,
          end: _animation2.value ,
        ).animate(_controller2);
        _controller2.forward();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Color _getRandomColor() {
    return Color((Random().nextDouble() * 0xFFFFFF).toInt()).withOpacity(1.0);
  }

  Color _color = Colors.red;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: TweenAnimationBuilder(
        onEnd: () {
          setState(() {
            _color = _getRandomColor();
          });
        },
        //curve: Curves.fastOutSlowIn,
        tween: ColorTween(
          begin: Colors.red,
          end: _getRandomColor(),
        ),
        duration: const Duration(milliseconds: 300),
        child: Center(
          child: AnimatedBuilder(
            animation: _controller2,
            builder: (context, child) => Transform(
              alignment: Alignment.center,
              transform: Matrix4.identity()..rotateZ(_animation2.value),
              child: ClipPath(
                clipper: CircleClipper(),
                child: AnimatedBuilder(
                  animation: _controller,
                  builder: (context, child) => Container(
                    color: Colors.red,
                    height: _animation.value,
                    width: _animation.value,
                  ),
                ),
              ),
            ),
          ),
        ),
        builder: (context, value, child) {
          return ColorFiltered(
            colorFilter: ColorFilter.mode(
              _color,
              BlendMode.srcATop,
            ),
            child: child,
          );
        },
      ),
    );
  }
}
