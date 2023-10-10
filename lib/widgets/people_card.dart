import 'package:flutter/material.dart';
import 'package:usersms/resources/image_data.dart';

class PeopleCard extends StatefulWidget {
  final ImageData image;
  final String name;
  final String followers;
  const PeopleCard({super.key, required this.image, required this.name, required this.followers});

  @override
  State<PeopleCard> createState() => _PeopleCardState();
}

class _PeopleCardState extends State<PeopleCard> {
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
             Text(widget.name,style:  TextStyle(color: Colors.grey.shade200, fontSize: 15)),
             Text("online", style: const TextStyle(color: Colors.grey, fontSize: 12),)
           ],
         ),
        
        ),
      ],
    );
  }
}