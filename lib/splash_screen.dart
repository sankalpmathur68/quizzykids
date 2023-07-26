import 'dart:async';

// import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';

import 'dart:math' as math;

class splashScreen extends StatefulWidget {
  @override
  State<splashScreen> createState() => _splashScreenState();
}

class _splashScreenState extends State<splashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(seconds: 5), // Adjust the duration as needed
      vsync: this,
    )..repeat();
    if (mounted) {
      Timer(Duration(seconds: 3),
          () => Navigator.of(context, rootNavigator: true).pop());
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentheight = MediaQuery.of(context).size.height;
    final currentwidth = MediaQuery.of(context).size.width;
    print(currentheight);
    print(currentwidth);
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Transform.rotate(
                    angle: _controller.value * 2.0 * math.pi,
                    child: Image.asset(
                      "assets/images/splash.png",
                      alignment: Alignment.center,
                      height: MediaQuery.of(context).size.height / 3,
                      width: MediaQuery.of(context).size.width / 2,
                    ),
                  ),
                ],
              );
            }),
      ),
      // Container(
      //     child: Column(
      //   mainAxisAlignment: MainAxisAlignment.center,
      //   children: [
      //     Image.asset(
      //       "assets/images/fleetlogolight-trans.png",
      //       height: MediaQuery.of(context).size.height / 3,
      //       width: MediaQuery.of(context).size.height,
      //     ),

      //   ],
      // )),
    );
  }
}

class FadeRoute extends PageRouteBuilder {
  final Widget page;

  FadeRoute({required this.page})
      : super(
          pageBuilder: (context, animation, secondaryAnimation) => page,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            var begin = const Offset(0.0, 1.0);
            var end = Offset.zero;
            var curve = Curves.ease;

            var tween = Tween(begin: begin, end: end);
            var curvedAnimation = CurvedAnimation(
              parent: animation,
              curve: curve,
            );

            return SlideTransition(
              position: tween.animate(curvedAnimation),
              child: child,
            );
          },
        );
}
