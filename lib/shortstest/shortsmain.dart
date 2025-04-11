import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:usersms/shortstest/shortsplayerwidget.dart';
import 'package:usersms/utils/colors.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:video_player/video_player.dart';

class ShortsMainScreen extends StatefulWidget {
  final List<Map<String, dynamic>> url;
  final int startIndex;
  const ShortsMainScreen({
    Key? key, 
    required this.url, 
    required this.startIndex
  }) : super(key: key);

  @override
  State<ShortsMainScreen> createState() => _ShortsMainScreenState();
}

class _ShortsMainScreenState extends State<ShortsMainScreen> {
  late PageController _pageController;
  late List<bool> playStates;
  late List<bool> initializedStates;
  final Map<int, VideoPlayerController> _videoControllers = {};
  static const int _preloadCount = 2; // Number of videos to preload

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: widget.startIndex, viewportFraction: 1.0);
    playStates = List.filled(widget.url.length, false);
    initializedStates = List.filled(widget.url.length, false);
    _initializeVideos(widget.startIndex);
  }

  @override
  void dispose() {
    _disposeVideoControllers();
    _pageController.dispose();
    super.dispose();
  }

  void _disposeVideoControllers() {
    for (var controller in _videoControllers.values) {
      controller.dispose();
    }
    _videoControllers.clear();
  }

  Future<void> _initializeVideoController(int index) async {
    if (_videoControllers.containsKey(index)) return;

    final videoUrl = widget.url[index]["media"];
    final controller = VideoPlayerController.networkUrl(Uri.parse(videoUrl));
    
    try {
      await controller.initialize();
      controller.setLooping(true);
      controller.setVolume(1.0);
      
      if (mounted) {
        setState(() {
          _videoControllers[index] = controller;
          initializedStates[index] = true;
        });
      }
    } catch (e) {
      debugPrint('Error initializing video controller: $e');
      if (mounted) {
        setState(() {
          initializedStates[index] = false;
        });
      }
    }
  }

  void _initializeVideos(int currentIndex) {
    final int totalVideos = widget.url.length;

    // Initialize current video
    _initializeVideoController(currentIndex);

    // Preload next videos
    for (int i = 1; i <= _preloadCount; i++) {
      final nextIndex = (currentIndex + i) % totalVideos;
      _initializeVideoController(nextIndex);
    }

    // Preload previous video
    final prevIndex = (currentIndex - 1 + totalVideos) % totalVideos;
    _initializeVideoController(prevIndex);
  }

  void _cleanupOldControllers(int currentIndex) {
    final keysToRemove = <int>[];
    for (var index in _videoControllers.keys) {
      if ((index - currentIndex).abs() > _preloadCount + 1) {
        keysToRemove.add(index);
      }
    }

    for (var index in keysToRemove) {
      _videoControllers[index]?.dispose();
      _videoControllers.remove(index);
    }
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
                  _initializeVideos(index);
                  _cleanupOldControllers(index);
                  setState(() {
                    // Update play states
                    for (int i = 0; i < playStates.length; i++) {
                      playStates[i] = (i == index);
                    }
                  });
                },
                itemBuilder: (context, index) {
                  if (!initializedStates[index]) {
                    return const Center(
                      child: SpinKitSpinningLines(
                        color: LightColor.scaffold,
                        size: 50,
                        lineWidth: 3,
                      ),
                    );
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
                      if (visibilityInfo.visibleFraction > 0.5) {
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
