import 'package:flutter/material.dart';
import 'package:usersms/resources/image_data.dart';
import 'package:usersms/resources/users.search.dart';

class SearchPostPage extends StatefulWidget {
  final String postId;

  const SearchPostPage({required this.postId, Key? key}) : super(key: key);

  @override
  State<SearchPostPage> createState() => _SearchPostPageState();
}

class _SearchPostPageState extends State<SearchPostPage> {
  List<String> posts = [
    "Joel",
    "Delan",
    "Wicky",
    "Salim",
    "Benna",
    "Chalo",
    "Wasike",
    "Fello",
    "Joel",
    "Delan",
    "Wicky",
    "Salim",
    "Benna",
    "Chalo",
    "Wasike",
    "Fello"
  ];

  final ScrollController _scrollController = ScrollController(); // Add this line

  @override
  void dispose() {
    _scrollController.dispose(); // Dispose the scroll controller
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        controller: _scrollController, // Attach the scroll controller
        itemCount: posts.length,
        itemBuilder: (context, index) {
          final selectedImage = imageList.firstWhere(
            (image) => image.id == widget.postId,
            orElse: () => imageList.first,
          );

          if (index == 0) {
            return UserrPost(
              name: posts[index],
              image: selectedImage,
              scrollController: _scrollController, // Pass the scroll controller
            );
          } else {
            return UserrPost(
              name: posts[index],
              image: imageList[index - 1],
              scrollController: _scrollController, // Pass the scroll controller
            );
          }
        },
      ),
    );
  }
}
