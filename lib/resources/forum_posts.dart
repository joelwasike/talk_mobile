
import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:usersms/resources/photo_user_posts.dart';
import 'package:usersms/utils/colors.dart';


class ForumPosts extends StatefulWidget {
  final String title;
  const ForumPosts({Key? key, required this.title}) : super(key: key);

  @override
  State<ForumPosts> createState() => _ForumPostsState();
}

class _ForumPostsState extends State<ForumPosts> {
   List imagelist = [
    'https://picsum.photos/seed/image001/500/500',
    'https://picsum.photos/seed/image001/500/500',
    'https://picsum.photos/seed/image001/500/500',
    'https://picsum.photos/seed/image001/500/500',
    'https://picsum.photos/seed/image001/500/500',

  ];

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
   final ScrollController _scrollController = ScrollController(); // Add this line

  @override
  void dispose() {
    _scrollController.dispose(); // Dispose the scroll controller
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: LightColor.background),      
        toolbarHeight: 29,
        backgroundColor: const Color(0xFF121212),
        title: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FadeInRight(
                  child: Text("${widget.title} Forum",
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
                    likes: 2,
                    content: "Today we gonna dance",
                    name: people[index],
                    image: imagelist[index] ,
                  );
                
              },
            ),
          ),
        ],
      ),
    );
  }
}
