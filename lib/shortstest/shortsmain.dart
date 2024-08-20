import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:usersms/shortstest/shortsplayerwidget.dart';
import 'package:usersms/utils/colors.dart';
import 'package:visibility_detector/visibility_detector.dart';

class ShortsMainScreen extends StatefulWidget {
  final List<Map<String, dynamic>> url;
  final int startIndex;
  const ShortsMainScreen(
      {Key? key, required this.url, required this.startIndex})
      : super(key: key);

  @override
  State<ShortsMainScreen> createState() => _ShortsMainScreenState();
}

class _ShortsMainScreenState extends State<ShortsMainScreen> {
  late PageController _pageController;
  late List<bool> playStates;
  late List<bool> initializedStates;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0, viewportFraction: 1.0);
    playStates = List.filled(widget.url.length, false);
    initializedStates = List.filled(widget.url.length, false);
    initializeVideos(0);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void initializeVideos(int currentIndex) {
    final int totalVideos = widget.url.length;

    // Initialize current video
    initializedStates[currentIndex] = true;

    // Initialize next 2 videos
    for (int i = 1; i <= 2; i++) {
      final nextIndex = (currentIndex + i) % totalVideos;
      initializedStates[nextIndex] = true;
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: (widget.url.isNotEmpty)
          ? Scaffold(
              body: PageView.builder(
                allowImplicitScrolling: true,
                physics: const BouncingScrollPhysics(),
                itemCount: widget.url.length,
                controller: _pageController,
                scrollDirection: Axis.vertical,
                onPageChanged: (index) {
                  initializeVideos(index);
                },
                itemBuilder: (context, index) {
                  if (!initializedStates[index]) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  String currentShortsUrl = widget.url[index]["media"];
                  String nextShortsUrl = (index < widget.url.length - 1)
                      ? widget.url[index + 1]["media"]
                      : "";
                  String previousShortsUrl =
                      (index > 0) ? widget.url[index - 1]["media"] : "";

                  return VisibilityDetector(
                    key: Key(index.toString()),
                    onVisibilityChanged: (visibilityInfo) {
                      if (visibilityInfo.visibleFraction == 1.0) {
                        if (mounted) {
                          setState(() {
                            playStates[index] = true;
                          });
                        }
                      } else {
                        if (mounted) {
                          setState(() {
                            playStates[index] = false;
                          });
                        }
                      }
                    },
                    child: ShortsPlayer(
                      nextvidurl: nextShortsUrl,
                      previousvidvidurl: previousShortsUrl,
                      play: playStates[index],
                      profilepic: widget.url[index]["profile_pictire"],
                      username: widget.url[index]["username"],
                      userid: widget.url[index]["userid"],
                      likes: widget.url[index]["likes"],
                      id: widget.url[index]["id"],
                      content: widget.url[index]["content"],
                      shortsUrl: currentShortsUrl,
                    ),
                  );
                },
              ),
            )
          : const Center(
              child: SpinKitSpinningLines(
                color: LightColor.scaffold,
                size: 200,
                lineWidth: 3,
              ),
            ),
    );
  }
}
