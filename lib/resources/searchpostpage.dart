import 'dart:convert';
import 'package:animate_do/animate_do.dart';
import 'package:getwidget/components/shimmer/gf_shimmer.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:inview_notifier_list/inview_notifier_list.dart';
import 'package:usersms/resources/apiconstatnts.dart';
import 'package:usersms/resources/photo_user_posts.dart';
import 'package:usersms/resources/video_user_post.dart';
import 'package:usersms/screens/homepage.dart';

class SearchPostPage extends StatefulWidget {
  final int postId;

  const SearchPostPage({required this.postId, Key? key}) : super(key: key);

  @override
  State<SearchPostPage> createState() => _SearchPostPageState();
}

class _SearchPostPageState extends State<SearchPostPage> {
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
        isloading = true;
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
        isloading = false;
      });
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
            : InViewNotifierList(
                scrollDirection: Axis.vertical,
                initialInViewIds: ["${widget.postId}"],
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
                        id: '${data[index]["id"]}',
                        builder: (BuildContext context, bool isInView,
                            Widget? child) {
                          final item = data[index];
                          if (item["id"] == widget.postId) {
                            // Display the item whose ID matches widget.postId as the first item
                            return isVideoLink(item["media"])
                                ? VUserPost(
                                    scrollController: _scrollController,
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
                                    scrollController: _scrollController,
                                    addlikelink: "postlikes",
                                    minuslikelink: "postlikesminus",
                                    id: item["id"],
                                    name: item['username'],
                                    image: item['media'],
                                    content: item['content'],
                                    likes: item['likes'],
                                    getcommenturl: 'getpostcomments',
                                    postcommenturl: 'comments',
                                  );
                          } else {
                            // Display other media items
                            return isVideoLink(item["media"])
                                ? VUserPost(
                                    scrollController: _scrollController,
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
                                    scrollController: _scrollController,
                                    addlikelink: "postlikes",
                                    minuslikelink: "postlikesminus",
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
                    },
                  );
                },
              ));
  }
}
