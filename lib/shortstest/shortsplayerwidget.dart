import 'dart:convert';
import 'package:cherry_toast/cherry_toast.dart';
import 'package:flutter_file_downloader/flutter_file_downloader.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:page_transition/page_transition.dart';
import 'package:usersms/resources/apiconstatnts.dart';
import 'package:usersms/resources/comments.dart';
import 'package:usersms/resources/heartanimationwidget.dart';
import 'package:usersms/utils/colors.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:usersms/screens/reels.dart';
import '../../utils/constants.dart' hide baseUrl;

class ShortsPlayer extends StatefulWidget {
  final String shortsUrl;
  final String nextvidurl;
  final String previousvidvidurl;
  final bool play;
  final String profilepic;
  final String username;
  final String userid;
  final int likes;
  final String id;
  final String content;

  const ShortsPlayer({
    Key? key,
    required this.shortsUrl,
    required this.nextvidurl,
    required this.previousvidvidurl,
    required this.play,
    required this.profilepic,
    required this.username,
    required this.userid,
    required this.likes,
    required this.id,
    required this.content,
  }) : super(key: key);

  @override
  State<ShortsPlayer> createState() => _ShortsPlayerState();
}

class _ShortsPlayerState extends State<ShortsPlayer> {
  late VideoPlayerController _controller;
  bool _isInitialized = false;
  bool _isLiked = false;
  int _currentLikes = 0;

  @override
  void initState() {
    super.initState();
    _currentLikes = widget.likes;
    _initializeVideo();
  }

  Future<void> _initializeVideo() async {
    _controller = VideoPlayerController.networkUrl(Uri.parse(widget.shortsUrl));
    
    try {
      await _controller.initialize();
      _controller.setLooping(true);
      _controller.setVolume(1.0);
      
      if (mounted) {
        setState(() {
          _isInitialized = true;
        });
      }
    } catch (e) {
      debugPrint('Error initializing video: $e');
    }
  }

  @override
  void didUpdateWidget(ShortsPlayer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.shortsUrl != oldWidget.shortsUrl) {
      _controller.dispose();
      _initializeVideo();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _likePost() async {
    if (!_isLiked) {
      setState(() {
        _isLiked = true;
        _currentLikes++;
      });
      
      try {
        final response = await http.post(
          Uri.parse('$baseUrl/postlikes'),
          body: jsonEncode({
            "userid": widget.userid,
            "postid": widget.id
          }),
        );
        
        if (response.statusCode != 200) {
          throw Exception('Failed to like post');
        }
      } catch (e) {
        debugPrint('Error liking post: $e');
        setState(() {
          _isLiked = false;
          _currentLikes--;
        });
      }
    }
  }

  Future<void> _unlikePost() async {
    if (_isLiked) {
      setState(() {
        _isLiked = false;
        _currentLikes--;
      });
      
      try {
        final response = await http.post(
          Uri.parse('$baseUrl/postlikesminus'),
          body: jsonEncode({
            "userid": widget.userid,
            "postid": widget.id
          }),
        );
        
        if (response.statusCode != 200) {
          throw Exception('Failed to unlike post');
        }
      } catch (e) {
        debugPrint('Error unliking post: $e');
        setState(() {
          _isLiked = true;
          _currentLikes++;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        if (!_isInitialized)
          const Center(
            child: CircularProgressIndicator(
              color: LightColor.scaffold,
            ),
          )
        else
          GestureDetector(
            onTap: () {
              setState(() {
                if (_controller.value.isPlaying) {
                  _controller.pause();
                } else {
                  _controller.play();
                }
              });
            },
            child: VideoPlayer(_controller),
          ),
        if (widget.play && _isInitialized)
          Builder(
            builder: (context) {
              _controller.play();
              return const SizedBox.shrink();
            },
          )
        else
          Builder(
            builder: (context) {
              _controller.pause();
              return const SizedBox.shrink();
            },
          ),
        Positioned(
          bottom: 20,
          left: 20,
          right: 20,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    backgroundImage: NetworkImage(widget.profilepic),
                    radius: 20,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    widget.username,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                widget.content,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  IconButton(
                    icon: Icon(
                      _isLiked ? Icons.favorite : Icons.favorite_border,
                      color: _isLiked ? Colors.red : Colors.white,
                    ),
                    onPressed: _isLiked ? _unlikePost : _likePost,
                  ),
                  Text(
                    _currentLikes.toString(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
