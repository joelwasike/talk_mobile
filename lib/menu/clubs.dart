import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:usersms/resources/club_post.dart';
import 'package:usersms/widgets/club_card.dart';
import '../resources/image_data.dart';
import '../resources/searchclubpeople.dart';
import '../screens/homepage.dart';
import '../utils/colors.dart';

class Clubs extends StatefulWidget {
  const Clubs({super.key});

  @override
  State<Clubs> createState() => _ClubsState();
}

class _ClubsState extends State<Clubs> {
    List clubs = [
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
    return  Scaffold(
       appBar: AppBar(
  
        leading: DrawerWidget(),
        toolbarHeight: 30,
        backgroundColor: LightColor.scaffold,
        title: Padding(
          padding: const EdgeInsets.only(left: 56),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Spacer(),
              FadeInRight(
                    child: Text('Clubs & Societies',
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
                      MaterialPageRoute(builder: (context) => const GetClubPeople()
                         
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
                hintText: "Search clubs and societies...",
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
              itemCount: clubs.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                     Navigator.push(
                    (context),
                    MaterialPageRoute(builder: (context) =>  Clubpost(title: clubs[index],)
                       
                        ),
                  );
                  },
                  child: FadeInRight(
                    child: ClubCard(
                      name: clubs[index],
                      image: imageList[index],
                      description: "This is the best message ever seen in this world and its known as joel wasike",
                    ),
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