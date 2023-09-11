import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:video_player/video_player.dart';

import '../resources/heartanimationwidget.dart';
import '../utils/colors.dart';
import '../widgets/comment_card.dart';

enum SampleItem { itemOne, itemTwo, itemThree }

class ContentScreen extends StatefulWidget {
  final Uri? src;

  const ContentScreen({Key? key, this.src}) : super(key: key);

  @override
  _ContentScreenState createState() => _ContentScreenState();
}

class _ContentScreenState extends State<ContentScreen> {
  late VideoPlayerController _videoPlayerController;
  final TextEditingController _messageController = TextEditingController();

  ChewieController? _chewieController;
  bool isliked = false;
  bool isHeartAnimating = false;
  SampleItem? selectedMenu;

  @override
  void initState() {
    initializePlayer();
    super.initState();
  }

  Future initializePlayer() async {
    try {
      _videoPlayerController = VideoPlayerController.networkUrl(widget.src!);
      await Future.wait([_videoPlayerController.initialize()]);
      _chewieController = ChewieController(
          videoPlayerController: _videoPlayerController,
          autoPlay: true,
          showControls: false,
          looping: true,
          
          allowFullScreen: true);

      setState(() {});
    } catch (e) {
      print(e);
    }
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    _chewieController?.dispose();
    _chewieController = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onDoubleTap: () {
        setState(() {
          isHeartAnimating = true;
          isliked = true;
        });
      },
      child: Stack(
        fit: StackFit.expand,
        children: [
          _chewieController != null &&
                  _chewieController!.videoPlayerController.value.isInitialized
              ? Chewie(
                  controller: _chewieController!,
                )
              : const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SpinKitThreeBounce(
                      color: Colors.white,
                      size: 25,
                    ),
                  ],
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
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 110),
                        const Row(
                          children: [
                            CircleAvatar(
                              radius: 16,
                              child: Icon(Icons.person, size: 18),
                            ),
                            SizedBox(width: 6),
                            Text('Joel wasike'),
                            SizedBox(width: 10),
                            Icon(Icons.verified, color: Colors.blue, size: 15),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        SizedBox(
                            width: MediaQuery.of(context).size.width / 1.5,
                            child: const Text(
                                'This is a ihweduygw7q dqwyudvg7ctvewq ciuwh deywgduew dwyuywgewqweygd butterfly')),
                        const SizedBox(height: 10),
                      ],
                    ),
                    Column(
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
                        const Text('601k'),
                        const SizedBox(height: 10),
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
                        const Text('1123'),
                        const SizedBox(height: 10),
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
                        const SizedBox(height: 50),
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Follow'),
                                  Icon(Icons.person),
                                ],
                              ),
                            ),
                            const PopupMenuItem<SampleItem>(
                              value: SampleItem.itemTwo,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Download'),
                                  Icon(Icons.download),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    )
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
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
