import 'package:flutter/material.dart';
import 'package:usersms/utils/colors.dart';

class ChatBubble extends StatelessWidget {
  final String message;
  ChatBubble({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return  Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: LightColor.maincolor,

      ),
      child: Text(message, style: const TextStyle(fontSize: 16),),
    );
  }
}