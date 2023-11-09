import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:getwidget/components/shimmer/gf_shimmer.dart';
import 'package:image_picker/image_picker.dart';
import 'package:usersms/resources/apiconstatnts.dart';
import 'package:usersms/resources/followers.dart';
import 'package:usersms/resources/following.dart';
import 'package:usersms/utils/colors.dart';
import 'dart:math' as math;
import 'package:usersms/screens/profile/widgets/profile_background.dart';
import 'package:usersms/screens/profile/widgets/stat.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import '../../resources/searchpostpage.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

List<Map<String, dynamic>> data = [];

class FProfileScren extends StatefulWidget {
  final String campus;
  final int id;
  final String email;
  final String profilepic;
  final String username;

  const FProfileScren(
      {Key? key,
      required this.campus,
      required this.id,
      required this.email,
      required this.profilepic,
      required this.username})
      : super(key: key);

  @override
  State<FProfileScren> createState() => _FProfileScrenState();
}

class _FProfileScrenState extends State<FProfileScren> {
  int posts = 0;
  int followers = 0;
  int followings = 0;
  final picker = ImagePicker();
  bool isloading = false;
  String? content;
  String? email1;
  int? id;
  int? likes;
  String? media;
  String? pdf;
  String? title;

//get posts
  Future<void> fetchposts() async {
    try {
      setState(() {
        isloading = true;
      });
      final url = Uri.parse(
          '$baseUrl/getposts/${widget.id}'); // Replace with your JSON URL
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        print(jsonData);

        setState(() {
          data = jsonData.cast<Map<String, dynamic>>();
        });

        // Now you can access the data as needed.
        for (final item in data) {
          content = item['content'];
          email1 = item['email'];
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

  Future<void> profiledetails() async {
    Map body = {"userid": widget.id};
    final url = Uri.parse('$baseUrl/showprofiledetails');
    final response = await http.post(url, body: jsonEncode(body));
    print(response.body);

    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body);
      setState(() {
        posts = jsonData["postscount"];
        followings = jsonData["followingscount"];
        followers = jsonData["followerscount"];
      });
    } else {
      print('HTTP Request Error: ${response.statusCode}');
    }
  }

  @override
  void initState() {
    super.initState();
    // TODO: implement initState

    fetchposts().then((_) => profiledetails());
  }

  @override
  Widget build(BuildContext context) {
    return ProfileBackground(
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Transform.rotate(
                      angle: math.pi / 4,
                      child: Container(
                        width: 140.0,
                        height: 140.0,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          border: Border.all(width: 1.0, color: Colors.black),
                          borderRadius: BorderRadius.circular(35.0),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute<void>(
                          builder: (context) {
                            return Scaffold(
                              body: Center(
                                child: Hero(
                                  tag: 'profile_image',
                                  child: CachedNetworkImage(
                                    imageUrl: widget.profilepic,
                                    fit: BoxFit.cover,
                                    placeholder: (context, url) =>
                                        CircularProgressIndicator(),
                                    errorWidget: (context, url, error) => Icon(
                                      Icons.error,
                                      color: LightColor.background,
                                      size: 30,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ));
                      },
                      child: ClipPath(
                        clipper: ProfileImageClipper(),
                        child: Stack(alignment: Alignment.center, children: [
                          Hero(
                            tag: 'profile_image',
                            child: CachedNetworkImage(
                              imageUrl: widget.profilepic,
                              width: 180.0,
                              height: 180.0,
                              fit: BoxFit.cover,
                              placeholder: (context, url) =>
                                  CircularProgressIndicator(),
                              errorWidget: (context, url, error) => Icon(
                                Icons.error,
                                color: LightColor.background,
                                size: 30,
                              ),
                            ),
                          ),
                        ]),
                      ),
                    ),
                  ],
                ),
                Text(
                  "@${widget.username}",
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 4.0),
                Text(
                  "${widget.email}",
                  style: TextStyle(color: Colors.grey.shade300),
                ),
                const SizedBox(height: 80.0),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 50.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Stat(title: 'Posts', value: posts),
                      GestureDetector(
                          onTap: () {
                            Navigator.push(
                              (context),
                              MaterialPageRoute(
                                  builder: (context) => const Followers()),
                            );
                          },
                          child: Stat(title: 'Followers', value: followers)),
                      GestureDetector(
                          onTap: () {
                            Navigator.push(
                              (context),
                              MaterialPageRoute(
                                  builder: (context) => Following(
                                        id: widget.id,
                                      )),
                            );
                          },
                          child: Stat(title: 'Following', value: followings)),
                    ],
                  ),
                ),
                const SizedBox(height: 50.0),
                Padding(
                  padding: const EdgeInsets.all(4.0),
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ProfileImageClipper extends CustomClipper<Path> {
  double radius = 23;

  @override
  Path getClip(Size size) {
    Path path = Path()
      ..moveTo(size.width / 2 - radius, radius)
      ..quadraticBezierTo(size.width / 2, 0, size.width / 2 + radius, radius)
      ..lineTo(size.width - radius, size.height / 2 - radius)
      ..quadraticBezierTo(size.width, size.height / 2, size.width - radius,
          size.height / 2 + radius)
      ..lineTo(size.width / 2 + radius, size.height - radius)
      ..quadraticBezierTo(size.width / 2, size.height, size.width / 2 - radius,
          size.height - radius)
      ..lineTo(radius, size.height / 2 + radius)
      ..quadraticBezierTo(0, size.height / 2, radius, size.height / 2 - radius)
      ..close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
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
    );
  }
}
