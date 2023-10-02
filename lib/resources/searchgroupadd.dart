import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:usersms/resources/groupcredentials.dart';


import '../utils/colors.dart';
import 'image_data.dart';

class GetGroupPeople extends StatefulWidget {
  const GetGroupPeople({super.key});

  @override
  State<GetGroupPeople> createState() => _GetGroupPeopleState();
}

class _GetGroupPeopleState extends State<GetGroupPeople> {
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
        backgroundColor: LightColor.maincolor1,
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
       floatingActionButton: Padding(
         padding: const EdgeInsets.only(bottom: 40, right: 10),
         child: SizedBox(
          height: 50,
          width: 50,
          child: FloatingActionButton(
              onPressed: () {
                  Navigator.push(
                      (context),
                      MaterialPageRoute(builder: (context) => const  GroupCred()
                         
                          ),
                    );
              },
              backgroundColor: LightColor.maincolor,
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(30.0))),
              child: const Icon(Icons.arrow_forward,color: LightColor.background,)),
             ),
       ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,

      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 16, left: 16, right: 16),
            child: TextField(
              decoration: InputDecoration(
                border: InputBorder.none,
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
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide(color: Colors.grey.shade600)),
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
        title: Text(name),
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
