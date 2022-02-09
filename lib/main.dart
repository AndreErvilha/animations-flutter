import 'dart:math' as math;

import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  static const String _title = 'Flutter Code Sample';

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: _title,
      home: MyStatefulWidget(),
    );
  }
}

class JumppingContainer extends AnimatedWidget {
  final Animation rotation;
  const JumppingContainer({
    Key? key,
    required Animation jump,
    required this.rotation,
  }) : super(key: key, listenable: jump);

  Animation<double> get _progress => listenable as Animation<double>;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SizedBox(
          width: 200.0,
          height: 200.0,
          child: Stack(
            children: [
              Positioned(
                bottom: _progress.value * 100,
                left: 0,
                right: 0,
                child: Center(child: RotateContainer(rotation: rotation)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class RotateContainer extends AnimatedWidget {
  const RotateContainer({
    Key? key,
    required Animation rotation,
  }) : super(key: key, listenable: rotation);

  Animation<double> get _progress => listenable as Animation<double>;

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: 2 * math.pi * _progress.value,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.red,
        ),
        height: 100,
        width: 100,
      ),
    );
  }
}

class MyStatefulWidget extends StatefulWidget {
  const MyStatefulWidget({Key? key}) : super(key: key);

  @override
  State<MyStatefulWidget> createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget>
    with TickerProviderStateMixin {
  late Animation<double> curve;

  late final AnimationController _controller;
  late final AnimationController _controller2;

  @override
  initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 700),
      vsync: this,
    )..repeat();

    _controller2 = AnimationController(
      duration: const Duration(seconds: 2, milliseconds: 800),
      vsync: this,
    )..repeat();

    curve = CurvedAnimation(parent: _controller, curve: const JumpCurve());
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: JumppingContainer(
      jump: curve,
      rotation: _controller2,
    ));
  }
}

class JumpCurve extends Curve {
  const JumpCurve();

  @override
  double transformInternal(double t) {
    var val = -4 * (t * t) + 4 * t;
    return val;
  }
}
