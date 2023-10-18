import 'package:flutter/material.dart';
import 'dart:math' as math;

import 'package:usersms/utils/colors.dart';

class ProfileBackground extends StatelessWidget {
  const ProfileBackground({Key? key, required this.child}) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: [
        
          Positioned(
            top: -140,
            child: Transform.rotate(
              angle: math.pi / 4,
              child: Container(
                height: size.height * 0.60,
                width: size.height * 0.60,
                decoration: BoxDecoration(
                  border: Border.all(width: 1.0, color: LightColor.maincolor),
                  borderRadius: BorderRadius.circular(152.0),
                ),
              ),
            ),
          ),
          Positioned(
            top: -150,
            child: Transform.rotate(
              angle: math.pi / 4,
              child: Container(
                height: size.height * 0.60,
                width: size.height * 0.60,
                decoration: BoxDecoration(
                  color: LightColor.maincolor,
                  borderRadius: BorderRadius.circular(152.0),
                ),
              ),
            ),
          ),
          child,
        ],
      ),
    );
  }
}
