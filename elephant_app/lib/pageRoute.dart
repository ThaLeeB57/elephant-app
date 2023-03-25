import 'package:flutter/material.dart';

class PersonalizedRoute {
  Widget nextPage;
  int duration;
  Offset begin;
  Offset end;
  Curve curve;

  PersonalizedRoute(
      {required this.nextPage,
      this.duration = 500,
      this.begin = const Offset(0.0, 1),
      this.end = const Offset(0, 0),
      this.curve = Curves.ease});

  Route next() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => nextPage,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
      transitionDuration: Duration(milliseconds: duration),
    );
  }
}
