import 'package:flutter/material.dart';
import 'package:usersms/resources/image_data.dart';
import 'package:usersms/utils/colors.dart';

class PeopleFCard extends StatefulWidget {
  final ImageData image;
  final String name;
  final String school;
  const PeopleFCard(
      {super.key,
      required this.image,
      required this.name,
      required this.school});

  @override
  State<PeopleFCard> createState() => _PeopleFCardState();
}

class _PeopleFCardState extends State<PeopleFCard> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: 10,
        ),
        ListTile(
          leading: CircleAvatar(
            maxRadius: 30,
            backgroundImage: NetworkImage(widget.image.imageUrl),
          ),
          title: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.name,
                      style:
                          TextStyle(color: Colors.grey.shade100, fontSize: 15),
                    ),
                    Text(
                      widget.school,
                      style: const TextStyle(color: Colors.grey, fontSize: 12),
                    )
                  ],
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(7),
                  border: Border.all(
                    color:
                        LightColor.maincolor, // Specify the border color here
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Center(child: Text("Follow", style: TextStyle(color: LightColor.maincolor),)),
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}
