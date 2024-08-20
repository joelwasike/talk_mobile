import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:usersms/cubit/fetchdatacubit.dart';
import 'package:usersms/cubit/fetchdatastate.dart';
import 'package:usersms/resources/addgossip.dart';
import 'package:usersms/resources/postsloading.dart';
import 'package:usersms/resources/video_user_post.dart';
import 'package:visibility_detector/visibility_detector.dart';
import '../resources/photo_user_posts.dart';
import '../screens/homepage.dart';
import '../utils/colors.dart';

class Gossip extends StatefulWidget {
  const Gossip({super.key});

  @override
  State<Gossip> createState() => _GossipState();
}

class _GossipState extends State<Gossip> {
  final ScrollController _scrollController = ScrollController();

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
    context.read<Fetchdatacubit>().fetchgossips();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        controller: _scrollController,
        physics: BouncingScrollPhysics(),
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
                      'Campus Trendings',
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
                var posts = box.get("gossips");
                if (posts != null && posts.isNotEmpty) {
                  return buildSliverPostList(posts);
                } else {
                  return SliverToBoxAdapter(child: Postsloading());
                }
              } else if (state is Getdataloaded) {
                return buildSliverPostList(state.data);
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
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.transparent,
        mini: false,
        shape: const CircleBorder(),
        onPressed: () {
          Navigator.push(
            (context),
            MaterialPageRoute(builder: (context) => const AddGossip()),
          );
        },
        child: Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: LightColor.maincolor,
            ),
          ),
          child: Center(
            child: Icon(
              Icons.add_box,
              color: LightColor.maincolor,
            ),
          ),
        ),
      ),
    );
  }

  Widget buildSliverPostList(List posts) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int index) {
          final item = posts[index];
          return LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              if (isVideoLink(item["media"])) {
                return VisibilityDetector(
                  key: Key(item['id'].toString()),
                  onVisibilityChanged: (visibilityInfo) {
                    double visiblePercentage =
                        visibilityInfo.visibleFraction * 100;
                    bool isMoreThanHalfVisible = visiblePercentage > 50;
                    if (mounted) {
                      setState(() {
                        item['isVisible'] = isMoreThanHalfVisible;
                      });
                    }
                  },
                  child: VUserPost(
                    scrollController: _scrollController,
                    profilepic: item['profilepic'],
                    addlikelink: "postlikes",
                    minuslikelink: "postlikesminus",
                    id: item["id"],
                    play: item['isVisible'] ?? false,
                    name: item['title'],
                    url: item['media'],
                    content: item['content'],
                    likes: item['likes'],
                    getcommenturl: 'getgossipcomments',
                    postcommenturl: 'gossipcomments',
                  ),
                );
              } else {
                return UserPost(
                  scrollController: _scrollController,
                  profilepic: item['profilepic'],
                  addlikelink: "gossiplikes",
                  minuslikelink: "minusgossiplikes",
                  id: item["id"],
                  name: item['title'],
                  image: item['media'],
                  content: item['content'],
                  likes: item['likes'],
                  getcommenturl: 'getgossipcomments',
                  postcommenturl: 'gossipcomments',
                );
              }
            },
          );
        },
        childCount: posts.length,
      ),
    );
  }
}
