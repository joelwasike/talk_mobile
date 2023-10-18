import 'package:flutter/material.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:usersms/screens/addpost.dart';
import 'package:usersms/screens/homepage.dart';
import 'package:usersms/screens/reels.dart';
import 'package:usersms/screens/searchpage.dart';
import 'package:usersms/screens/status.dart';
import 'package:usersms/screens/profile/profile_screen.dart';

import '../utils/colors.dart';

class BottomNav extends StatefulWidget {
  const BottomNav({super.key});

  @override
  State<BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  int selectedIndex = 0;

  final List<Widget> pages = [
   const Homepage(),
  // const StatusScreen(),
   const SearchScreen(),
    const AlbumPage(),
     Reels(),
   const ProfileScren()
  ];

  void _onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: selectedIndex < pages.length
          ? pages[selectedIndex]
          : Container(),
      bottomNavigationBar: selectedIndex < pages.length
          ? GNav(
          
          backgroundColor: Colors.black,
          tabBorderRadius: 10.0,
          padding: const EdgeInsets.all(10),
          tabBackgroundColor: Colors.black,
          color: Colors.grey.shade300,
          activeColor: Color.fromARGB(255, 22, 136, 230),
          gap: 8,
          tabs:  [
            GButton(
              icon: FontAwesomeIcons.house,
              text: "Home",
              iconColor: Colors.grey.shade400,
            ),
            // GButton(icon: Icons.video_call,
            // text: "Status",
            
            // ),
            GButton(
              icon: FontAwesomeIcons.magnifyingGlass,iconColor: Colors.grey.shade400,
              text: "Search",
            ),
            GButton(
              icon: FontAwesomeIcons.camera,
              text: "Post",
              iconColor: Colors.grey.shade400,
            ),
            GButton(
              icon: FontAwesomeIcons.video,
              text: "Reels",
              iconColor: Colors.grey.shade400,
            ),
            GButton(
              icon: FontAwesomeIcons.userLarge,
              text: "Profile",
              iconColor: Colors.grey.shade400,
            ),
          ],
          selectedIndex: selectedIndex,
          onTabChange: _onItemTapped,
          ):null
    );
  }
}
