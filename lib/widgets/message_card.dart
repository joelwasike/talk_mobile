import 'package:flutter/material.dart';
import 'package:usersms/resources/image_data.dart';
import 'package:usersms/utils/colors.dart';

class MessageCard extends StatefulWidget {
  final ImageData image;
  final String name;
  final String description;
  const MessageCard({super.key, required this.image, required this.name, required this.description});

  @override
  State<MessageCard> createState() => _MessageCardState();
}

class _MessageCardState extends State<MessageCard> {
  @override
  Widget build(BuildContext context) {
    return  Column(
      children: [
        const SizedBox(height: 10,),
        ListTile(
         leading: CircleAvatar(
          maxRadius: 30,
          backgroundImage: NetworkImage(widget.image.imageUrl),
         ),
         title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
           children: [
             Text(widget.name, style:  TextStyle(color: Colors.grey.shade200, fontSize: 15)),
             Text(widget.description, style: const TextStyle(color: Colors.grey, fontSize: 12),)
           ],
         ),
         trailing: Container(
          width: 10,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: LightColor.maincolor
          ),
         ),
        ),
      ],
    );
  }
}