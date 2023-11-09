import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:usersms/resources/apiconstatnts.dart';
import 'package:usersms/resources/forum_posts.dart';
import 'package:usersms/resources/forumcred.dart';
import 'package:usersms/resources/isloadong.dart';
import 'package:usersms/screens/homepage.dart';
import 'package:usersms/utils/colors.dart';
import 'package:usersms/widgets/forum_card.dart';

class Forums extends StatefulWidget {
  const Forums({super.key});

  @override
  State<Forums> createState() => _ForumsState();
}

class _ForumsState extends State<Forums> {
  List<Map<String, dynamic>> data = [];
  List<Map<String, dynamic>> filteredData = []; // Store filtered data
  bool isloading = false;

  Future<void> fetchData() async {
    setState(() {
      isloading = true;
    });
    final url = Uri.parse('$baseUrl/getforums');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(response.body);

      setState(() {
        data = jsonData.cast<Map<String, dynamic>>();
        // Initialize filteredData with all data initially
        filteredData = List.from(data);
      });
      setState(() {
        isloading = false;
      });
    } else {
      throw Exception('Failed to load data');
    }
  }

  // Method to filter data based on search query
  void filterData(String query) {
    setState(() {
      filteredData = data
          .where((item) =>
              item['title'].toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        fetchData();
      },
      child: Scaffold(
        appBar: AppBar(
          leading: DrawerWidget(),
          toolbarHeight: 30,
          backgroundColor: LightColor.scaffold,
          title: Padding(
            padding: const EdgeInsets.only(left: 56),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Spacer(),
                FadeInRight(
                  child: Text(
                    'Campus Forums',
                    style: GoogleFonts.aguafinaScript(
                      textStyle: const TextStyle(
                        color: Colors.white,
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
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.transparent,
          mini: false,
          shape: const CircleBorder(),
          onPressed: () {
            Navigator.push(
              (context),
              MaterialPageRoute(builder: (context) => ForumCred()),
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
              child: Icon(Icons.add_box, color: LightColor.maincolor),
            ),
          ),
        ),
        body: isloading
            ? Isloading()
            : RefreshIndicator(
                onRefresh: () async {
                  fetchData();
                },
                backgroundColor: LightColor.scaffold,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 2, left: 6, right: 2),
                      child: TextField(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: Colors.grey.shade600),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(6),
                            borderSide: BorderSide(color: Colors.grey.shade600),
                          ),
                          hintText: "Search forums...",
                          hintStyle: TextStyle(color: Colors.grey.shade600),
                          prefixIcon: Icon(
                            Icons.search,
                            color: Colors.grey.shade600,
                            size: 20,
                          ),
                          filled: true,
                          fillColor: LightColor.maincolor1,
                          contentPadding: const EdgeInsets.all(8),
                        ),
                        // Add onChanged event to update the filtered data
                        onChanged: (query) {
                          filterData(query);
                        },
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Expanded(
                      child: ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        itemCount: filteredData.length, // Use filtered data
                        itemBuilder: (context, index) {
                          final club = filteredData[index];
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                (context),
                                MaterialPageRoute(
                                  builder: (context) => ForumPosts(
                                    title: club['title'],
                                    clubid: club["id"],
                                  ),
                                ),
                              );
                            },
                            child: FadeInRight(
                              child: ForumCard(
                                name: club['title'],
                                image: club['photo'],
                                description: club['description'],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
