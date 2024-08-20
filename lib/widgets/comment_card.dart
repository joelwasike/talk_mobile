import 'package:flutter/material.dart';
import '../utils/colors.dart';

class CommentCard extends StatefulWidget {
  final String username;
  final String profilepic;
  final String content;
  final String date;
  const CommentCard({
    Key? key,
    required this.username,
    required this.profilepic,
    required this.content,
    required this.date,
  }) : super(key: key);

  @override
  State<CommentCard> createState() => _CommentCardState();
}

class _CommentCardState extends State<CommentCard> {
  bool isliked = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage(widget.profilepic),
                radius: 20,
              ),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Joel Wasike",
                          style: TextStyle(
                            color: LightColor.maincolor,
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          widget.date,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w300,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 4),
                    Text(
                      widget.content,
                      style: TextStyle(
                          color: LightColor.background,
                          fontWeight: FontWeight.normal,
                          fontSize: 13),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    isliked = !isliked;
                  });
                },
                child: Container(
                  padding: const EdgeInsets.all(8),
                  child: Icon(
                    isliked ? Icons.favorite : Icons.favorite_border_outlined,
                    color: isliked ? Colors.red : Colors.white,
                    size: 20,
                  ),
                ),
              ),
            ],
          ),
        ),
        Divider(
          color: Colors.grey.shade700,
          height: .5,
        ),
      ],
    );
  }
}
