import 'package:cached_network_image/cached_network_image.dart';
import 'package:cherry_toast/cherry_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_file_downloader/flutter_file_downloader.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:page_transition/page_transition.dart';
import 'package:usersms/resources/apiconstatnts.dart';
import 'package:usersms/resources/comments.dart';
import 'package:usersms/resources/sharepost.dart';
import 'package:usersms/utils/colors.dart';
import 'heartanimationwidget.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

enum SampleItem { itemOne, itemTwo, itemThree }

// ignore: must_be_immutable
class NoticePost extends StatefulWidget {
  final String file;
  final String? name;
  final String? image;
  final String? content;
  int likes;
  final int? id;

  NoticePost(
      {super.key,
      required this.name,
      required this.image,
      this.content,
      required this.likes,
      required this.file,
      this.id});

  @override
  State<NoticePost> createState() => _NoticePostState();
}

class _NoticePostState extends State<NoticePost> {
  bool boom = false;
  int likes = 1;
  var userid;
  double? _progress;
  bool isliked = false;
  bool isHeartAnimating = false;
  SampleItem? selectedMenu;
  final TextEditingController _messageController = TextEditingController();
  bool permissionReady = false;

  Future likepost() async {
    Map body = {"userid": userid, "postid": widget.id};
    final url = Uri.parse('$baseUrl/noticelikes');
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
    final url = Uri.parse('$baseUrl/minusnoticelikes');
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
    // TODO: implement initState
    super.initState();
    func();
    id();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8, bottom: 8, top: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(
                    FontAwesomeIcons.bell,
                    color: LightColor.maincolor,
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Text(
                    widget.name!,
                    style: const TextStyle(fontWeight: FontWeight.bold),
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
          child: Stack(alignment: Alignment.center, children: [
            ConstrainedBox(
              constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height / 1.3,
                  minWidth: MediaQuery.of(context).size.width),
              child: CachedNetworkImage(
                fadeInCurve: Curves.easeIn,
                imageUrl: widget.image!,
                fit: BoxFit.fitWidth,
                placeholder: (context, url) => Container(
                  width: MediaQuery.of(context).size.width,
                  height: 300,
                ),
                // Placeholder while loading
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
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Padding(
                          padding: const EdgeInsets.all(4),
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
                                  getcommenturl: "getnoticecomments",
                                  postcommenturl: "noticecomments",
                                  postid: widget.id!,
                                )),
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
                          padding: const EdgeInsets.all(4),
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
                            getcommenturl: "",
                            postcommenturl: "",
                            postid: 2,
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
                                url: widget.file.trim(),
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
                  style: TextStyle(color: Colors.grey.shade200, fontSize: 14)),
            ])),
          ),
        )
      ],
    );
  }

  Widget _buildMessageInput() {
    return Row(
      children: [
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
        IconButton(onPressed: () {}, icon: const Icon(Icons.send))
      ],
    );
  }
}
