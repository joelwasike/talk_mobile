import 'package:flutter/material.dart';
import 'package:usersms/resources/image_data.dart';
import 'package:usersms/utils/colors.dart';

class ForumCard extends StatefulWidget {
  final ImageData image;
  final String name;
  final String description;
  const ForumCard({super.key, required this.image, required this.name, required this.description});

  @override
  State<ForumCard> createState() => _ForumCardState();
}

class _ForumCardState extends State<ForumCard> {
  @override
  Widget build(BuildContext context) {
    return  Column(
      children: [
        const SizedBox(height: 5,),
        Container(
          height: MediaQuery.of(context).size.height/11,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6),
            image: DecorationImage(image: NetworkImage(widget.image.imageUrl), fit: BoxFit.cover, opacity: 0.2),
          ),
          child:  Padding(
            padding: const EdgeInsets.only(bottom: 15),
            child: ListTile(
               leading: CircleAvatar(
                maxRadius: 30,
                backgroundImage: NetworkImage(widget.image.imageUrl),
               ),
               title: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                 children: [
                   Text(widget.name,style:  TextStyle(color: Colors.grey.shade200, fontSize: 15)),
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
          ),
        ),
      ],
    );
  }
}