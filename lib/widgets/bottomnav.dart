import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:usersms/screens/addpost.dart';
import 'package:usersms/screens/homepage.dart';
import 'package:usersms/screens/reels.dart';
import 'package:usersms/screens/searchpage.dart';
import 'package:usersms/screens/status.dart';
import 'package:usersms/widgets/profile/profile_screen.dart';

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
   const StatusScreen(),
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
          backgroundColor: Colors.transparent,
          tabBorderRadius: 16.0,
          padding: const EdgeInsets.all(12),
          tabBackgroundColor: Colors.grey.shade900,
          color: Colors.white,
          activeColor: LightColor.maincolor,
          gap: 8,
          tabs: const [
            GButton(
              icon: Icons.home,
              text: "Home",
            ),
            GButton(icon: Icons.video_call,
            text: "Status",
            
            ),
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
