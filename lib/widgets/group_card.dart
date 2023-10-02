import 'package:flutter/material.dart';
import 'package:usersms/resources/image_data.dart';
import 'package:usersms/utils/colors.dart';

class Groupcard extends StatefulWidget {
  final ImageData image;
  final String name;
  final String description;
  const Groupcard({super.key, required this.image, required this.name, required this.description});

  @override
  State<Groupcard> createState() => _GroupcardState();
}

class _GroupcardState extends State<Groupcard> {
  @override
  Widget build(BuildContext context) {
    return
    
    Column(
      children: [
        
        Container(
          height: MediaQuery.of(context).size.height/11,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
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
                   Text(widget.name),
                   Text(widget.description, style: const TextStyle(color: Colors.grey, fontSize: 11),)
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
        const SizedBox(height: 5,),
      ],
    );
  }
}