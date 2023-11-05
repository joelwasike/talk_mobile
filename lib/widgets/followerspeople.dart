import 'package:flutter/material.dart';
import 'package:usersms/screens/profile/friendsprofile.dart';
import 'package:usersms/utils/colors.dart';

class PeopleFCard extends StatefulWidget {
  final int? id;
  final String? image;
  final String? name;
  final String? email;
  final String? school;
  const PeopleFCard(
      {super.key,
      required this.image,
      required this.name,
      required this.school,
      required this.id,
      required this.email});

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
            backgroundImage: NetworkImage(widget.image!),
          ),
          title: Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      (context),
                      MaterialPageRoute(
                          builder: (context) => FProfileScren(
                                campus: widget.school!,
                                id: widget.id!,
                                email: widget.email!,
                                profilepic: widget.image!,
                                username: widget.name!,
                              )),
                    );
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.name!,
                        style: TextStyle(
                            color: Colors.grey.shade100, fontSize: 15),
                      ),
                      Text(
                        widget.school!,
                        style:
                            const TextStyle(color: Colors.grey, fontSize: 12),
                      )
                    ],
                  ),
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
                  child: Center(
                      child: Text(
                    "Follow",
                    style: TextStyle(color: LightColor.maincolor),
                  )),
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}
