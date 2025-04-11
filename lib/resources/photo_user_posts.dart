import 'package:flutter/material.dart';
import 'package:flutter_file_downloader/flutter_file_downloader.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:usersms/resources/apiconstatnts.dart';
import 'package:usersms/resources/comments.dart';
import 'package:usersms/resources/sharepost.dart';
import 'package:usersms/utils/colors.dart';
import 'package:usersms/utils/error_handler.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'heartanimationwidget.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:page_transition/page_transition.dart';

enum SampleItem { itemOne, itemTwo, itemThree }

class ImageCard extends StatelessWidget {
  final String imageData;
  final double? width;
  final double? height;
  final BoxFit fit;

  const ImageCard({
    Key? key,
    required this.imageData,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: CachedNetworkImage(
        imageUrl: imageData,
        width: width,
        height: height,
        fit: fit,
        placeholder: (context, url) => Container(
          color: Colors.grey[300],
          child: const Center(
            child: CircularProgressIndicator(),
          ),
        ),
        errorWidget: (context, url, error) => Container(
          color: Colors.grey[300],
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, color: Colors.red),
              const SizedBox(height: 4),
              Text(
                'Failed to load image',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
        memCacheWidth: 300, // Optimize memory cache
        memCacheHeight: 300,
        maxWidthDiskCache: 600, // Optimize disk cache
        maxHeightDiskCache: 600,
      ),
    );
  }
}

class UserPost extends StatefulWidget {
  final String profilepic;
  final String getcommenturl;
  final String postcommenturl;
  final String addlikelink;
  final String minuslikelink;
  final int id;
  final String name;
  final String content;
  final int likes;
  final String? image;
  final ScrollController scrollController;

  const UserPost({
    super.key,
    required this.name,
    required this.image,
    required this.scrollController,
    required this.content,
    required this.likes,
    required this.id,
    required this.addlikelink,
    required this.minuslikelink,
    required this.getcommenturl,
    required this.postcommenturl,
    required this.profilepic,
  });

  @override
  State<UserPost> createState() => _UserPostState();
}

class _UserPostState extends State<UserPost> {
  bool _isLiked = false;
  bool _isHeartAnimating = false;
  bool _isLoading = false;
  String? _error;
  final TextEditingController _messageController = TextEditingController();
  String? _userId;

  @override
  void initState() {
    super.initState();
    _loadUserId();
  }

  void _loadUserId() {
    final box = Hive.box("Talk");
    setState(() => _userId = box.get("id"));
  }

  Future<void> _likePost() async {
    if (_isLoading || _userId == null) return;

    try {
      setState(() => _isLoading = true);
      final response = await http.post(
        Uri.parse('$baseUrl/${widget.addlikelink}'),
        body: jsonEncode({
          "userid": _userId,
          "postid": widget.id,
        }),
      );

      if (response.statusCode == 200) {
        setState(() => _isLiked = true);
      } else {
        throw Exception('Failed to like post: ${response.statusCode}');
      }
    } catch (e) {
      setState(() => _error = e.toString());
      ErrorHandler.showError(context, 'Failed to like post');
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _unlikePost() async {
    if (_isLoading || _userId == null) return;

    try {
      setState(() => _isLoading = true);
      final response = await http.post(
        Uri.parse('$baseUrl/${widget.minuslikelink}'),
        body: jsonEncode({
          "userid": _userId,
          "postid": widget.id,
        }),
      );

      if (response.statusCode == 200) {
        setState(() => _isLiked = false);
      } else {
        throw Exception('Failed to unlike post: ${response.statusCode}');
      }
    } catch (e) {
      setState(() => _error = e.toString());
      ErrorHandler.showError(context, 'Failed to unlike post');
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          if (widget.image != null) _buildImage(),
          _buildContent(),
          _buildActions(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: CachedNetworkImageProvider(widget.profilepic),
      ),
      title: Text(widget.name),
      trailing: _buildMenu(),
    );
  }

  Widget _buildImage() {
    return GestureDetector(
      onDoubleTap: () {
        setState(() => _isHeartAnimating = true);
        _likePost();
      },
      child: Stack(
        alignment: Alignment.center,
        children: [
          ImageCard(
            imageData: widget.image!,
            width: double.infinity,
            height: 300,
          ),
          if (_isHeartAnimating)
            HeartAnimationWidget(
              isAnimating: true,
              duration: const Duration(milliseconds: 700),
              onEnd: () {
                setState(() => _isHeartAnimating = false);
              },
              child: const Icon(
                Icons.favorite,
                color: Colors.red,
                size: 100,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Text(widget.content),
    );
  }

  Widget _buildActions() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          icon: Icon(
            _isLiked ? Icons.favorite : Icons.favorite_border,
            color: _isLiked ? Colors.red : null,
          ),
          onPressed: _isLoading
              ? null
              : () {
                  if (_isLiked) {
                    _unlikePost();
                  } else {
                    _likePost();
                  }
                },
        ),
        IconButton(
          icon: const Icon(Icons.comment),
          onPressed: () => _showComments(),
        ),
        IconButton(
          icon: const Icon(Icons.share),
          onPressed: () => _sharePost(),
        ),
      ],
    );
  }

  Widget _buildMenu() {
    return PopupMenuButton<SampleItem>(
      onSelected: (SampleItem item) {
        switch (item) {
          case SampleItem.itemOne:
            _downloadImage();
            break;
          case SampleItem.itemTwo:
            _reportPost();
            break;
          case SampleItem.itemThree:
            _blockUser();
            break;
        }
      },
      itemBuilder: (BuildContext context) => <PopupMenuEntry<SampleItem>>[
        const PopupMenuItem<SampleItem>(
          value: SampleItem.itemOne,
          child: Text('Download'),
        ),
        const PopupMenuItem<SampleItem>(
          value: SampleItem.itemTwo,
          child: Text('Report'),
        ),
        const PopupMenuItem<SampleItem>(
          value: SampleItem.itemThree,
          child: Text('Block User'),
        ),
      ],
    );
  }

  void _showComments() {
    Navigator.push(
      context,
      PageTransition(
        type: PageTransitionType.rightToLeft,
        child: Comments(
          getcommenturl: widget.getcommenturl,
          postcommenturl: widget.postcommenturl,
          postid: widget.id,
        ),
      ),
    );
  }

  void _sharePost() {
    Navigator.push(
      context,
      PageTransition(
        type: PageTransitionType.rightToLeft,
        child: Sharepost(
          getcommenturl: widget.getcommenturl,
          postcommenturl: widget.postcommenturl,
          postid: widget.id,
        ),
      ),
    );
  }

  Future<void> _downloadImage() async {
    if (widget.image == null) return;

    try {
      await FileDownloader.downloadFile(
        url: widget.image!,
        name: 'post_${widget.id}.jpg',
        onProgress: (name, progress) {
          // Show download progress
        },
        onDownloadCompleted: (path) {
          ErrorHandler.showSuccess(context, 'Image downloaded successfully');
        },
        onDownloadError: (error) {
          ErrorHandler.showError(context, 'Failed to download image');
        },
      );
    } catch (e) {
      ErrorHandler.showError(context, 'Failed to download image');
    }
  }

  void _reportPost() {
    // Implement report functionality
    ErrorHandler.showError(context, 'Report functionality not implemented');
  }

  void _blockUser() {
    // Implement block user functionality
    ErrorHandler.showError(context, 'Block user functionality not implemented');
  }
}

class LongPressSelectableTile extends StatefulWidget {
  final VoidCallback onTap;
  final VoidCallback onLongPress;
  final bool isSelected;
  final String name;
  final String image;
  final String followers;

  const LongPressSelectableTile({
    super.key,
    required this.onTap,
    required this.onLongPress,
    required this.isSelected,
    required this.name,
    required this.image,
    required this.followers,
  });

  @override
  State<LongPressSelectableTile> createState() =>
      _LongPressSelectableTileState();
}

class _LongPressSelectableTileState extends State<LongPressSelectableTile> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      onLongPress: widget.onLongPress,
      child: ListTile(
        title: Text(widget.name),
        subtitle: Text(
          "Followers: ${widget.followers}",
          style: const TextStyle(color: Colors.grey, fontSize: 13),
        ),
        leading: CircleAvatar(
          maxRadius: 30,
          backgroundImage: NetworkImage(widget.image),
        ),
        trailing: widget.isSelected
            ? const Icon(
                Icons.check_circle,
                color: LightColor.maincolor,
              )
            : const SizedBox(),
      ),
    );
  }
}
