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
  final ScrollController _scrollController = ScrollController();
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
      final url = Uri.parse('$baseUrl/getposts');
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

        // Manipulate the data list to ensure the chosen post is at index 0
        data.insert(
            0,
            data.removeAt(
                data.indexWhere((item) => item["id"] == widget.postId)));
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
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isloading
          ? ListView.builder(
              itemCount: data.length,
              itemBuilder: (context, index) {
                final item = data[index];
                return Column(
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    GFShimmer(
                      child: Column(
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
              initialInViewIds: const ['0'],
              isInViewPortCondition: (double deltaTop, double deltaBottom,
                  double viewPortDimension) {
                return deltaTop < (0.5 * viewPortDimension) &&
                    deltaBottom > (0.5 * viewPortDimension);
              },
              itemCount: data.length,
              builder: (BuildContext context, int index) {
                return LayoutBuilder(
                  builder: (BuildContext context, BoxConstraints constraints) {
                    return InViewNotifierWidget(
                      id: '$index',
                      builder:
                          (BuildContext context, bool isInView, Widget? child) {
                        final item = data[index];
                        return isVideoLink(item["media"])
                            ? VUserPost(
                                profilepic: item['profilepicture'],
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
    );
  }
}
