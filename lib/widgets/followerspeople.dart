import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:usersms/resources/apiconstatnts.dart';
import 'package:usersms/screens/profile/friendsprofile.dart';
import 'package:usersms/utils/colors.dart';

class PeopleFCard extends StatefulWidget {
  final bool isfollowing;
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
      required this.email,
      required this.isfollowing});

  @override
  State<PeopleFCard> createState() => _PeopleFCardState();
}

class _PeopleFCardState extends State<PeopleFCard> {
  bool following = false;

  Future follow() async {
    var box = Hive.box("Talk");
    var userid = box.get("id");
    print(userid);
    Map body = {"userid": userid, "userid2": widget.id};
    final url = Uri.parse('$baseUrl/follow');
    final response = await http.post(url, body: jsonEncode(body));
    print(response.body);

    if (response.statusCode == 200) {
      print("followed succesfully");
      print(response.body);
    } else {
      print(response.body);
      print('HTTP Request Error: ${response.statusCode}');
    }
  }

  Future unfollow() async {
    var box = Hive.box("Talk");
    var userid = box.get("id");
    print(userid);
    Map body = {"userid": userid, "userid2": widget.id};
    final url = Uri.parse('$baseUrl/unfollow');
    final response = await http.post(url, body: jsonEncode(body));
    print(response.body);

    if (response.statusCode == 200) {
      print("unfollowed succesfully");
      print(response.body);
    } else {
      print(response.body);
      print('HTTP Request Error: ${response.statusCode}');
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    following = widget.isfollowing;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: 10,
        ),
        ListTile(
          leading: GestureDetector(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute<void>(
                builder: (context) {
                  return Scaffold(
                    body: Center(
                      child: Hero(
                        tag: 'profile_image',
                        child: CachedNetworkImage(
                          imageUrl: widget.image!,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => Container(),
                          errorWidget: (context, url, error) => Icon(
                            Icons.error,
                            color: LightColor.background,
                            size: 30,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ));
            },
            child: CircleAvatar(
                maxRadius: 30,
                backgroundImage: CachedNetworkImageProvider(widget.image!)),
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
              GestureDetector(
                onTap: () {
                  setState(() {
                    following = !following;
                    if (following == true) {
                      follow();
                    }
                    if (following == false) {
                      unfollow();
                    }
                  });
                },
                child: Container(
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
                        child: !following
                            ? Text(
                                "Follow",
                                style: TextStyle(
                                    color: LightColor.maincolor, fontSize: 12),
                              )
                            : Text(
                                "Unfollow",
                                style: TextStyle(
                                    color: LightColor.maincolor, fontSize: 12),
                              )),
                  ),
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}
