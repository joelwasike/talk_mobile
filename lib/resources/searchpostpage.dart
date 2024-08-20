import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:usersms/resources/apiconstatnts.dart';
import 'package:usersms/resources/photo_user_posts.dart';
import 'package:usersms/resources/video_user_post.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:getwidget/components/shimmer/gf_shimmer.dart';

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

        // Ensure the chosen post is at index 0
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
      if (mounted) {
        setState(() {
          isloading = false;
        });
      }
    }
  }

  bool isVideoLink(String link) {
    final videoExtensions = ['.mp4', '.avi', '.mkv', '.mov', '.wmv'];
    return videoExtensions.any((ext) => link.toLowerCase().endsWith(ext));
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
              itemCount: 5,
              itemBuilder: (context, index) => _buildShimmer(),
            )
          : Padding(
              padding: const EdgeInsets.only(top: 8),
              child: CustomScrollView(
                controller: _scrollController,
                slivers: [
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (BuildContext context, int index) {
                        final item = data[index];
                        return index == 0
                            ? Hero(
                                tag: widget.postId,
                                child: _buildPostItem(item, isFirst: true),
                              )
                            : _buildPostItem(item);
                      },
                      childCount: data.length,
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildShimmer() {
    return Column(
      children: [
        SizedBox(height: 10),
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
        SizedBox(height: 10),
      ],
    );
  }

  Widget _buildPostItem(Map<String, dynamic> item, {bool isFirst = false}) {
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
              profilepic: item['profilepicture'],
              scrollController: _scrollController,
              addlikelink: "postlikes",
              minuslikelink: "postlikesminus",
              id: item['id'],
              play: isFirst || (item['isVisible'] ?? false),
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
