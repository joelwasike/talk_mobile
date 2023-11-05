import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/components/shimmer/gf_shimmer.dart';
import 'package:usersms/resources/apiconstatnts.dart';
import 'package:usersms/utils/colors.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../resources/searchpostpage.dart';
import '../widgets/followerspeople.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController searchController = TextEditingController();
  bool isShowUsers = false;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 40,
          backgroundColor: LightColor.scaffold,
          automaticallyImplyLeading: false,
          title: const TabBar(
            unselectedLabelStyle: TextStyle(fontSize: 15),
            indicatorPadding: EdgeInsets.only(bottom: 10),
            labelColor: LightColor.background,
            indicatorColor: LightColor.maincolor,
            dividerColor: LightColor.scaffold,
            tabs: [
              Tab(text: 'Photos'),
              Tab(text: 'Friends'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            PinterestGrid(),
            FriendsTab(), // Create the FriendsTab widget
          ],
        ),
      ),
    );
  }
}

class PinterestGrid extends StatefulWidget {
  const PinterestGrid({Key? key}) : super(key: key);

  @override
  State<PinterestGrid> createState() => _PinterestGridState();
}

class _PinterestGridState extends State<PinterestGrid> {
  List<Map<String, dynamic>> data = [];
  bool isloading = false;
  String? content;
  String? email;
  int? id;
  int? likes;
  String? media;
  String? pdf;
  String? title;
  final TextEditingController searchController =
      TextEditingController(); // Add this line

  //fetchdata
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

  //search endpoint
  Future<void> search(String query) async {
    if (query.isEmpty) {
      //clearGrid(); // Clear the grid when the search query is empty
      return;
    }

    try {
      setState(() {
        isloading = true;
      });

      final url = Uri.parse(
          '$baseUrl/search'); // Modify the URL to your search endpoint
      final response = await http.post(
        url,
        body: jsonEncode({
          'searchstring': query
        }), // Send the query as JSON in the request body
        headers: {
          'Content-Type': 'application/json'
        }, // Specify the content type
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);

        setState(() {
          data = jsonData.cast<Map<String, dynamic>>();
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

  // Function to clear the grid
  void clearGrid() {
    setState(() {
      data.clear();
    });
  }

  @override
  void initState() {
    super.initState();
    fetchData();
    searchController.addListener(() {
      search(searchController.text);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
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
                hintText: "Search friends...",
                hintStyle: TextStyle(color: Colors.grey.shade600),
                prefixIcon: Icon(
                  Icons.search,
                  color: Colors.grey.shade600,
                  size: 20,
                ),
                filled: true,
                fillColor: LightColor.scaffold,
                contentPadding: const EdgeInsets.all(8),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 2),
            child: Container(
              child: StaggeredGrid.count(
                mainAxisSpacing: 2.0,
                crossAxisSpacing: 2.0,
                crossAxisCount: 3,
                children: List.generate(
                  data.length,
                  (index) => StaggeredGridTile.fit(
                    crossAxisCellCount: 1,
                    child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  SearchPostPage(postId: data[index]["id"]),
                            ),
                          );
                        },
                        child: ImageCard(imageData: data[index]["media"])),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ImageCard extends StatelessWidget {
  const ImageCard({Key? key, required this.imageData}) : super(key: key);

  final String imageData;

  Future<String> generateVideoThumbnail(String videoUrl) async {
    final thumbnailPath = await VideoThumbnail.thumbnailFile(
      video: videoUrl,
      quality: 75, // Adjust the quality (0 - 100)
      maxHeight: 128, // Maximum height of the thumbnail
    );

    return thumbnailPath!;
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
  Widget build(BuildContext context) {
    bool isVideo = isVideoLink(imageData);
    return ClipRRect(
      borderRadius: BorderRadius.circular(6.0),
      child: isVideo
          ? FutureBuilder<String>(
              future: generateVideoThumbnail(imageData),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return Stack(
                    alignment: Alignment.center,
                    children: [
                      Image.file(
                        File(snapshot.data!),
                        fit: BoxFit.cover,
                      ),
                      Center(
                        child: Icon(
                          Icons.play_arrow,
                          size: 48,
                          color: Colors.white.withOpacity(0.8),
                        ),
                      ),
                    ],
                  );
                } else {
                  return Container(); // Show a loading indicator
                }
              },
            )
          : CachedNetworkImage(
              imageUrl: imageData, fit: BoxFit.cover,

              placeholder: (context, url) => GFShimmer(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height / 4,
                      color: Colors.grey.shade800.withOpacity(0.4),
                    ),
                  ],
                ),
              ),
              // Placeholder while loading
            ),
      // Image.network(imageData.imageUrl, fit: BoxFit.cover),
    );
  }
}

class FriendsTab extends StatefulWidget {
  const FriendsTab({Key? key}) : super(key: key);

  @override
  State<FriendsTab> createState() => _FriendsTabState();
}

class _FriendsTabState extends State<FriendsTab> {
  List<Map<String, dynamic>> data = [];
  bool isloading = false;
  String? campus = "";
  String? email = "";
  int? id = 0;
  String? media = "";
  String? username = "";
  final TextEditingController searchController =
      TextEditingController(); // Add this line

  //fetchdata
  Future<void> fetchData() async {
    try {
      setState(() {
        isloading = true;
      });
      final url = Uri.parse('$baseUrl/getusers'); // Replace with your JSON URL
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);

        setState(() {
          data = jsonData.cast<Map<String, dynamic>>();
        });

        // Now you can access the data as needed.
        for (final item in data) {
          campus = item['campus'];
          email = item['email'];
          id = item['ID'];
          media = item['profile_picture'];
          username = item['username'];
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

  //search endpoint
  Future<void> search(String query) async {
    if (query.isEmpty) {
      // clearGrid(); // Clear the grid when the search query is empty
      return;
    }

    try {
      setState(() {
        isloading = true;
      });

      final url = Uri.parse(
          '$baseUrl/searchusers'); // Modify the URL to your search endpoint
      final response = await http.post(
        url,
        body: jsonEncode({
          'searchstring': query
        }), // Send the query as JSON in the request body
        headers: {
          'Content-Type': 'application/json'
        }, // Specify the content type
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);

        setState(() {
          data = jsonData.cast<Map<String, dynamic>>();
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

  // Function to clear the grid
  void clearGrid() {
    setState(() {
      data.clear();
    });
  }

  @override
  void initState() {
    super.initState();
    fetchData();
    searchController.addListener(() {
      search(searchController.text);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
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
              hintText: "Search friends...",
              hintStyle: TextStyle(color: Colors.grey.shade600),
              prefixIcon: Icon(
                Icons.search,
                color: Colors.grey.shade600,
                size: 20,
              ),
              filled: true,
              fillColor: LightColor.scaffold,
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
              return GestureDetector(
                onTap: () {
                  // Navigator.push(
                  //   (context),
                  //   MaterialPageRoute(builder: (context) =>  ChatPagee(name: people[index])

                  //       ),
                  // );
                },
                child: PeopleFCard(
                  id: data[index]["ID"],
                  email: data[index]["email"],
                  name: data[index]["username"],
                  image: data[index]["profile_picture"],
                  school: data[index]["campus"],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
