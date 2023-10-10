import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/components/shimmer/gf_shimmer.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:inview_notifier_list/inview_notifier_list.dart';
import 'package:usersms/resources/addgossip.dart';
import 'package:usersms/resources/apiconstatnts.dart';
import 'package:usersms/resources/video_user_post.dart';
import '../resources/photo_user_posts.dart';
import '../screens/homepage.dart';
import '../utils/colors.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class Gossip extends StatefulWidget {
  const Gossip({super.key});

  @override
  State<Gossip> createState() => _GossipState();
}

class _GossipState extends State<Gossip> {
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

  //get notices
  Future<void> fetchData() async {
    setState(() {
      isloading = true;
    });
    final url = Uri.parse('$baseUrl/getgossips'); // Replace with your JSON URL
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
        title = item['title'];

        setState(() {
          isloading = false;
        });
      }
    } else {
      throw Exception('Failed to load data');
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
                  child: Text('Campus Gossip',
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
                    SizedBox(height: 10,)
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
                                scrollController: _scrollController,
                                play: isInView,
                                name: item['title'],
                                url: item['media'],
                                content: item['content'],
                                likes: item['likes'],
                              )
                            : UserPost(
                                scrollController: _scrollController,
                                name: item['title'],
                                image: item['media'],
                                content: item['content'],
                                likes: item['likes'],
                              );
                      },
                    );
                  },
                );
              },
            ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SizedBox(
          height: 40,
          width: 40,
          child: FloatingActionButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AddGossip()),
              );
            },
            backgroundColor: Colors.grey.shade800,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(30.0)),
            ),
            child: Icon(
              Icons.add_alert,
              color: Colors.grey.shade300, // Adjust the color as needed
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
    );
  }
}
