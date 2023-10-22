import 'package:flutter/material.dart';
import 'package:usersms/utils/colors.dart';
import 'package:usersms/widgets/comment_card.dart';
import 'package:video_player/video_player.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import 'package:visibility_detector/visibility_detector.dart';

import 'heartanimationwidget.dart';
import 'image_data.dart';

enum SampleItem { itemOne, itemTwo, itemThree }

class UserrPost extends StatefulWidget {
  final String name;
  final ImageData image;
  final ScrollController scrollController; // Add this line

  const UserrPost(
      {super.key,
      required this.name,
      required this.image,
      required this.scrollController});

  @override
  State<UserrPost> createState() => _UserrPostState();
}

class _UserrPostState extends State<UserrPost> {
  bool isliked = false;
  bool isHeartAnimating = false;
  SampleItem? selectedMenu;
  final TextEditingController _messageController = TextEditingController();
  VideoPlayerController? _videoPlayerController;
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    if (isVideoLink(widget.image.imageUrl)) {
      _videoPlayerController =
          VideoPlayerController.networkUrl(Uri.parse(widget.image.imageUrl))
            ..initialize().then((_) {
              _videoPlayerController!.setLooping(true);
              // Ensure the first frame is shown
              setState(() {});
            });
    }
    widget.scrollController.addListener(_handleScroll); // Add this line
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

  Future<String> generateVideoThumbnail(String videoUrl) async {
    final thumbnailPath = await VideoThumbnail.thumbnailFile(
      video: videoUrl,
      quality: 100, // Adjust the quality (0 - 100)
      maxHeight: 128, // Maximum height of the thumbnail
    );

    return thumbnailPath!;
  }

  bool _isVideoVisible() {
    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    final videoPosition = renderBox.localToGlobal(Offset.zero).dy;
    final videoHeight = renderBox.size.height;
    final screenHeight = MediaQuery.of(context).size.height;

    return videoPosition > 0 && videoPosition < screenHeight - videoHeight;
  }

  // Handle video auto-play based on visibility
  void _handleScroll() {
    if (_videoPlayerController != null &&
        _videoPlayerController!.value.isInitialized &&
        _isPlaying &&
        _isVideoVisible()) {
      _videoPlayerController?.play();
    } else {
      _videoPlayerController?.pause();
    }
  }

  List people = [
    "Joel",
    "Delan",
    "Wicky",
    "Salim",
    "Benna",
    "Chalo",
    "Wasike",
    "Fello"
  ];

  @override
  void dispose() {
    _videoPlayerController?.dispose();
    _videoPlayerController = null;
    widget.scrollController.removeListener(_handleScroll); // Remove listener
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const CircleAvatar(
                    backgroundImage: AssetImage('assets/airtime.jpg'),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Text(
                    widget.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              PopupMenuButton<SampleItem>(
                color: LightColor.background,
                initialValue: selectedMenu,
                onSelected: (SampleItem item) {
                  setState(() {
                    selectedMenu = item;
                  });
                },
                itemBuilder: (BuildContext context) =>
                    <PopupMenuEntry<SampleItem>>[
                  const PopupMenuItem<SampleItem>(
                    value: SampleItem.itemOne,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Follow'),
                        Icon(Icons.person),
                      ],
                    ),
                  ),
                  const PopupMenuItem<SampleItem>(
                    value: SampleItem.itemTwo,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Download'),
                        Icon(Icons.download),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        GestureDetector(
          onDoubleTap: () {
            setState(() {
              isHeartAnimating = true;
              isliked = true;
            });
          },
          child: Stack(alignment: Alignment.center, children: [
            VisibilityDetector(
              key: Key(widget.image.imageUrl), // Key must be unique
              onVisibilityChanged: (visibilityInfo) {
                _isPlaying = visibilityInfo.visibleFraction >= 0.5;
                _handleScroll();
              },
              child: _videoPlayerController != null &&
                      _videoPlayerController!.value.isInitialized
                  ? AspectRatio(
                      aspectRatio: _videoPlayerController!.value.aspectRatio,
                      child: VideoPlayer(_videoPlayerController!),
                    )
                  : Image.network(widget.image.imageUrl, fit: BoxFit.cover),
            ),
            Opacity(
              opacity: isHeartAnimating ? 1 : 0,
              child: HeartAnimationWidget(
                  isAnimating: isHeartAnimating,
                  duration: const Duration(milliseconds: 700),
                  onEnd: () => setState(() {
                        isHeartAnimating = false;
                      }),
                  child: const Icon(
                    Icons.favorite,
                    color: Colors.white,
                    size: 100,
                  )),
            )
          ]),
        ),
        const SizedBox(
          height: 10,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 2),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  HeartAnimationWidget(
                    alwaysAnimate: true,
                    isAnimating: isliked,
                    child: IconButton(
                      icon: Icon(
                        isliked ? Icons.favorite : Icons.favorite_outline,
                        color: isliked ? Colors.red : Colors.white,
                        size: 28,
                      ),
                      onPressed: () {
                        setState(() {
                          isliked = !isliked;
                        });
                      },
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      showModalBottomSheet(
                          useSafeArea: true,
                          isScrollControlled: true,
                          enableDrag: true,
                          context: context,
                          builder: (context) => Container(
                                padding: EdgeInsets.only(
                                    bottom: MediaQuery.of(context)
                                        .viewInsets
                                        .bottom),
                                decoration: const BoxDecoration(
                                    color: LightColor.maincolor1,
                                    borderRadius: BorderRadius.only(
                                        topRight: Radius.circular(25),
                                        topLeft: Radius.circular(25))),
                                child: Column(
                                  children: [
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    const Text(
                                      "Comments",
                                      style: TextStyle(
                                          fontSize: 16,
                                          color: LightColor.background),
                                    ),
                                    Divider(
                                      color: Colors.grey.shade800,
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Expanded(
                                      child: ListView.builder(
                                        physics: const BouncingScrollPhysics(),
                                        itemCount: people.length,
                                        itemBuilder: (context, index) {
                                          return const CommentCard();
                                        },
                                      ),
                                    ),
                                    _buildMessageInput()
                                  ],
                                ),
                              ));
                    },
                    icon: const Icon(
                      Icons.chat_bubble_outline_outlined,
                      color: Colors.white,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      List<String> selectedNames = [];

                      showModalBottomSheet(
                          useSafeArea: true,
                          isScrollControlled: true,
                          enableDrag: true,
                          context: context,
                          builder: (context) => Container(
                                decoration: const BoxDecoration(
                                    color: LightColor.maincolor1,
                                    borderRadius: BorderRadius.only(
                                        topRight: Radius.circular(25),
                                        topLeft: Radius.circular(25))),
                                child: Column(
                                  children: [
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    const Text(
                                      "Select friends to share",
                                      style: TextStyle(
                                          fontSize: 16,
                                          color: LightColor.background),
                                    ),
                                    Divider(
                                      color: Colors.grey.shade800,
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                top: 2, left: 6, right: 2),
                                            child: TextField(
                                              decoration: InputDecoration(
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                  borderSide: BorderSide(
                                                      color:
                                                          Colors.grey.shade600),
                                                ),
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(6),
                                                  borderSide: BorderSide(
                                                      color:
                                                          Colors.grey.shade600),
                                                ),
                                                hintText: "Search friends...",
                                                hintStyle: TextStyle(
                                                    color:
                                                        Colors.grey.shade600),
                                                prefixIcon: Icon(
                                                  Icons.search,
                                                  color: Colors.grey.shade600,
                                                  size: 20,
                                                ),
                                                filled: true,
                                                fillColor:
                                                    LightColor.maincolor1,
                                                contentPadding:
                                                    const EdgeInsets.all(8),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(height: 20),
                                          Expanded(
                                            child: ListView.builder(
                                              physics:
                                                  const BouncingScrollPhysics(),
                                              itemCount: people.length,
                                              itemBuilder: (context, index) {
                                                final isSelected = selectedNames
                                                    .contains(people[index]);

                                                return LongPressSelectableTile(
                                                  onTap: () {
                                                    setState(() {
                                                      if (selectedNames
                                                          .isNotEmpty) {
                                                        if (isSelected) {
                                                          selectedNames.remove(
                                                              people[index]);
                                                        }
                                                        if (!isSelected) {
                                                          selectedNames.add(
                                                              people[index]);
                                                        }
                                                      }
                                                    });
                                                  },
                                                  onLongPress: () {
                                                    setState(() {
                                                      if (!isSelected) {
                                                        selectedNames
                                                            .add(people[index]);
                                                      } else {
                                                        selectedNames.remove(
                                                            people[index]);
                                                      }
                                                    });
                                                  },
                                                  isSelected: isSelected,
                                                  name: people[index],
                                                  image:
                                                      imageList[index].imageUrl,
                                                  followers: "200k",
                                                );
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ));
                    },
                    icon: Transform(
                      transform: Matrix4.rotationZ(5.8),
                      child: const Icon(
                        Icons.send,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Icon(
                  Icons.bookmark_add_outlined,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              const Text(
                "Liked by ",
              ),
              Text(
                "${widget.name} ",
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const Text(
                "and ",
              ),
              const Text(
                "others",
                style: TextStyle(fontWeight: FontWeight.bold),
              )
            ],
          ),
        ),
        Align(
          alignment: Alignment.topLeft,
          child: Padding(
            padding: const EdgeInsets.only(left: 8),
            child: RichText(
                text: const TextSpan(children: [
              TextSpan(
                  text: "Wiky_Akumu ",
                  style: TextStyle(fontWeight: FontWeight.bold)),
              TextSpan(
                  text:
                      "This guy really like to eat. I found him at the hotel taking a big fish. Bad person.",
                  style: TextStyle(color: Colors.white)),
            ])),
          ),
        )
      ],
    );
  }

  Widget _buildMessageInput() {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: Colors.grey.shade700),
        ),
      ),
      child: Row(
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: CircleAvatar(
              backgroundImage: AssetImage("assets/airtime.jpg"),
            ),
          ),
          Expanded(
            child: TextField(
              controller: _messageController,
              decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(vertical: 16),
                  border: InputBorder.none,
                  hintText: "    Write Comment",
                  hintStyle: TextStyle(color: Colors.grey.shade400)),
            ),
          ),
          IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.send,
                color: LightColor.maincolor,
              ))
        ],
      ),
    );
  }
}

class LongPressSelectableTile extends StatefulWidget {
  final VoidCallback onTap;
  final VoidCallback onLongPress;
  final bool isSelected;
  final String name;
  final String image;
  final String followers;

  const LongPressSelectableTile({
    super.key,
    required this.onTap,
    required this.onLongPress,
    required this.isSelected,
    required this.name,
    required this.image,
    required this.followers,
  });

  @override
  State<LongPressSelectableTile> createState() =>
      _LongPressSelectableTileState();
}

class _LongPressSelectableTileState extends State<LongPressSelectableTile> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      onLongPress: widget.onLongPress,
      child: ListTile(
        title: Text(widget.name),
        subtitle: Text(
          "Followers: ${widget.followers}",
          style: const TextStyle(color: Colors.grey, fontSize: 13),
        ),
        leading: CircleAvatar(
          maxRadius: 30,
          backgroundImage: NetworkImage(widget.image),
        ),
        trailing: widget.isSelected
            ? const Icon(
                Icons.check_circle,
                color: LightColor.maincolor,
              )
            : const SizedBox(),
      ),
    );
  }
}
