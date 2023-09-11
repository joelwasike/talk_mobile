import 'package:flutter/material.dart';

import '../screens/homepage.dart';

class Television extends StatefulWidget {
  const Television({super.key});

  @override
  State<Television> createState() => _TelevisionState();
}

class _TelevisionState extends State<Television> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
            body: const Center(child: Text("Television", style: TextStyle(color: Colors.white),),),
      floatingActionButton: SizedBox(
        height: 50,
        width: 50,
        child: FloatingActionButton(
            onPressed: () {},
            backgroundColor: Colors.grey.shade900,
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(30.0))),
            child: const DrawerWidget()),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
      
    );
  }
}