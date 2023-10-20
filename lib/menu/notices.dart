import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/components/shimmer/gf_shimmer.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:usersms/resources/addnotice.dart';
import 'package:usersms/resources/apiconstatnts.dart';
import 'package:usersms/resources/notice_post.dart';
import '../screens/homepage.dart';
import '../utils/colors.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class Notices extends StatefulWidget {
  const Notices({super.key});

  @override
  State<Notices> createState() => _NoticesState();
}

class _NoticesState extends State<Notices> {
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
    try {
      final url =
          Uri.parse('$baseUrl/getnotices'); // Replace with your JSON URL
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
          pdf = item['pdf'];
          title = item['title'];
        }
      } else {
        print('Failed to load data');
      }
    } catch (e) {
      print(e);
    } finally {
      setState(() {
        isloading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isloading
          ? ListView.builder(
              itemCount: 10,
              itemBuilder: (context, index) {
                return GFShimmer(
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
                );
              })
          : CustomScrollView(
              slivers: <Widget>[
                SliverAppBar(
                  leading: FadeInLeft(child: const DrawerWidget()),
                  backgroundColor: LightColor.scaffold,
                  floating: true,
                  pinned: false,
                  flexibleSpace: FlexibleSpaceBar(
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        FadeInRight(
                            child: Text('Campus Notice',
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
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    
                    (BuildContext context, int index) {
                      final item = data[index];
                      return FadeInRight(
                        child: NoticePost(
                          file: item['pdf'],
                          name: item['title'],
                          image: item['media'],
                          content: item['content'],
                          likes: item['likes'],
                        ),
                      );
                    },
                    childCount: data.length,
                  ),
                ),
              ],
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
            MaterialPageRoute(builder: (context) => const Addnotice()),
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
    );
  }
}
