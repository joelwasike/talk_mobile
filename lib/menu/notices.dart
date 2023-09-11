import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:usersms/resources/notice_post.dart';
import '../resources/image_data.dart';
import '../resources/user_posts.dart';
import '../screens/homepage.dart';
import '../utils/colors.dart';


class Notices extends StatefulWidget {
  const Notices({super.key});

  @override
  State<Notices> createState() => _NoticesState();
}

class _NoticesState extends State<Notices> {
   List people = [
    "Fee Notice",
    "Cultural night",
    "Campus Night",
    "Hostel Cleaning",
    "Strike Notice",
  ];
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
       appBar: AppBar(
        iconTheme: IconThemeData(color: LightColor.background),      
        toolbarHeight: 29,
        backgroundColor: const Color(0xFF121212),
        title: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FadeInRight(
                  child: Text("Campus Notices",
                      style: GoogleFonts.aguafinaScript(
                        textStyle: const TextStyle(
                          color: Colors.white,
                          fontSize: 25,
                          fontWeight: FontWeight.w900,
                        ),
                      ))),
        ],
      ),),
      floatingActionButton: SizedBox(
        height: 40,
        width: 40,
        child: FloatingActionButton(
            onPressed: () {},
            backgroundColor: Colors.grey.shade900,
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(30.0))),
            child: const DrawerWidget()),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
        body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          
          Expanded(
            child: ListView.builder(
              itemCount: people.length,
              itemBuilder: (context, index) {
                  return NoticePost(
                    name: people[index],
                    image: imageList[index] ,
                  );
                
              },
            ),
          ),
        ],
      ),
      
    );
  }
}