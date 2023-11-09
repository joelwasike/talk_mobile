import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/components/shimmer/gf_shimmer.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:inview_notifier_list/inview_notifier_list.dart';
import 'package:usersms/resources/addclubpost.dart';
import 'package:usersms/resources/apiconstatnts.dart';
import 'package:usersms/resources/video_user_post.dart';
import '../resources/photo_user_posts.dart';
import '../utils/colors.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class Clubpost extends StatefulWidget {
  final String title;
  final int clubid;
  const Clubpost({super.key, required this.title, required this.clubid});

  @override
  State<Clubpost> createState() => _ClubpostState();
}

class _ClubpostState extends State<Clubpost> {
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
  int? title;

  //get notices
  Future<void> fetchData() async {
    try {
      // setState(() {
      //   isloading = true;
      // });
      final url = Uri.parse(
          '$baseUrl/getclubposts/${widget.clubid}'); // Replace with your JSON URL
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
          title = item['userID'];
        }
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      print(e);
    } finally {
      // setState(() {
      //   isloading = false;
      // });
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
    fetchData();
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
        iconTheme: IconThemeData(color: LightColor.background),
        toolbarHeight: 40,
        backgroundColor: Colors.black,
        flexibleSpace: FlexibleSpaceBar(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              FadeInRight(
                  child: Text("${widget.title}",
                      style: GoogleFonts.aguafinaScript(
                        textStyle: TextStyle(
                          color: Colors.grey.shade300,
                          fontSize: 22,
                          fontWeight: FontWeight.w900,
                        ),
                      ))),
              SizedBox(
                width: 5,
              )
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor:
            Colors.transparent, // Set the background color to transparent
        mini: false,
        shape:
            const CircleBorder(), // Use CircleBorder to create a round button
        onPressed: () {
          Navigator.push(
            (context),
            MaterialPageRoute(
                builder: (context) => AddClubPost(
                      clubid: widget.clubid,
                    )),
          );
        },
        child: Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: LightColor.maincolor, // Specify the border color here
            ),
          ),
          child: Center(
              child: Icon(
            Icons.add_box,
            color: LightColor.maincolor,
          )),
        ),
      ),
      body: isloading
          ? ListView.builder(
              itemCount: 5,
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
                            color: Colors.grey.shade800.withOpacity(0.2),
                          ),
                          const SizedBox(height: 12),
                          Container(
                            width: double.infinity,
                            height: 8,
                            color: Colors.grey.shade800.withOpacity(0.2),
                          ),
                          const SizedBox(height: 6),
                          Container(
                            width: MediaQuery.of(context).size.width * 0.5,
                            height: 8,
                            color: Colors.grey.shade800.withOpacity(0.2),
                          ),
                          const SizedBox(height: 6),
                          Container(
                            width: MediaQuery.of(context).size.width * 0.25,
                            height: 8,
                            color: Colors.grey.shade800.withOpacity(0.2),
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
                              ? FadeInRight(
                                  child: VUserPost(
                                    profilepic: item["profilepic"],
                                    scrollController: _scrollController,
                                    addlikelink: "postlikes",
                                    minuslikelink: "postlikesminus",
                                    id: item["id"],
                                    play: isInView,
                                    name: 'Club',
                                    url: item['media'],
                                    content: item['content'],
                                    likes: item['likes'],
                                    getcommenturl: 'getclubcomments',
                                    postcommenturl: 'clubcomments',
                                  ),
                                )
                              : FadeInRight(
                                  child: UserPost(
                                    profilepic: item["profilepic"],
                                    scrollController: _scrollController,
                                    addlikelink: "clublikes",
                                    minuslikelink: "minusclublikes",
                                    id: item["id"],
                                    name: "thejoel",
                                    image: item['media'],
                                    content: item['content'],
                                    likes: item['likes'],
                                    getcommenturl: 'getclubcomments',
                                    postcommenturl: 'clubcomments',
                                  ),
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
