import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:usersms/screens/addposts.dart';
import 'package:usersms/screens/homepage.dart';
import 'package:usersms/screens/reels.dart';
import 'package:usersms/screens/searchpage.dart';
import 'package:usersms/screens/profile/profile_screen.dart';

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
    const WhatsappPickPhoto(),
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
        body: selectedIndex < pages.length ? pages[selectedIndex] : Container(),
        bottomNavigationBar: selectedIndex < pages.length
            ? GNav(
                backgroundColor: Colors.black,
                tabBorderRadius: 10.0,
                padding: const EdgeInsets.all(10),
                tabBackgroundColor: Colors.black,
                color: Colors.grey.shade300,
                activeColor: Color.fromARGB(255, 22, 136, 230),
                gap: 8,
                tabs: [
                  GButton(
                    icon: FontAwesomeIcons.house,
                    iconSize: 20,
                    text: "Home",
                    iconColor: Colors.grey.shade400,
                  ),
                  // GButton(icon: Icons.video_call,
                  // text: "Status",

                  // ),
                  GButton(
                    icon: FontAwesomeIcons.magnifyingGlass,
                    iconColor: Colors.grey.shade300,
                    text: "Search",
                    iconSize: 20,
                  ),
                  GButton(
                    icon: FontAwesomeIcons.camera,
                    iconSize: 20,
                    text: "Post",
                    iconColor: Colors.grey.shade300,
                  ),
                  GButton(
                    icon: FontAwesomeIcons.video,
                    iconSize: 20,
                    text: "Reels",
                    iconColor: Colors.grey.shade300,
                  ),
                  GButton(
                    icon: FontAwesomeIcons.userLarge,
                    iconSize: 20,
                    text: "Profile",
                    iconColor: Colors.grey.shade300,
                  ),
                ],
                selectedIndex: selectedIndex,
                onTabChange: _onItemTapped,
              )
            : null);
  }
}
