import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:usersms/resources/groupchat.dart';
import 'package:usersms/resources/searchgroupadd.dart';
import 'package:usersms/utils/colors.dart';
import 'package:usersms/widgets/group_card.dart';
import '../resources/image_data.dart';
import '../screens/homepage.dart';

class Groups extends StatefulWidget {
  const Groups({super.key});

  @override
  State<Groups> createState() => _GroupsState();
}

class _GroupsState extends State<Groups> {
  List groups = [
    "Computer Science",
    "Literature",
    "Art",
    "Kiswahili",
    "Impala",
    "Nairobi Gossip",
    "Kilimani",
    "Kibabii University"
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: DrawerWidget(),
        toolbarHeight: 30,
        backgroundColor: LightColor.scaffold,
        title: Padding(
          padding: const EdgeInsets.only(left: 56),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              FadeInRight(
                    child: Text('Groups',
                        style: GoogleFonts.aguafinaScript(
                          textStyle: const TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.w900,
                          ),
                        ))),
             
            ],
          ),
        ),
      ),
       floatingActionButton: FloatingActionButton(
        backgroundColor:
            Colors.transparent, // Set the background color to transparent
        mini: false,
        shape: const CircleBorder(), // Use CircleBorder to create a round button
        onPressed: () {
           Navigator.push(
                      (context),
                      MaterialPageRoute(builder: (context) => const GetGroupPeople()
                         
                          ),
                    );
        },
        child: Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: LightColor.maincolor, // Specify the border color here
            ),
          ),
          child:  Center(
            child: Icon(Icons.add_box,color: LightColor.maincolor,)
          ),
        ),
      ),
      
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
           Padding(
            padding: const EdgeInsets.only(top: 2, left: 6, right: 2),
            child: TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.grey.shade600),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(6),
                  borderSide: BorderSide(color: Colors.grey.shade600),
                ),
                hintText: "Search group...",
                hintStyle: TextStyle(color: Colors.grey.shade600),
                prefixIcon: Icon(
                  Icons.search,
                  color: Colors.grey.shade600,
                  size: 20,
                ),
                filled: true,
                fillColor: LightColor.maincolor1,
                contentPadding: const EdgeInsets.all(8),
              ),
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          Expanded(
            child: ListView.builder(
              physics: const BouncingScrollPhysics(),
              itemCount: groups.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                     Navigator.push(
                    (context),
                    MaterialPageRoute(builder: (context) => const Groupchat()
                       
                        ),
                  );
                  },
                  child: Groupcard(
                    name: groups[index],
                    image: imageList[index],
                    description: "This is the best group ever seen in this world and its known as joel wasike",
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
