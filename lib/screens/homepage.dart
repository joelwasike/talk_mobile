import 'package:animate_do/animate_do.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:usersms/glassbox.dart';
import 'package:usersms/menu/clubs.dart';
import 'package:usersms/menu/forums.dart';
import 'package:usersms/menu/gossip.dart';
import 'package:usersms/menu/groups.dart';
import 'package:usersms/menu/messenger.dart';
import 'package:usersms/menu/notices.dart';
import 'package:usersms/menu/portal.dart';
import 'package:usersms/menu/tv.dart';
import 'package:usersms/resources/user_posts.dart';
import '../resources/image_data.dart';
import '../utils/colors.dart';

class Homepage extends StatefulWidget {
  const Homepage({Key? key}) : super(key: key);

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return ZoomDrawer(
      menuScreen: Builder(
        builder: (context) => DrawerScreen(
          setIndex: (index) {
            setState(() {
              currentIndex = index;
            });
            ZoomDrawer.of(context)!.close();
          },
        ),
      ),
      mainScreen: currentScreen(),
      borderRadius: 30,
      showShadow: true,
      angle: -13.0,
      slideWidth: 200,
      menuBackgroundColor: LightColor.maincolor1,
    );
  }

  Widget currentScreen() {
    switch (currentIndex) {
      case 0:
        return const HomeScreen();
      case 1:
        return const Messenger();
      case 2:
        return const Groups();
      case 3:
        return const Forums();
      case 4:
        return const Notices();
      case 5:
        return const Gossip();
      case 6:
        return const Clubs();
      case 7:
        return const Portal();
      case 8:
        return const Television();
      default:
        return const HomeScreen();
    }
  }
}

class HomeScreen extends StatefulWidget {
  final String title;
  const HomeScreen({Key? key, this.title = "Home"}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        appBar: AppBar(      
          toolbarHeight: 29,
          backgroundColor: const Color(0xFF121212),
          title: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            FadeInRight(
                    child: Text('Campus Talk',
                        style: GoogleFonts.aguafinaScript(
                          textStyle: const TextStyle(
                            color: Colors.white,
                            fontSize: 25,
                            fontWeight: FontWeight.w900,
                          ),
                        ))),
          ],
        ),),
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
      ),
    );
  }
}

class DrawerScreen extends StatefulWidget {
  final ValueSetter setIndex;
  const DrawerScreen({Key? key, required this.setIndex}) : super(key: key);

  @override
  State<DrawerScreen> createState() => _DrawerScreenState();
}

class _DrawerScreenState extends State<DrawerScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: LightColor.maincolor1,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          drawerList(Icons.home, "Home", 0),
          const SizedBox(
            height: 10,
          ),
          drawerList(Icons.message, "Messenger", 1),
          const SizedBox(
            height: 10,
          ),
          drawerList(Icons.group, "Groups", 2),
          const SizedBox(
            height: 10,
          ),
          drawerList(Icons.forum, "Forums", 3),
          const SizedBox(
            height: 10,
          ),
          drawerList(Icons.notification_add, "Notices", 4),
          const SizedBox(
            height: 10,
          ),
          drawerList(Icons.people_alt, " Gossip", 5),
          const SizedBox(
            height: 10,
          ),
          drawerList(Icons.speaker, "Clubs", 6),
          const SizedBox(
            height: 10,
          ),
          drawerList(Icons.school, "School Portal", 7),
          const SizedBox(
            height: 10,
          ),
          drawerList(Icons.tv, "Campus TV", 8),
          const SizedBox(
            height: 20,
          ),
          const Logout()
        ],
      ),
    );
  }

  Widget drawerList(IconData icon, String text, int index) {
    return GestureDetector(
      onTap: () {
        widget.setIndex(index);
      },
      child: Container(
        margin: const EdgeInsets.only(left: 20, bottom: 12),
        child: Row(
          children: [
            Icon(
              icon,
              color: Colors.white,
            ),
            const SizedBox(
              width: 12,
            ),
            Text(
              text,
              style: const TextStyle(
                  color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}

class DrawerWidget extends StatelessWidget {
  const DrawerWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        ZoomDrawer.of(context)!.toggle();
      },
      icon: const Icon(
        Icons.menu,
        color: LightColor.maincolor,
      ),
    );
  }
}

class Logout extends StatelessWidget {
  const Logout({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: GestureDetector(
        onTap: () async {
          await FirebaseAuth.instance.signOut();
        },
        child: const GlassBox(
            height: 40.0,
            width: 100.0,
            child: Center(
                child: Text(
              "Logout",
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
            ))),
      ),
    );
  }
}
