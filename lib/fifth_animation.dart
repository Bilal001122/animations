import 'dart:math';

import 'package:flutter/material.dart';

class CircleClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.reset();
    path.moveTo(size.width / 2, 0);
    path.lineTo(size.width , size.width);
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

class _AnimationFifthOneState extends State<AnimationFifthOne> {


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
        duration: const Duration(milliseconds: 300 ),
        child: Center(
          child: ClipPath(
            clipper: CircleClipper(),
            child: Container(
              color: Colors.red,
              height: MediaQuery.of(context).size.width,
              width: MediaQuery.of(context).size.width,
            ),
          ),
        ),
        builder: (context, value, child) {
          return ColorFiltered(
            colorFilter:  ColorFilter.mode(
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
