import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:usersms/resources/searchmessagingperson.dart';
import 'package:usersms/resources/testchat.dart';
import 'package:usersms/utils/colors.dart';
import 'package:usersms/widgets/message_card.dart';
import '../resources/image_data.dart';
import '../screens/homepage.dart';

class Messenger extends StatefulWidget {
  const Messenger({super.key});

  @override
  State<Messenger> createState() => _MessengerState();
}

class _MessengerState extends State<Messenger> {
  List people = [
    "Joel",
    "Davis",
    "Peris",
    "Delan",
    "Wiky",
    "Felo",
    "Bena",
    "Chalo"
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: FadeInLeft(child: const DrawerWidget()),
        toolbarHeight: 30,
        backgroundColor: LightColor.scaffold,
        title: Padding(
          padding: const EdgeInsets.only(left: 56),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              FadeInRight(
                  child: Text('Messenger',
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
                      MaterialPageRoute(builder: (context) => const GetMessagingPerson()
                         
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
            child: Icon(Icons.message,color: LightColor.maincolor,)
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
                hintText: "Search friends...",
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
            height: 10,
          ),
          Expanded(
            child: ListView.builder(
              physics: const BouncingScrollPhysics(),
              itemCount: people.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      (context),
                      MaterialPageRoute(builder: (context) =>  ChatPagee(name: people[index],)
                         
                          ),
                    );
                  },
                  child: MessageCard(
                    name: people[index],
                    image: imageList[index],
                    description:
                        "This is the best message ever seen in this world and its known as joel wasike",
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
