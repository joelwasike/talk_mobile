import 'package:flutter/material.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
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
          tabs: const [
            GButton(
              icon: Icons.home,
              text: "Home",
            ),
            // GButton(icon: Icons.video_call,
            // text: "Status",
            
            // ),
            GButton(
              icon: Icons.search,
              text: "Search",
            ),
            GButton(
              icon: Icons.add_a_photo,
              text: "Post",
            ),
            GButton(
              icon: Icons.videocam_sharp,
              text: "Reels",
            ),
            GButton(
              icon: Icons.person,
              text: "Profile",
            ),
          ],
          selectedIndex: selectedIndex,
          onTabChange: _onItemTapped,
          ):null
    );
  }
}
