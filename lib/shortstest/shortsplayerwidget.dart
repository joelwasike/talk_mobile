import 'package:flutter/material.dart';
import 'package:usersms/resources/heartanimationwidget.dart';
import 'package:usersms/utils/colors.dart';
import 'package:video_player/video_player.dart';

class ShortsPlayer extends StatefulWidget {
  final String shortsUrl;

  const ShortsPlayer({Key? key, required this.shortsUrl}) : super(key: key);

  @override
  State<ShortsPlayer> createState() => _ShortsPlayerState();
}

class _ShortsPlayerState extends State<ShortsPlayer> {
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
 
  bool isExpanded = false;

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
      child: Container(
        height: size.height,
        width: size.width,
        color: LightColor.maincolor1,
        child: GestureDetector(
          onDoubleTap: () {
            setState(() {
              isHeartAnimating = true;
              isliked = true;
            });
          },
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
                    padding: const EdgeInsets.symmetric(
                        vertical: 40, horizontal: 15),
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
                                      AssetImage("assets/airtime.jpg"),
                                  radius: 20,
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  child: Text(
                                    '@joelwasike',
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
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: Container(
                                width: MediaQuery.of(context).size.width/1.4,
                                child: Text(
                                  'joelwasike is very good boyjoelwasike is a very good boyjoelwasike very good boyjoelwasike is a very good boyjoelwasike very good boyjoelwasike is a very good boyjoelwasike a very good boyjoelwasike is a very good boyjoelwasike is a very good boyjoelwasike is a very good boy',
                                  softWrap:
                                      true, // Allow text to wrap to the next line
                                  maxLines: isExpanded ? null : 3, // Limit the text to 3 lines
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
                                padding:
                                    const EdgeInsets.symmetric(vertical: 25),
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
                                            });
                                          },
                                        ),
                                      ),
                                      Text(
                                        "2",
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
                                  // onTap: (){
                                  //   setState(() {
                                  //     //open modal box
                                  //   });
                                  // },
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
                                child: InkWell(
                                  // onTap: (){
                                  //   setState(() {
                                  //     //open share modal box
                                  //   });
                                  // },
                                  child: Column(
                                    children: [
                                      Icon(
                                        Icons.bookmark_border_rounded,
                                        color: Colors.white,
                                        size: 30,
                                      ),
                                      Text(
                                        'Save',
                                        style: TextStyle(fontSize: 12),
                                      ),
                                    ],
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
      ),
    );
  }
}
