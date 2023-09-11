import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:usersms/resources/followers.dart';
import 'package:usersms/resources/following.dart';
import 'package:usersms/utils/colors.dart';
import 'dart:math' as math;
import 'package:usersms/widgets/profile/widgets/profile_background.dart';
import 'package:usersms/widgets/profile/widgets/stat.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import '../../resources/image_data.dart';
import '../../resources/searchpostpage.dart';

class UserProfileScren extends StatefulWidget {
  const UserProfileScren({Key? key}) : super(key: key);

  @override
  State<UserProfileScren> createState() => _UserProfileScrenState();
}

class _UserProfileScrenState extends State<UserProfileScren> {
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
                    ClipPath(
                        clipper: ProfileImageClipper(),
                        child: Stack(alignment: Alignment.center, children: [
                          Image.asset(
                            'assets/airtime.jpg',
                            width: 180.0,
                            height: 180.0,
                            fit: BoxFit.cover,
                          ),
                          Icon(
                            Icons.add_a_photo,
                            color: LightColor.background,
                            size: 30,
                          )
                        ]))
                  ],
                ),
                const Text(
                  'Joel Wasike',
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 4.0),
                Text(
                  '@jolewasike',
                  style: TextStyle(color: Colors.grey.shade300),
                ),
                const SizedBox(height: 80.0),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 50.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Stat(title: 'Posts', value: 35),
                      GestureDetector(
                          onTap: () {
                            Navigator.push(
                              (context),
                              MaterialPageRoute(
                                  builder: (context) => const Followers()),
                            );
                          },
                          child: Stat(title: 'Followers', value: 1552)),
                      GestureDetector(
                          onTap: () {
                            Navigator.push(
                              (context),
                              MaterialPageRoute(
                                  builder: (context) => const Following()),
                            );
                          },
                          child: Stat(title: 'Following', value: 128)),
                    ],
                  ),
                ),
                const SizedBox(height: 50.0),
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: StaggeredGrid.count(
                    mainAxisSpacing: 3.0,
                    crossAxisSpacing: 3.0,
                    crossAxisCount: 3,
                    children: List.generate(
                      imageList.length,
                      (index) => StaggeredGridTile.fit(
                        crossAxisCellCount: 1,
                        child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => SearchPostPage(
                                      postId: imageList[index].id),
                                ),
                              );
                            },
                            child: ImageCard(imageData: imageList[index])),
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

  final ImageData imageData;

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
    bool isVideo = isVideoLink(imageData.imageUrl);
    return ClipRRect(
      borderRadius: BorderRadius.circular(16.0),
      child: isVideo
          ? FutureBuilder<String>(
              future: generateVideoThumbnail(imageData.imageUrl),
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
          : Image.network(imageData.imageUrl, fit: BoxFit.cover),
    );
  }
}
