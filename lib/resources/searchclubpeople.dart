import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:usersms/resources/clubcred.dart';



import '../utils/colors.dart';
import 'image_data.dart';

class GetClubPeople extends StatefulWidget {
  const GetClubPeople({super.key});

  @override
  State<GetClubPeople> createState() => _GetClubPeopleState();
}

class _GetClubPeopleState extends State<GetClubPeople> {
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
  
  List<String> selectedNames = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 30,
        iconTheme: const IconThemeData(color: LightColor.background),
        automaticallyImplyLeading: true,
        backgroundColor: LightColor.scaffold,
        title: Padding(
          padding: const EdgeInsets.only(left: 56),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              FadeInRight(
                  child: Text('Choose friends',
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
                      MaterialPageRoute(builder: (context) => const  ClubCred()
                         
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
            child: Icon(Icons.arrow_forward_ios,color: LightColor.maincolor,)
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
          const SizedBox(height: 20),
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
    );
  }
}

class LongPressSelectableTile extends StatelessWidget {
  final VoidCallback onTap;
  final VoidCallback onLongPress;
  final bool isSelected;
  final String name;
  final String image;
  final String followers;

  const LongPressSelectableTile({super.key, 
    required this.onTap,
    required this.onLongPress,
    required this.isSelected,
    required this.name,
    required this.image,
    required this.followers,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      onLongPress: onLongPress,
      child: ListTile(
        title: Text(name,style:  TextStyle(color: Colors.grey.shade200, fontSize: 13)),
        subtitle: Text("Followers: $followers",style: const TextStyle(color: Colors.grey, fontSize: 13),),
        leading: CircleAvatar(
          maxRadius: 30,
          backgroundImage: NetworkImage(image),
        ),
        trailing: isSelected
            ? const Icon(
                Icons.check_circle,
                color: LightColor.maincolor,
              )
            : const SizedBox(),
      ),
    );
  }
}
