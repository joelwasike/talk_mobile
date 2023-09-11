import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:usersms/resources/forum_posts.dart';
import 'package:usersms/widgets/forum_card.dart';
import '../resources/image_data.dart';
import '../resources/searchforumfriends.dart';
import '../screens/homepage.dart';
import '../utils/colors.dart';

class Forums extends StatefulWidget {
  const Forums({super.key});

  @override
  State<Forums> createState() => _ForumsState();
}

class _ForumsState extends State<Forums> {
    List forums = [
    "Computer ",
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
        toolbarHeight: 30,
        automaticallyImplyLeading: false,
        backgroundColor: LightColor.maincolor1,
        title: Padding(
          padding: const EdgeInsets.only(left: 56),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              FadeInRight(
                    child: Text('Forums',
                        style: GoogleFonts.aguafinaScript(
                          textStyle: const TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.w900,
                          ),
                        ))),
              IconButton(
                  onPressed: () {
                     Navigator.push(
                      (context),
                      MaterialPageRoute(builder: (context) => const GetForumPeople()
                         
                          ),
                    );
                  },
                  icon: Icon(
                    Icons.add_box,
                    color: LightColor.background,
                  ))
            ],
          ),
        ),
      ),
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
           Padding(
            padding: EdgeInsets.only(top: 16, left: 16, right: 16),
            child: TextField(
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: "Search group...",
                hintStyle: TextStyle(color: Colors.grey.shade600),
                prefixIcon: Icon(
                  Icons.search,
                  color: Colors.grey.shade600,
                  size: 20,
                ),
                filled: true,
                fillColor: LightColor.maincolor1,
                contentPadding: EdgeInsets.all(8),
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide(color: Colors.grey.shade600)),
              ),
            ),
          ),
          SizedBox(
            height: 5,
          ),
        
          Expanded(
            child: ListView.builder(
              physics: BouncingScrollPhysics(),
              itemCount: forums.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                     Navigator.push(
                    (context),
                    MaterialPageRoute(builder: (context) =>  ForumPosts(title: forums[index],)
                     
                        ),
                  );
                  },
                  child: ForumCard(
                    name: forums[index],
                    image: imageList[index],
                    description: "This is the best message ever seen in this world and its known as joel wasike",
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