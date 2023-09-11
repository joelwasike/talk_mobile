import 'dart:io';

import 'package:flutter/material.dart';
import 'package:usersms/utils/colors.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

import '../resources/image_data.dart';
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
          backgroundColor: LightColor.maincolor1,
          automaticallyImplyLeading: false,
          title: TabBar(
            unselectedLabelStyle: TextStyle(fontSize: 15),
            indicatorPadding: EdgeInsets.only(bottom: 10),
            labelColor: LightColor.background,
            indicatorColor: LightColor.maincolor,
            dividerColor: LightColor.maincolor1,
            tabs: [
              Tab(text: 'Photos'),
              Tab(text: 'Friends'),
            ],
          ),
        ),
        body: TabBarView(
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
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(top: 16, left: 16, right: 16),
            child: TextField(
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: "Search friends...",
                hintStyle: TextStyle(color: Colors.grey.shade600),
                prefixIcon: Icon(
                  Icons.search,
                  color: Colors.grey.shade600,
                  size: 20,
                ),
                filled: true,
                fillColor: LightColor.maincolor1,
                contentPadding: EdgeInsets.all(8),
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide(color: Colors.grey.shade600)),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Container(
              child: StaggeredGrid.count(
                mainAxisSpacing: 4.0,
                crossAxisSpacing: 4.0,
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
                              builder: (context) =>
                                  SearchPostPage(postId: imageList[index].id),
                            ),
                          );
                        },
                        child: ImageCard(imageData: imageList[index])),
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

class FriendsTab extends StatefulWidget {
  const FriendsTab({Key? key}) : super(key: key);

  @override
  State<FriendsTab> createState() => _FriendsTabState();
}

class _FriendsTabState extends State<FriendsTab> {
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
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(top: 16, left: 16, right: 16),
          child: TextField(
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: "Search friends...",
              hintStyle: TextStyle(color: Colors.grey.shade600),
              prefixIcon: Icon(
                Icons.search,
                color: Colors.grey.shade600,
                size: 20,
              ),
              filled: true,
              fillColor: LightColor.maincolor1,
              contentPadding: EdgeInsets.all(8),
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide(color: Colors.grey.shade600)),
            ),
          ),
        ),
        SizedBox(
          height: 20,
        ),
        Expanded(
          child: ListView.builder(
            physics: const BouncingScrollPhysics(),
            itemCount: people.length,
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
                  name: people[index],
                  image: imageList[index],
                  school: "kibabii university",
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
