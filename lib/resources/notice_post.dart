import 'package:cached_network_image/cached_network_image.dart';
import 'package:cherry_toast/cherry_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_file_downloader/flutter_file_downloader.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:getwidget/components/shimmer/gf_shimmer.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:usersms/resources/apiconstatnts.dart';
import 'package:usersms/utils/colors.dart';
import 'package:usersms/widgets/comment_card.dart';
import 'heartanimationwidget.dart';
import 'package:flutter_file_downloader/flutter_file_downloader.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

enum SampleItem { itemOne, itemTwo, itemThree }

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
  double? _progress;
  String _status = '';
  bool isliked = false;
  bool isHeartAnimating = false;
  SampleItem? selectedMenu;
  final TextEditingController _messageController = TextEditingController();
  bool permissionReady = false;

  Future<void> like() async {
    var box = Hive.box("Talk");
    var userid = box.get("id");

    Map body = {"userid": userid, "postid": widget.id};
    final url = Uri.parse('$baseUrl/noticelikes'); // Replace with your JSON URL
    final response = await http.post(url, body: jsonEncode(body));

    if (response.statusCode == 200) {
      setState(() {
        widget.likes = (widget.likes + 1);
      });
    } else {
      print('HTTP Request Error: ${response.statusCode}');
    }
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
                        });
                        if (isliked) {
                          setState(() {
                            widget.likes + 1;
                          });
                          like();
                        }
                         if (!isliked) {
                          setState(() {
                            widget.likes - 1;
                          });
                          like();
                        }
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
                                    Text(
                                      "Comments",
                                      style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.grey.shade300),
                                    ),
                                    Divider(
                                      color: Colors.grey.shade800,
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    const Expanded(
                                        child: Column(
                                      children: [
                                        CommentCard(),
                                      ],
                                    )),
                                    _buildMessageInput()
                                  ],
                                ),
                              ));
                    },
                    icon: Icon(
                      Icons.chat_bubble_outline_outlined,
                      color: Colors.grey.shade300,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      showModalBottomSheet(
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
                                    Text(
                                      "Select friends to share",
                                      style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.grey.shade300),
                                    ),
                                    Divider(
                                      color: Colors.grey.shade800,
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    const Expanded(
                                        child: Column(
                                      children: [],
                                    )),
                                  ],
                                ),
                              ));
                    },
                    icon: Transform(
                      transform: Matrix4.rotationZ(5.8),
                      child: Icon(
                        Icons.send,
                        color: Colors.grey.shade300,
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: _progress != null
                    ? SpinKitThreeBounce(
                        color: Colors.white,
                        size: 25,
                      )
                    : IconButton(
                        onPressed: () async {
                          FileDownloader.downloadFile(
                              url: widget.file.trim(),
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
                                        backgroundColor:
                                            Colors.black.withOpacity(0.9),
                                        displayTitle: false,
                                        description: Text(
                                          "Download complete",
                                          style: const TextStyle(
                                              color: Colors.white),
                                        ),
                                        animationDuration:
                                            const Duration(milliseconds: 500),
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
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 8),
          child: Row(
            children: [
              const Text(
                "Liked by ",
              ),
              Text(
                "${widget.likes} ",
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const Text(
                "students",
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
                  style: TextStyle(color: Colors.grey.shade200, fontSize: 12)),
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
