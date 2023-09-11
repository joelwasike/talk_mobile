
import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:usersms/resources/user_posts.dart';
import 'package:usersms/utils/colors.dart';

import 'image_data.dart';

class Clubpost extends StatefulWidget {
  final String title;
  const Clubpost({Key? key, required this.title}) : super(key: key);

  @override
  State<Clubpost> createState() => _ClubpostState();
}

class _ClubpostState extends State<Clubpost> {
  List people = [
    "Joel",
    "Delan",
    "Wicky",
    "Salim",
    "Benna",
    "Chalo",
    "Wasike",
    "Fello"
  ];

    ScrollController _scrollController = ScrollController(); // Add this line

  @override
  void dispose() {
    _scrollController.dispose(); // Dispose the scroll controller
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: LightColor.background),      
        toolbarHeight: 29,
        backgroundColor: const Color(0xFF121212),
        title: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FadeInRight(
                  child: Text("${widget.title} Club",
                      style: GoogleFonts.aguafinaScript(
                        textStyle: const TextStyle(
                          color: Colors.white,
                          fontSize: 25,
                          fontWeight: FontWeight.w900,
                        ),
                      ))),
        ],
      ),),
       body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          
          Expanded(
            child: ListView.builder(
              itemCount: people.length,
              itemBuilder: (context, index) {
                  return UserPost(
                    scrollController: _scrollController,
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
