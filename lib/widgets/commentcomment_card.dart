import 'package:flutter/material.dart';


class CommentofcommentCard extends StatefulWidget {
  const CommentofcommentCard({super.key});

  @override
  State<CommentofcommentCard> createState() => _CommentofcommentCardState();
}

class _CommentofcommentCardState extends State<CommentofcommentCard> {
  bool isliked = false;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      child: Row(
        children: [
          const CircleAvatar(
            backgroundImage: AssetImage(
              "assets/airtime.jpg",
            ),
            radius: 18,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  RichText(
                    text: const TextSpan(
                      children: [
                        TextSpan(
                            text: "Joel:  ",
                            // text: snap.data()['name'],
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            )),
                        TextSpan(
                          text:
                              "joel wasike is a good boy ajdgfoua DADSBCIUaugsdui sbhdugsdfhias idsahgiudhgfdsaf uagfsagfuasb",
                          // text: ' ${snap.data()['text']}',
                        ),
                      ],
                    ),
                  ),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: 4),
                        child: Text(
                          "02-02-2020",
                          style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w300,
                              color: Colors.grey),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              setState(() {
                isliked = !isliked;
              });
            },
            child: Container(
              padding: const EdgeInsets.all(8),
              child: !isliked
                  ? const Icon(
                      Icons.favorite_border_outlined,
                      color: Colors.white,
                      size: 16,
                    )
                  : const Icon(
                      Icons.favorite,
                      color: Colors.red,
                      size: 16,
                    ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildMessageInput() {
    return Row(
      children: [
        Expanded(
          child: TextField(
            // controller: _messageController,
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
