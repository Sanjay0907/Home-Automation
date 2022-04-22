import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class BackgroundGradient extends StatelessWidget {
  BackgroundGradient({Key? key, required this.child}) : super(key: key);
  Widget child;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100.h,
      width: 100.w,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color.fromARGB(255, 17, 17, 17),
            Color.fromARGB(255, 12, 12, 12),
            Color.fromARGB(255, 5, 5, 5),
            Colors.black,
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(child: child),
      ),
    );
  }
}
