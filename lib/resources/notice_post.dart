import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:getwidget/components/shimmer/gf_shimmer.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:usersms/utils/colors.dart';
import 'package:usersms/widgets/comment_card.dart';
import 'heartanimationwidget.dart';
import 'package:android_path_provider/android_path_provider.dart';
import 'package:path_provider/path_provider.dart';
import 'package:device_info_plus/device_info_plus.dart';

enum SampleItem { itemOne, itemTwo, itemThree }

class NoticePost extends StatefulWidget {
  final String? file;
  final String? name;
  final String? image;
  final String? content;
  final int? likes;

  const NoticePost(
      {super.key,
      required this.name,
      required this.image,
      this.content,
      required this.likes,
      this.file});

  @override
  State<NoticePost> createState() => _NoticePostState();
}

class _NoticePostState extends State<NoticePost> {
  late String _localPath;
  bool isliked = false;
  bool isHeartAnimating = false;
  SampleItem? selectedMenu;
  final TextEditingController _messageController = TextEditingController();
  bool permissionReady = false;

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
                    Icons.notification_important,
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
                imageUrl: widget.image!,

                fit: BoxFit.fitWidth,
                placeholder: (context, url) => GFShimmer(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width,
                        height: 300,
                        color: Colors.grey.shade800.withOpacity(0.4),
                      ),
                      const SizedBox(height: 12),
                      Container(
                        width: double.infinity,
                        height: 8,
                        color: Colors.grey.shade800.withOpacity(0.4),
                      ),
                      const SizedBox(height: 6),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.5,
                        height: 8,
                        color: Colors.grey.shade800.withOpacity(0.4),
                      ),
                      const SizedBox(height: 6),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.25,
                        height: 8,
                        color: Colors.grey.shade800.withOpacity(0.4),
                      )
                    ],
                  ),
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
                child: IconButton(
                  onPressed: () async {
                    final directory =
                        await getExternalStorageDirectory(); // You need to import 'package:path_provider/path_provider.dart' for this
                    final _localPath = directory!
                        .path; // This is the path where the file will be saved

                    await FlutterDownloader.enqueue(
                      url: widget.file!,
                      savedDir: _localPath,
                      showNotification: true,
                      openFileFromNotification: true,
                    );
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
