import 'package:flutter/material.dart';


class AnimationSix extends StatelessWidget {
  const AnimationSix({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CustomPaint(
          child: Container(
            height: MediaQuery.of(context).size.width,
            width: MediaQuery.of(context).size.width,
          ),
        ),
      ),
    );
  }
}
