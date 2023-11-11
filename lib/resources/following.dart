import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:usersms/resources/apiconstatnts.dart';
import '../utils/colors.dart';
import '../widgets/followerspeople.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class Following extends StatefulWidget {
  final int id;
  const Following({Key? key, required this.id});

  @override
  State<Following> createState() => _FollowingState();
}

class _FollowingState extends State<Following> {
  List people = [
    "Joel",
    "Davis",
    "Peris",
    "Delan",
    "Wiky",
    "Felo",
    "Bena",
    "Chalo"
  ];

  List<Map<String, dynamic>> data = [];
  bool isloading = false;
  String? content;
  String? email;
  int? id;
  int? idd;
  int? likes;
  String? media;
  String? pdf;
  String? title;
  final TextEditingController searchController = TextEditingController();
  List<Map<String, dynamic>> originalData = [];
  List<Map<String, dynamic>> filteredData = [];

  Future<void> fetchusers() async {
    try {
      setState(() {
        isloading = true;
      });
      final url = Uri.parse('$baseUrl/getfollowings/${widget.id}');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);

        setState(() {
          data = jsonData.cast<Map<String, dynamic>>();
          originalData = data;
        });
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

  // Search
  void search(String query) {
    if (query.isEmpty) {
      setState(() {
        data = List.from(originalData);
      });
      return;
    }

    // Filter the original data based on the search query
    final filteredData = originalData.where((item) {
      final username = item['username'].toString().toLowerCase();
      return username.contains(query.toLowerCase());
    }).toList();

    setState(() {
      data = filteredData;
    });
  }

  fetchdata() {
    var box = Hive.box("Talk");
    setState(() {
      idd = box.get("id");
    });
  }

  @override
  void initState() {
    super.initState();
    fetchdata();
    fetchusers();
    searchController.addListener(() {
      search(searchController.text);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 30,
        iconTheme: const IconThemeData(color: LightColor.background),
        automaticallyImplyLeading: true,
        backgroundColor: LightColor.scaffold,
        title: Padding(
          padding: const EdgeInsets.only(left: 56),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              FadeInRight(
                child: Text(
                  'Friends you follow',
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
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 2, left: 6, right: 2),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.grey.shade600),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(6),
                  borderSide: BorderSide(color: Colors.grey.shade600),
                ),
                hintText: "Search users...",
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
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Expanded(
            child: ListView.builder(
              physics: const BouncingScrollPhysics(),
              itemCount: data.length,
              itemBuilder: (context, index) {
                return PeopleFCard(
                  isfollowing: true,
                  id: data[index]["ID"],
                  email: data[index]["email"],
                  name: data[index]["username"],
                  image: data[index]["profile_picture"],
                  school: data[index]["campus"],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
