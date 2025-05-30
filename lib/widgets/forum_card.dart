import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:usersms/utils/colors.dart';

class ForumCard extends StatefulWidget {
  final String image;
  final String name;
  final String description;
  const ForumCard(
      {super.key,
      required this.image,
      required this.name,
      required this.description});

  @override
  State<ForumCard> createState() => _ForumCardState();
}

class _ForumCardState extends State<ForumCard> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: 5,
        ),
        Container(
          height: MediaQuery.of(context).size.height / 9,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6),
            image: DecorationImage(
              image: CachedNetworkImageProvider(widget.image),
              fit: BoxFit.cover,
              opacity: 0.2,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.only(bottom: 15),
            child: ListTile(
              leading: CachedNetworkImage(
                imageUrl: widget.image,
                imageBuilder: (context, imageProvider) => CircleAvatar(
                  maxRadius: 30,
                  backgroundImage: imageProvider,
                ),
                placeholder: (context, url) => CircleAvatar(
                  maxRadius: 30,
                  backgroundColor: Colors.grey,
                ),
                errorWidget: (context, url, error) => CircleAvatar(
                  maxRadius: 30,
                  backgroundColor: Colors.grey,
                  child: Icon(
                    Icons.error,
                    color: Colors.red,
                  ),
                ),
              ),
              title: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.name,
                    style: TextStyle(color: Colors.grey.shade200, fontSize: 15),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    widget.description,
                    style: const TextStyle(color: Colors.grey, fontSize: 12),
                  )
                ],
              ),
              trailing: Container(
                width: 10,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: LightColor.maincolor,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
