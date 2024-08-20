import 'package:flutter/material.dart';
import 'package:usersms/resources/image_data.dart';
import 'package:usersms/resources/searchforumfriends.dart';
import 'package:usersms/utils/colors.dart';

class Sharepost extends StatefulWidget {
  final String postcommenturl;
  final String getcommenturl;
  final int postid;
  const Sharepost(
      {super.key,
      required this.postcommenturl,
      required this.getcommenturl,
      required this.postid});

  @override
  State<Sharepost> createState() => _SharepostState();
}

class _SharepostState extends State<Sharepost> {
  List<String> selectedNames = [];
  List people = [
    "Joel",
    "Delan",
    "Wicky",
    "Salim",
    "Benna",
    "Chalo",
    "Wasike",
    "Fello",
    "Joel",
    "Delan",
    "Wicky",
    "Salim",
    "Benna",
    "Chalo",
    "Wasike",
    "Fello"
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 10),
            const Text(
              "Share post to:",
              style: TextStyle(
                  fontSize: 16,
                  color: LightColor.background,
                  fontWeight: FontWeight.w700),
            ),
            Divider(color: Colors.grey.shade800),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                physics: const BouncingScrollPhysics(),
                itemCount: people.length,
                itemBuilder: (context, index) {
                  final isSelected = selectedNames.contains(people[index]);

                  return LongPressSelectableTile(
                    onTap: () {
                      setState(() {
                        if (selectedNames.isNotEmpty) {
                          if (isSelected) {
                            selectedNames.remove(people[index]);
                          }
                          if (!isSelected) {
                            selectedNames.add(people[index]);
                          }
                        }
                      });
                    },
                    onLongPress: () {
                      setState(() {
                        if (!isSelected) {
                          selectedNames.add(people[index]);
                        } else {
                          selectedNames.remove(people[index]);
                        }
                      });
                    },
                    isSelected: isSelected,
                    name: people[index],
                    image: imageList[index].imageUrl,
                    followers: "200k",
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
