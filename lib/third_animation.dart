import 'package:flutter/material.dart';
import 'dart:math' show pi;
import 'package:vector_math/vector_math_64.dart' show Vector3;

class AnimationThirdOne extends StatefulWidget {
  const AnimationThirdOne({Key? key}) : super(key: key);

  @override
  State<AnimationThirdOne> createState() => _AnimationThirdOneState();
}

class _AnimationThirdOneState extends State<AnimationThirdOne>
    with TickerProviderStateMixin {
  late AnimationController _xController;
  late AnimationController _yController;
  late AnimationController _zController;

  late Tween<double> _animation;

  @override
  void initState() {
    super.initState();
    _xController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    );
    _yController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    );
    _zController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 30),
    );

    _animation = Tween<double>(
        begin: 0,
        end:
            pi);   // we didn't use .animate() here because we have multiple controllers
                  // so we use .evaluate() in the AnimatedBuilder to work just with one animation
  }

  @override
  void dispose() {
    _xController.dispose();
    _yController.dispose();
    _zController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _xController
      ..reset()
      ..repeat();
    _yController
      ..reset()
      ..repeat();
    _zController
      ..reset()
      ..repeat();

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(
                height: 20,
              ),
              AnimatedBuilder(
                // we use Listenable.merge() to merge multiple controllers into one animation
                // better than using multiple AnimatedBuilder
                animation: Listenable.merge(
                  [_xController, _yController, _zController],
                ),
                builder: (context, child) => Transform(
                  alignment: Alignment.center,
                  transform: Matrix4.identity()
                    ..rotateX(
                      _animation.evaluate(_xController),
                    )
                    ..rotateY(
                      _animation.evaluate(_yController),
                    )
                    ..rotateZ(
                      _animation.evaluate(_zController),
                    ),
                  child: Stack(
                    children: [
                      //front
                      Container(
                        color: Colors.red,
                        height: 100,
                        width: 100,
                      ),
                      //back
                      Transform(
                        alignment: Alignment.center,
                        transform: Matrix4.identity()
                          ..translate(
                            Vector3(0, 0, -100),
                          ),
                        child: Container(
                          color: Colors.green,
                          height: 100,
                          width: 100,
                        ),
                      ),
                      Transform(
                        alignment: Alignment.centerLeft,
                        transform: Matrix4.identity()..rotateY(pi / 2),
                        child: Container(
                          color: Colors.yellow,
                          height: 100,
                          width: 100,
                        ),
                      ),
                      Transform(
                        alignment: Alignment.centerRight,
                        transform: Matrix4.identity()..rotateY(-pi / 2),
                        child: Container(
                          color: Colors.blue,
                          height: 100,
                          width: 100,
                        ),
                      ),
                      Transform(
                        alignment: Alignment.topCenter,
                        transform: Matrix4.identity()..rotateX(-pi / 2),
                        child: Container(
                          color: Colors.orange,
                          height: 100,
                          width: 100,
                        ),
                      ),
                      Transform(
                        alignment: Alignment.bottomCenter,
                        transform: Matrix4.identity()..rotateX(pi / 2),
                        child: Container(
                          color: Colors.purple,
                          height: 100,
                          width: 100,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
