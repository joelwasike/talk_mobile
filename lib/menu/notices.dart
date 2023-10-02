import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:usersms/resources/addnotice.dart';
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
    final url = Uri.parse(
        'https://5335-197-232-22-252.ngrok-free.app/getnotices'); // Replace with your JSON URL
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

        setState(() {
          isloading = false;
        });
      }
    } else {
      throw Exception('Failed to load data');
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
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            leading:    FadeInLeft(child: const DrawerWidget()),
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
                            textStyle: const TextStyle(
                              color: Colors.white,
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
                return NoticePost(
                  name: item['title'],
                  image: item['media'],
                  content: item['content'],
                  likes: item['likes'],
                );
              },
              childCount: data.length,
            ),
          ),
        ],
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
                MaterialPageRoute(builder: (context) => const Addnotice()),
              );
            },
            backgroundColor: Colors.grey.shade800,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(30.0)),
            ),
            child: const Icon(
              Icons.add_alert,
              color: Colors.white, // Adjust the color as needed
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
    );
  }
}
