import 'dart:convert';
import 'package:cherry_toast/cherry_toast.dart';
import 'package:flutter_file_downloader/flutter_file_downloader.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:getwidget/components/shimmer/gf_shimmer.dart';
import 'package:page_transition/page_transition.dart';
import 'package:usersms/resources/apiconstatnts.dart';
import 'package:usersms/resources/comments.dart';
import 'package:usersms/resources/sharepost.dart';
import 'package:usersms/utils/colors.dart';
import 'package:video_player/video_player.dart';
import 'heartanimationwidget.dart';

enum SampleItem { itemOne, itemTwo, itemThree }

class VUserPost extends StatefulWidget {
  final String profilepic;
  final String getcommenturl;
  final String postcommenturl;
  final String addlikelink;
  final String minuslikelink;
  final int id;
  final String name;
  final String content;
  final int likes;
  final String? url;
  final bool play;
  final ScrollController scrollController;

  const VUserPost({
    super.key,
    required this.name,
    required this.scrollController,
    required this.content,
    required this.likes,
    required this.url,
    required this.play,
    required this.id,
    required this.addlikelink,
    required this.minuslikelink,
    required this.getcommenturl,
    required this.postcommenturl,
    required this.profilepic,
  });

  @override
  State<VUserPost> createState() => _UserPostState();
}

class _UserPostState extends State<VUserPost> {
  bool isliked = false;
  bool isHeartAnimating = false;
  SampleItem? selectedMenu;
  final TextEditingController _messageController = TextEditingController();
  late VideoPlayerController _controller;
  late Future<void> _initializeVideoPlayerFuture;
  bool boom = false;
  int likes = 1;
  var userid;

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
  double? _progress;

  Future likepost() async {
    Map body = {"userid": userid, "postid": widget.id};
    final url = Uri.parse('$baseUrl/${widget.addlikelink}');
    final response = await http.post(url, body: jsonEncode(body));
    print(response.body);

    if (response.statusCode == 200) {
      print("liked succesfully");
    } else {
      print('HTTP Request Error: ${response.statusCode}');
    }
  }

  Future minuslikepost() async {
    Map body = {"userid": userid, "postid": widget.id};
    final url = Uri.parse('$baseUrl/${widget.minuslikelink}');
    final response = await http.post(url, body: jsonEncode(body));
    print(response.body);

    if (response.statusCode == 200) {
      print("liked succesfully");
    } else {
      print('HTTP Request Error: ${response.statusCode}');
    }
  }

  void func() {
    setState(() {
      likes = widget.likes;
    });
  }

  void id() {
    var box = Hive.box("Talk");
    setState(() {
      userid = box.get("id");
      print(userid);
    });
  }

  @override
  void initState() {
    super.initState();

    _controller = VideoPlayerController.networkUrl(Uri.parse(widget.url!));
    _initializeVideoPlayerFuture = _controller.initialize().then((_) {
      // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
      setState(() {});
    });
    func();
    id();

    // Only play the video if it's supposed to be playing (i.e., it's visible)
    if (widget.play) {
      _controller.play();
      _controller.setLooping(true);
    }
  }

  @override
  void didUpdateWidget(VUserPost oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.play != widget.play) {
      if (widget.play) {
        _controller.play();
      } else {
        _controller.pause();
      }
    }
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
          padding: const EdgeInsets.only(top: 8, bottom: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    maxRadius: 17,
                    backgroundImage: NetworkImage(widget.profilepic),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Text(
                    widget.name,
                    style: TextStyle(
                      color: Colors.grey.shade300,
                      fontWeight: FontWeight.bold,
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
                if (!boom) {
                  if (isliked) {
                    setState(() {
                      likes++;
                    });
                    likepost();
                  }
                  if (!isliked) {
                    setState(() {
                      likes--;
                    });
                    minuslikepost();
                  }
                }
                boom = true;
              });
            },
            child: Stack(
              alignment: Alignment.center,
              children: [
                AspectRatio(
                  aspectRatio: _controller.value.aspectRatio,
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
                                  color: Color.fromARGB(255, 66, 66, 66)
                                      .withOpacity(0.2),
                                ),
                                const SizedBox(height: 6),
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.5,
                                  height: 8,
                                  color: Colors.grey.shade800.withOpacity(0.2),
                                ),
                                const SizedBox(height: 6),
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.25,
                                  height: 8,
                                  color: Colors.grey.shade800.withOpacity(0.2),
                                )
                              ],
                            ),
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
                    child: Icon(
                      Icons.favorite,
                      color: Colors.grey.shade300,
                      size: 100,
                    ),
                  ),
                ),
              ],
            )),
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
                  Stack(
                    children: [
                      HeartAnimationWidget(
                        alwaysAnimate: true,
                        isAnimating: isliked,
                        child: IconButton(
                          icon: Icon(
                            isliked ? Icons.favorite : Icons.favorite_outline,
                            color: isliked ? Colors.red : Colors.grey.shade300,
                            size: 28,
                          ),
                          onPressed: () {
                            setState(() {
                              isliked = !isliked;
                              if (isliked) {
                                likes++;
                                likepost();
                              } else {
                                likes--;
                                minuslikepost();
                              }
                            });
                          },
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Padding(
                          padding: const EdgeInsets.all(
                              4), // Optional padding for spacing
                          child: Text(
                            likes.toString(),
                            style: const TextStyle(fontSize: 12),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Stack(
                    children: [
                      IconButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            PageTransition(
                              type: PageTransitionType.rightToLeft,
                              child: Comments(
                                getcommenturl: widget.getcommenturl,
                                postcommenturl: widget.postcommenturl,
                                postid: widget.id,
                              ),
                            ),
                          );
                        },
                        icon: Icon(
                          FontAwesomeIcons.comment,
                          size: 23,
                          color: Colors.grey.shade300,
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Padding(
                          padding: const EdgeInsets.all(
                              4), // Optional padding for spacing
                          child: Text(
                            likes.toString(),
                            style: const TextStyle(fontSize: 12),
                          ),
                        ),
                      ),
                    ],
                  ),
                  IconButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        PageTransition(
                          type: PageTransitionType.rightToLeft,
                          child: Sharepost(
                            getcommenturl: widget.getcommenturl,
                            postcommenturl: widget.postcommenturl,
                            postid: widget.id,
                          ),
                        ),
                      );
                    },
                    icon: Icon(
                      FontAwesomeIcons.paperPlane,
                      size: 21,
                      color: Colors.grey.shade300,
                    ),
                  ),
                ],
              ),
              Flexible(
                // Wrapping the Column with Flexible
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: _progress != null
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            LinearProgressIndicator(
                              // Removed SizedBox
                              value: _progress,
                              backgroundColor: Colors.grey.shade300,
                              color: Colors.blue,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              "${(_progress! * 100).toStringAsFixed(0)}%",
                              style: const TextStyle(color: Colors.white),
                            ),
                          ],
                        )
                      : IconButton(
                          onPressed: () async {
                            setState(() {
                              _progress = 0.0; // Initialize progress
                            });
                            try {
                              //You can download a single file
                              await FileDownloader.downloadFile(
                                url: widget.url!.trim(),
                                onProgress: (name, progress) {
                                  setState(() {
                                    _progress = progress;
                                  });
                                },
                                onDownloadCompleted: (value) {
                                  print('Downloaded to path: $value');
                                  setState(() {
                                    _progress = null;
                                  });
                                  CherryToast.success(
                                    title: const Text(""),
                                    backgroundColor:
                                        Colors.black.withOpacity(0.9),
                                    description: const Text(
                                      "Download complete",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    animationDuration:
                                        const Duration(milliseconds: 500),
                                    autoDismiss: true,
                                  ).show(context);
                                },
                              );
                            } catch (e) {
                              setState(() {
                                _progress = null;
                              });
                              CherryToast.error(
                                title: const Text("Download Failed"),
                                backgroundColor: Colors.red.withOpacity(0.9),
                                description: Text(
                                  e.toString(),
                                  style: const TextStyle(color: Colors.white),
                                ),
                                animationDuration:
                                    const Duration(milliseconds: 500),
                                autoDismiss: true,
                              ).show(context);
                            }
                          },
                          icon: Icon(
                            FontAwesomeIcons.download,
                            color: Colors.grey.shade300,
                            size: 21,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
        Align(
          alignment: Alignment.topLeft,
          child: Padding(
            padding: const EdgeInsets.only(left: 8),
            child: RichText(
                text: TextSpan(children: [
              TextSpan(
                  text: widget.content,
                  style: TextStyle(color: Colors.grey.shade300, fontSize: 13)),
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
                color: Color.fromARGB(255, 22, 136, 230),
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
