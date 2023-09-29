import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:usersms/resources/addgossip.dart';
import '../resources/image_data.dart';
import '../resources/user_posts.dart';
import '../screens/homepage.dart';
import '../utils/colors.dart';


class Gossip extends StatefulWidget {
  const Gossip({super.key});

  @override
  State<Gossip> createState() => _GossipState();
}

class _GossipState extends State<Gossip> {
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
    return  Scaffold(
       appBar: AppBar(
        automaticallyImplyLeading: false,
        iconTheme: IconThemeData(color: LightColor.background),      
        toolbarHeight: 29,
        backgroundColor: const Color(0xFF121212),
        title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          FadeInLeft(child: const DrawerWidget()),
          FadeInRight(
                  child: Text("Campus Gossip",
                      style: GoogleFonts.aguafinaScript(
                        textStyle: const TextStyle(
                          color: Colors.white,
                          fontSize: 25,
                          fontWeight: FontWeight.w900,
                        ),
                      ))),
        ],
      ),),
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SizedBox(
          height: 40,
          width: 40,
          child: FloatingActionButton(
              onPressed: () {
                 Navigator.push(
                      (context),
                      MaterialPageRoute(builder: (context) => const AddGossip()
                         
                          ),
                    );
              },
              backgroundColor: Colors.grey.shade900,
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(30.0))),
              child: Icon(Icons.add, color: LightColor.background,)),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
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