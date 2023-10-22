import 'package:flutter/material.dart';

import '../utils/colors.dart';
import 'commentcomment_card.dart';

class CommentCard extends StatefulWidget {
  const CommentCard({
    Key? key,
  }) : super(key: key);

  @override
  State<CommentCard> createState() => _CommentCardState();
}

class _CommentCardState extends State<CommentCard> {
  bool isliked = false;

  List people = [
    "Joel",
    "Delan",
    "Wicky",
    "Salim",
    "Benna",
    "Chalo",
    "Wasike",
    "Fello"
  ];
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
            radius: 30,
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
                              color: LightColor.maincolor,
                              fontWeight: FontWeight.bold,
                              fontSize: 16
                            )),
                        TextSpan(
                          text:
                              "joel wasike is a good boy ajdgfoua DADSBCIUaugsdui sbhdugsdfhias idsahgiudhgfdsaf uagfsagfuasb",
                          // text: ' ${snap.data()['text']}',
                           style: TextStyle(
                            color: LightColor.background,
                              fontWeight: FontWeight.normal,
                            )
                          
                        ),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(top: 4),
                        child: Text(
                          "02-02-2020",
                          style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w300,
                              color: Colors.grey),
                        ),
                      ),
                      
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: GestureDetector(
                          onTap: () {
                            showModalBottomSheet(
                                useSafeArea: true,
                                isScrollControlled: true,
                                enableDrag: true,
                                context: context,
                                builder: (context) => Container(
                                    padding: EdgeInsets.only(
                                    bottom: MediaQuery.of(context)
                                        .viewInsets
                                        .bottom),
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
                                            "Joel's Comment",
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
                                          Expanded(
                                            child: ListView.builder(
                                              physics: const BouncingScrollPhysics(),
                                              itemCount: people.length,
                                              itemBuilder: (context, index) {
                                                return const CommentofcommentCard();
                                              },
                                            ),
                                          ),
                                          _buildMessageInput()
                                        ],
                                      ),
                                    ));
                          },
                          child: const Text(
                            "- Make a comment",
                            style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w300,
                                color: Colors.grey),
                          ),
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
                      size: 20,
                    )
                  : const Icon(
                      Icons.favorite,
                      color: Colors.red,
                      size: 20,
                    ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildMessageInput() {
    return Container(
       decoration: BoxDecoration(
      border: Border(
        top: BorderSide(color: Colors.grey.shade700),
      ),
    ),
      child: Row(
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: CircleAvatar(
              backgroundImage: AssetImage("assets/airtime.jpg"),
            ),
          ),
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
          IconButton(onPressed: () {}, icon: const Icon(Icons.send,color: LightColor.maincolor,))
        ],
      ),
    );
  }
}
