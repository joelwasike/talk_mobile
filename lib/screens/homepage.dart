import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:usersms/cubit/fetchdatacubit.dart';
import 'package:usersms/cubit/fetchdatastate.dart';
import 'package:usersms/match/match.dart';
import 'package:usersms/menu/clubs.dart';
import 'package:usersms/menu/forums.dart';
import 'package:usersms/menu/gossip.dart';
import 'package:usersms/menu/groups.dart';
import 'package:usersms/menu/messenger.dart';
import 'package:usersms/menu/notices.dart';
import 'package:usersms/menu/portal.dart';
import 'package:usersms/resources/apiconstatnts.dart';
import 'package:usersms/resources/photo_user_posts.dart';
import 'package:usersms/resources/postsloading.dart';
import 'package:usersms/resources/video_user_post.dart';
import 'package:usersms/utils/colors.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:visibility_detector/visibility_detector.dart';

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
      case 1:
        return const Messenger();
      case 2:
        return const Groups();
      case 3:
        return Forums();
      case 4:
        return const Notices();
      case 5:
        return const Gossip();
      case 6:
        return const Clubs();
      case 7:
        return Match();
      case 8:
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
  // List<Map<String, dynamic>> data = [];
  bool isloading = false;

  //get posts
  // Future<void> fetchData() async {
  //   try {
  //     setState(() {
  //       // isloading = true;
  //     });
  //     final url = Uri.parse('$baseUrl/getposts'); // Replace with your JSON URL
  //     final response = await http.get(url);

  //     if (response.statusCode == 200) {
  //       final List<dynamic> jsonData = json.decode(response.body);

  //       setState(() {
  //         data = jsonData.cast<Map<String, dynamic>>();
  //       });
  //     } else {
  //       throw Exception('Failed to load data');
  //     }
  //   } catch (e) {
  //     print(e);
  //   } finally {
  //     if (mounted) {
  //       setState(() {
  //         isloading = false;
  //       });
  //     }
  //   }
  // }

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
    context.read<Fetchdatacubit>().fetchdata();
    profiledetails();
  }

  @override
  void dispose() {
    _scrollController.dispose(); // Dispose the scroll controller
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        controller: _scrollController,
        slivers: <Widget>[
          SliverAppBar(
            floating: true,
            snap: true,
            toolbarHeight: 40,
            leading: FadeInLeft(child: const DrawerWidget()),
            backgroundColor: Colors.black,
            flexibleSpace: FlexibleSpaceBar(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  FadeInRight(
                    child: Text(
                      'Kibabii Campus Talk',
                      style: GoogleFonts.aguafinaScript(
                        textStyle: TextStyle(
                          color: Colors.grey.shade300,
                          fontSize: 22,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          BlocBuilder<Fetchdatacubit, Getdatastate>(
            builder: (context, state) {
              if (state is Getdataloading || state is Getdatainitial) {
                var box = Hive.box("Talk");
                var posts = box.get("posts");
                if (posts != null && posts.isNotEmpty) {
                  return SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (BuildContext context, int index) {
                        final item = posts[index];
                        return buildPostItem(item);
                      },
                      childCount: posts.length,
                    ),
                  );
                } else {
                  return SliverToBoxAdapter(child: Postsloading());
                }
              } else if (state is Getdataloaded) {
                return SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (BuildContext context, int index) {
                      final item = state.data[index];
                      return buildPostItem(item);
                    },
                    childCount: state.data.length,
                  ),
                );
              } else {
                return SliverToBoxAdapter(
                  child: Center(
                    child: Text("Please check your internet"),
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }

  Widget buildPostItem(Map<dynamic, dynamic> item) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        if (isVideoLink(item["media"])) {
          return VisibilityDetector(
            key: Key(item['id'].toString()),
            onVisibilityChanged: (visibilityInfo) {
              bool isVisible = visibilityInfo.visibleFraction > 0.5;
              if (mounted) {
                setState(() {
                  item['isVisible'] = isVisible;
                });
              }
            },
            child: VUserPost(
              scrollController: _scrollController,
              profilepic: item['profilepicture'],
              addlikelink: "postlikes",
              minuslikelink: "postlikesminus",
              id: item['id'],
              play: item['isVisible'] ?? false,
              name: item['username'],
              url: item['media'],
              content: item['content'],
              likes: item['likes'],
              getcommenturl: 'getpostcomments',
              postcommenturl: 'comments',
            ),
          );
        } else {
          return UserPost(
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
        }
      },
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
            drawerList(FontAwesomeIcons.house, "Home", 0,
                Colors.green.withOpacity(.4)),
            const SizedBox(
              height: 10,
            ),
            drawerList(FontAwesomeIcons.comment, "Messenger", 1,
                Colors.blue.withOpacity(.4)),
            const SizedBox(
              height: 10,
            ),
            drawerList(FontAwesomeIcons.comments, "Groups", 2,
                Colors.red.withOpacity(.4)),
            const SizedBox(
              height: 10,
            ),
            // drawerList(FontAwesomeIcons.users, "Forums", 3,
            //     Colors.green.withOpacity(.4)),
            // const SizedBox(
            //   height: 10,
            // ),
            drawerList(FontAwesomeIcons.bell, "Notices", 4,
                Colors.yellow.withOpacity(.4)),
            const SizedBox(
              height: 10,
            ),
            drawerList(FontAwesomeIcons.volumeHigh, " Trendings", 5,
                Colors.blue.withOpacity(.4)),
            const SizedBox(
              height: 10,
            ),
            drawerList(
                FontAwesomeIcons.play, "Clubs", 6, Colors.red.withOpacity(.4)),
            const SizedBox(
              height: 10,
            ),
            drawerList(FontAwesomeIcons.graduationCap, "Portal", 8,
                Colors.blue.withOpacity(.4)),
            // drawerList(
            //     FontAwesomeIcons.heart, "Match", 7, Colors.red.withOpacity(.4)),
            const SizedBox(
              height: 20,
            ),
            const Logout()
          ],
        ),
      ),
    );
  }

  Widget drawerList(IconData icon, String text, int index, Color color) {
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
              color: color,
              size: 20,
            ),
            const SizedBox(
              width: 12,
            ),
            Text(
              text,
              style: const TextStyle(
                  color: Colors.white, fontWeight: FontWeight.normal),
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
        onTap: () async {},
        child: Container(
            decoration: BoxDecoration(
                color: Colors.blue.withOpacity(.4),
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
