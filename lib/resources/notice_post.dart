import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:usersms/utils/colors.dart';
import 'package:usersms/widgets/comment_card.dart';
import 'heartanimationwidget.dart';

enum SampleItem { itemOne, itemTwo, itemThree }

class NoticePost extends StatefulWidget {
  final String? name;
  final String? image;
  final String? content;
  final int? likes;
  const NoticePost(
      {super.key,
      required this.name,
      required this.image,
      this.content,
      required this.likes});

  @override
  State<NoticePost> createState() => _NoticePostState();
}

class _NoticePostState extends State<NoticePost> {
  bool isliked = false;
  bool isHeartAnimating = false;
  SampleItem? selectedMenu;
  final TextEditingController _messageController = TextEditingController();
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
            Container(
              height: MediaQuery.of(context).size.height / 1.3,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: CachedNetworkImageProvider(widget.image!),
                  fit: BoxFit.fill,
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
                    icon: const Icon(
                      Icons.chat_bubble_outline_outlined,
                      color: Colors.white,
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
                      child: const Icon(
                        Icons.send,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.download_rounded,
                        color: LightColor.background,
                      ))),
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
