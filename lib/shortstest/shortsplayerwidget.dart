import 'dart:convert';
import 'package:cherry_toast/cherry_toast.dart';
import 'package:flutter_file_downloader/flutter_file_downloader.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:usersms/resources/apiconstatnts.dart';
import 'package:usersms/resources/comments.dart';
import 'package:usersms/resources/heartanimationwidget.dart';
import 'package:usersms/utils/colors.dart';
import 'package:video_player/video_player.dart';

class ShortsPlayer extends StatefulWidget {
  final String shortsUrl;
  final int likes;
  final String content;
  final int userid;
  final int id;
  final String username;
  final String profilepic;

  const ShortsPlayer(
      {Key? key,
      required this.shortsUrl,
      required this.likes,
      required this.content,
      required this.userid,
      required this.id,
      required this.username,
      required this.profilepic})
      : super(key: key);

  @override
  State<ShortsPlayer> createState() => _ShortsPlayerState();
}

class _ShortsPlayerState extends State<ShortsPlayer> {
  double? _progress;
  late VideoPlayerController videoPlayerController;
  bool isHeartAnimating = false;
  bool isliked = false;
  Color likeBtnColor = Colors.white,
      dislikeBtnColor = Colors.white,
      subscribeBtnColor = Colors.red;
  double iconSize = 33;
  TextStyle textStyle1 = const TextStyle(
    color: Colors.white,
    fontSize: 15,
  );
  bool boom = false;
  int likes = 1;
  var userid;

  bool isExpanded = false;

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

  Future likepost() async {
    Map body = {"userid": userid, "postid": widget.id};
    final url = Uri.parse('$baseUrl/postlikes');
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
    final url = Uri.parse('$baseUrl/postlikesminus');
    final response = await http.post(url, body: jsonEncode(body));
    print(response.body);

    if (response.statusCode == 200) {
      print("liked succesfully");
    } else {
      print('HTTP Request Error: ${response.statusCode}');
    }
  }

  @override
  void initState() {
    super.initState();
    videoPlayerController =
        VideoPlayerController.networkUrl(Uri.parse(widget.shortsUrl))
          ..initialize().then((_) {
            videoPlayerController.setLooping(true); // Enable video looping
            videoPlayerController.play();
            videoPlayerController.setVolume(1);
          });
    func();
    id();
  }

  @override
  void dispose() {
    videoPlayerController.dispose();
    super.dispose();
  }

  int tapCount = 0;
  bool playIconVisible = true;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return GestureDetector(
      onTap: () {
        setState(() {
          tapCount++;
        });
        if (tapCount % 2 == 0) {
          videoPlayerController.play();
          setState(() {
            playIconVisible = true;
          });
        } else {
          videoPlayerController.pause();
          setState(() {
            playIconVisible = false;
          });
        }
      },
      onDoubleTap: () {
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
      },
      child: Container(
        height: size.height,
        width: size.width,
        color: LightColor.maincolor1,
        child: Stack(
          alignment: Alignment.center,
          children: [
            VideoPlayer(videoPlayerController),
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
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                //upper options row
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [],
                ),

                //lower-operations row
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 40, horizontal: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      //video content details
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // user profile details
                          Row(
                            children: [
                              CircleAvatar(
                                backgroundImage:
                                    NetworkImage("${widget.profilepic}"),
                                radius: 20,
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                child: Text(
                                  '@${widget.username}',
                                  style: TextStyle(
                                    color: Colors.grey.shade200,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Container(
                              width: MediaQuery.of(context).size.width / 1.4,
                              child: Text(
                                widget.content,
                                softWrap:
                                    true, // Allow text to wrap to the next line
                                maxLines: isExpanded
                                    ? null
                                    : 3, // Limit the text to 3 lines
                                style: TextStyle(
                                  color: Colors.grey.shade100,
                                  fontSize: 15,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                            ),
                          ),
                          if (!isExpanded)
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  isExpanded = true;
                                });
                              },
                              child: Text(
                                'Read more',
                                style: TextStyle(
                                  color: Colors.blue,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                        ],
                      ),

                      //like + dislike + comments + share options
                      SizedBox(
                        child: Column(
                          children: [
                            //like btn
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 25),
                              child: InkWell(
                                child: Column(
                                  children: [
                                    HeartAnimationWidget(
                                      alwaysAnimate: true,
                                      isAnimating: isliked,
                                      child: IconButton(
                                        icon: Icon(
                                          isliked
                                              ? Icons.favorite
                                              : Icons.favorite_outline,
                                          color: isliked
                                              ? Colors.red
                                              : Colors.white,
                                          size: 30,
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            isliked = !isliked;
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
                                          });
                                        },
                                      ),
                                    ),
                                    Text(
                                      likes.toString(),
                                      style: textStyle1,
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            //dislike btn

                            //comment btn
                            Padding(
                              padding: const EdgeInsets.only(bottom: 25),
                              child: InkWell(
                                onTap: () {
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
                                                  topLeft:
                                                      Radius.circular(25))),
                                          child: Comments(
                                            getcommenturl: "getpostcomments",
                                            postcommenturl: "comments",
                                            postid: widget.id,
                                          )));
                                },
                                child: Column(
                                  children: [
                                    Icon(
                                      Icons.comment_rounded,
                                      color: Colors.white,
                                      size: 30,
                                    ),
                                    Text(
                                      "3",
                                      style: textStyle1,
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            //save btn
                            Padding(
                              padding: const EdgeInsets.only(bottom: 25),
                              child: _progress != null
                                  ? SpinKitThreeBounce(
                                      color: Colors.white,
                                      size: 25,
                                    )
                                  : IconButton(
                                      onPressed: () async {
                                        FileDownloader.downloadFile(
                                            url: widget.shortsUrl.trim(),
                                            onProgress: (name, progress) {
                                              setState(() {
                                                _progress = progress;
                                              });
                                            },
                                            onDownloadCompleted: (value) {
                                              print('path  $value ');
                                              setState(() {
                                                _progress = null;
                                              });
                                              CherryToast.success(
                                                      title: const Text(""),
                                                      backgroundColor: Colors
                                                          .black
                                                          .withOpacity(0.9),
                                                      displayTitle: false,
                                                      description: Text(
                                                        "Download complete",
                                                        style: const TextStyle(
                                                            color:
                                                                Colors.white),
                                                      ),
                                                      animationDuration:
                                                          const Duration(
                                                              milliseconds:
                                                                  500),
                                                      autoDismiss: true)
                                                  .show(context);
                                            });
                                      },
                                      icon: Icon(
                                        Icons.download_rounded,
                                        color: Colors.grey.shade300,
                                      ),
                                    ),
                            ),

                            // share btn
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
