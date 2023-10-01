import 'package:flutter/material.dart';
import 'package:inview_notifier_list/inview_notifier_list.dart';
import 'package:usersms/utils/colors.dart';
import 'package:usersms/widgets/comment_card.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'heartanimationwidget.dart';
import 'image_data.dart';

enum SampleItem { itemOne, itemTwo, itemThree }

class VUserPost extends StatefulWidget {
  final String name;
  final String content;
  final int likes;
  final String? url;
  final bool play;
  final ScrollController scrollController;

  const VUserPost({
    required this.name,
    required this.scrollController,
    required this.content,
    required this.likes,required this.url, required this.play,
  });

  @override
  State<VUserPost> createState() => _UserPostState();
}

class _UserPostState extends State<VUserPost> {
  bool isliked = false;
  bool isHeartAnimating = false;
  SampleItem? selectedMenu;
  final TextEditingController _messageController = TextEditingController();
  VideoPlayerController? _videoPlayerController;
   late VideoPlayerController _controller;
  late Future<void> _initializeVideoPlayerFuture;



  List people = [
    "Joel",
    "Delan",
    "Wicky",
    "Salim",
    "Benna",
    "Chalo",
    "Wasike",
    "Fello",
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
  void initState() {
    super.initState();
    _controller = VideoPlayerController.networkUrl(Uri.parse(widget.url!));
    _initializeVideoPlayerFuture = _controller.initialize().then((_) {
      // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
      setState(() {});
    });

    if (widget.play) {
      _controller.play();
      _controller.setLooping(true);
    }
  }

  @override
  void didUpdateWidget(VUserPost oldWidget) {
    if (oldWidget.play != widget.play) {
      if (widget.play) {
        _controller.play();
        _controller.setLooping(true);
      } else {
        _controller.pause();
      }
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    _controller.dispose();
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
          child: Stack(
  alignment: Alignment.center,
  children: [
   AspectRatio(
     aspectRatio: _videoPlayerController!.value.aspectRatio,
     child: GestureDetector(
       onTap: () {
         print("object taped");
       },
       child: FutureBuilder(
      future: _initializeVideoPlayerFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return VideoPlayer(_controller);
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    ),
     ),
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
        ),
      ),
    ),
  ],
)

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
                                                top: 16, left: 16, right: 16),
                                            child: TextField(
                                              decoration: InputDecoration(
                                                border: InputBorder.none,
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
                                                enabledBorder:
                                                    OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(20),
                                                        borderSide: BorderSide(
                                                            color: Colors.grey
                                                                .shade600)),
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
               Text(
                widget.likes.toString(),
              ),
              const Text(
                "students",
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
                text:  TextSpan(children: [
              const TextSpan(
                  text: "Wiky_Akumu ",
                  style: TextStyle(fontWeight: FontWeight.bold)),
              TextSpan(
                  text:widget.content,
                  style: const TextStyle(color: Colors.white)),
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
