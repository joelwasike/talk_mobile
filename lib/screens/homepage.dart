import 'package:animate_do/animate_do.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:getwidget/components/shimmer/gf_shimmer.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:inview_notifier_list/inview_notifier_list.dart';
import 'package:usersms/menu/clubs.dart';
import 'package:usersms/menu/forums.dart';
import 'package:usersms/menu/gossip.dart';
import 'package:usersms/menu/groups.dart';
import 'package:usersms/menu/messenger.dart';
import 'package:usersms/menu/notices.dart';
import 'package:usersms/menu/portal.dart';
import 'package:usersms/resources/apiconstatnts.dart';
import 'package:usersms/resources/photo_user_posts.dart';
import 'package:usersms/resources/video_user_post.dart';
import '../utils/colors.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

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
      angle: 0.0,
      slideWidth: 200,
      menuBackgroundColor: LightColor.scaffold,
    );
  }

  Widget currentScreen() {
    switch (currentIndex) {
      case 0:
        return const HomeScreen();
      //case 1:
      // return const Messenger();
      // case 2:
      // return const Groups();
      case 1:
        return Forums();
      case 2:
        return const Notices();
      case 3:
        return const Gossip();
      case 4:
        return const Clubs();
      case 5:
        return const Portal();

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
  final ScrollController _scrollController =
      ScrollController(); // Add this line
  List<Map<String, dynamic>> data = [];
  bool isloading = false;
  String? content;
  String? email;
  int? id;
  int? likes;
  String? media;
  String? pdf;
  String? title;

  //get posts
  Future<void> fetchData() async {
    try {
      setState(() {
        // isloading = true;
      });
      final url = Uri.parse('$baseUrl/getposts'); // Replace with your JSON URL
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);

        setState(() {
          data = jsonData.cast<Map<String, dynamic>>();
        });

        // Now you can access the data as needed.
        for (final item in data) {
          content = item['content'];
          email = item['email'];
          id = item['id'];
          likes = item['likes'];
          media = item['media'];
          title = item['username'];
        }
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      print(e);
    } finally {
      setState(() {
        //isloading = false;
      });
    }
  }

  Future<void> profiledetails() async {
    var box = Hive.box("Talk");
    var email = box.get("id");
    Map body = {"userid": email};
    final url = Uri.parse('$baseUrl/showprofiledetails');
    final response = await http.post(url, body: jsonEncode(body));
    print(response.body);

    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body);
      var box = Hive.box("Talk");
      box.put("followerscount", jsonData["followerscount"]);
      box.put("followingscount", jsonData["followingscount"]);
      box.put("postscount", jsonData["postscount"]);
    } else {
      print('HTTP Request Error: ${response.statusCode}');
    }
  }

  bool isVideoLink(String link) {
    final videoExtensions = ['.mp4', '.avi', '.mkv', '.mov', '.wmv'];
    for (final extension in videoExtensions) {
      if (link.toLowerCase().endsWith(extension)) {
        return true;
      }
    }
    return false;
  }

  @override
  void initState() {
    super.initState();
    fetchData().then((_) => profiledetails());
  }

  @override
  void dispose() {
    _scrollController.dispose(); // Dispose the scroll controller
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 40,
        leading: FadeInLeft(child: const DrawerWidget()),
        backgroundColor: Colors.black,
        flexibleSpace: FlexibleSpaceBar(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              FadeInRight(
                  child: Text('Kibabii Campus Talk',
                      style: GoogleFonts.aguafinaScript(
                        textStyle: TextStyle(
                          color: Colors.grey.shade300,
                          fontSize: 22,
                          fontWeight: FontWeight.w900,
                        ),
                      ))),
            ],
          ),
        ),
      ),
      body: isloading
          ? ListView.builder(
              itemCount: data.length,
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    GFShimmer(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width,
                            height: 300,
                            color: Colors.grey.shade800.withOpacity(0.4),
                          ),
                          const SizedBox(height: 12),
                          Container(
                            width: double.infinity,
                            height: 8,
                            color: Colors.grey.shade800.withOpacity(0.4),
                          ),
                          const SizedBox(height: 6),
                          Container(
                            width: MediaQuery.of(context).size.width * 0.5,
                            height: 8,
                            color: Colors.grey.shade800.withOpacity(0.4),
                          ),
                          const SizedBox(height: 6),
                          Container(
                            width: MediaQuery.of(context).size.width * 0.25,
                            height: 8,
                            color: Colors.grey.shade800.withOpacity(0.4),
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    )
                  ],
                );
              },
            )
          : RefreshIndicator(
              onRefresh: () async {
                fetchData();
              },
              backgroundColor: LightColor.scaffold,
              color: LightColor.maincolor,
              child: InViewNotifierList(
                physics: BouncingScrollPhysics(),
                scrollDirection: Axis.vertical,
                initialInViewIds: const ['0'],
                isInViewPortCondition: (double deltaTop, double deltaBottom,
                    double viewPortDimension) {
                  return deltaTop < (0.5 * viewPortDimension) &&
                      deltaBottom > (0.5 * viewPortDimension);
                },
                itemCount: data.length,
                builder: (BuildContext context, int index) {
                  return LayoutBuilder(
                    builder:
                        (BuildContext context, BoxConstraints constraints) {
                      return InViewNotifierWidget(
                        id: '$index',
                        builder: (BuildContext context, bool isInView,
                            Widget? child) {
                          final item = data[index];
                          return isVideoLink(item["media"])
                              ? VUserPost(
                                  scrollController: _scrollController,
                                  profilepic: item['profilepicture'],
                                  addlikelink: "postlikes",
                                  minuslikelink: "postlikesminus",
                                  id: item['id'],
                                  play: isInView,
                                  name: item['username'],
                                  url: item['media'],
                                  content: item['content'],
                                  likes: item['likes'],
                                  getcommenturl: 'getpostcomments',
                                  postcommenturl: 'comments',
                                )
                              : UserPost(
                                  profilepic: item['profilepicture'],
                                  addlikelink: "postlikes",
                                  minuslikelink: "postlikesminus",
                                  scrollController: _scrollController,
                                  id: item["id"],
                                  name: item['username'],
                                  image: item['media'],
                                  content: item['content'],
                                  likes: item['likes'],
                                  getcommenturl: 'getpostcomments',
                                  postcommenturl: 'comments',
                                );
                        },
                      );
                    },
                  );
                },
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
      backgroundColor: LightColor.scaffold,
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: MediaQuery.of(context).size.height / 5,
              child: DrawerHeader(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width / 3,
                      height: 70,
                      padding: EdgeInsets.only(
                        bottom: 30,
                      ),
                      child: DecoratedBox(
                        decoration: ShapeDecoration(
                            shape: CircleBorder(),
                            image: DecorationImage(
                              fit: BoxFit.contain,
                              image: AssetImage(
                                  "assets/talklogo.v1.cropped-modified.png"),
                            )),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            drawerList(Icons.home, "Home", 0),
            const SizedBox(
              height: 10,
            ),
            // drawerList(Icons.message, "Messenger", 1),
            // const SizedBox(
            //   height: 10,
            // ),
            // drawerList(Icons.group, "Groups", 2),
            // const SizedBox(
            //   height: 10,
            // ),
            drawerList(Icons.forum, "Forums", 1),
            const SizedBox(
              height: 10,
            ),
            drawerList(Icons.notification_add, "Notices", 2),
            const SizedBox(
              height: 10,
            ),
            drawerList(Icons.people_alt, " Gossip", 3),
            const SizedBox(
              height: 10,
            ),
            drawerList(Icons.speaker, "Clubs", 4),
            const SizedBox(
              height: 10,
            ),
            drawerList(Icons.school, "School Portal", 5),
            const SizedBox(
              height: 10,
            ),
            const Logout()
          ],
        ),
      ),
    );
  }

  Widget drawerList(IconData icon, String text, int index) {
    return GestureDetector(
      onTap: () {
        widget.setIndex(index);
      },
      child: Container(
        height: 35,
        width: MediaQuery.of(context).size.height,
        margin: const EdgeInsets.only(left: 20, bottom: 0),
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
        Icons.sort_outlined,
        color: LightColor.background,
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
        child: Container(
            decoration: BoxDecoration(
                color: LightColor.maincolor,
                borderRadius: BorderRadius.circular(6)),
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
