import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:usersms/shortstest/shortsplayerwidget.dart';
import 'package:usersms/utils/colors.dart';
import 'package:visibility_detector/visibility_detector.dart';

class ShortsMainScreen extends StatefulWidget {
  final List url;
  final int startIndex;
  const ShortsMainScreen(
      {Key? key, required this.url, required this.startIndex})
      : super(key: key);

  @override
  State<ShortsMainScreen> createState() => _ShortsMainScreenState();
}

class _ShortsMainScreenState extends State<ShortsMainScreen> {
  PageController _pageController = PageController(initialPage: 0, viewportFraction: 1.0);
  List<bool> playStates = List.filled(100, false); // Assuming a maximum of 100 videos

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: (widget.url.isNotEmpty)
          ? Scaffold(
              body: PageView.builder(
                allowImplicitScrolling: true,
                physics: BouncingScrollPhysics(),
                itemCount: widget.url.length,
                controller: _pageController,
                scrollDirection: Axis.vertical,
                itemBuilder: (context, index) {
                  String currentShortsUrl = widget.url[index]["media"];
                  String nextShortsUrl = (index < widget.url.length - 1)
                      ? widget.url[index + 1]["media"]
                      : ""; // Check if not at the end
                  String previousShortsUrl =
                      (index > 0) ? widget.url[index - 1]["media"] : ""; // Check if not at the beginning

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
                    child: Stack(
                      children: [
                        ShortsPlayer(
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
                      ],
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
