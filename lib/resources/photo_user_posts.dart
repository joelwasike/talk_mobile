import 'package:cherry_toast/cherry_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_file_downloader/flutter_file_downloader.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:usersms/resources/apiconstatnts.dart';
import 'package:usersms/resources/comments.dart';
import 'package:usersms/utils/colors.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'heartanimationwidget.dart';
import 'image_data.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

enum SampleItem { itemOne, itemTwo, itemThree }

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
  final ScrollController scrollController; // Add this line

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
  bool boom = false;
  int likes = 1;
  bool isliked = false;
  bool isHeartAnimating = false;
  SampleItem? selectedMenu;
  final TextEditingController _messageController = TextEditingController();
  var userid;

  Future likepost() async {
    Map body = {"userid": userid, "postid": widget.id};
    final url = Uri.parse('$baseUrl/${widget.addlikelink}');
    final response = await http.post(url, body: jsonEncode(body));
    print(response.body);

    if (response.statusCode == 200) {
      print("liked succesfully");
    } else {
      print('HTTP Request Error: ${response.statusCode}');
    }
  }

  Future minuslikepost() async {
    Map body = {"userid": userid, "postid": widget.id};
    final url = Uri.parse('$baseUrl/${widget.addlikelink}');
    final response = await http.post(url, body: jsonEncode(body));
    print(response.body);

    if (response.statusCode == 200) {
      print("liked succesfully");
    } else {
      print('HTTP Request Error: ${response.statusCode}');
    }
  }

  void func() {
    setState(() {
      likes = widget.likes;
    });
  }

  void id() {
    var box = Hive.box("Talk");
    setState(() {
      userid = box.get("id");
      print(userid);
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    func();
    id();
  }

  double? _progress;

  List people = [
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

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    backgroundImage: NetworkImage(widget.profilepic),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Text(
                    widget.name,
                    style: TextStyle(
                      color: Colors.grey.shade300,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              PopupMenuButton<SampleItem>(
                color: Colors.grey.shade300,
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
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Follow'),
                        Icon(Icons.person),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        GestureDetector(
          onDoubleTap: () {
            setState(() {
              isHeartAnimating = true;
              isliked = true;
              if (!boom) {
                if (isliked) {
                  setState(() {
                    likes++;
                  });
                  likepost();
                }
                if (!isliked) {
                  setState(() {
                    likes--;
                  });
                  minuslikepost();
                }
              }
              boom = true;
            });
          },
          child: Stack(alignment: Alignment.center, children: [
            ConstrainedBox(
              constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height / 1.3,
                  minWidth: MediaQuery.of(context).size.width),
              child: CachedNetworkImage(
                imageUrl: widget.image!,
                fadeInCurve: Curves.easeIn,
                fit: BoxFit.fitWidth,
                placeholder: (context, url) => Container(
                  width: MediaQuery.of(context).size.width,
                  height: 300,
                ),
                // Placeholder while loading
              ),
            ),
            Opacity(
              opacity: isHeartAnimating ? 1 : 0,
              child: HeartAnimationWidget(
                  isAnimating: isHeartAnimating,
                  duration: const Duration(milliseconds: 700),
                  onEnd: () => setState(() {
                        isHeartAnimating = false;
                      }),
                  child: Icon(
                    Icons.favorite,
                    color: Colors.grey.shade300,
                    size: 100,
                  )),
            )
          ]),
        ),
        const SizedBox(
          height: 10,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 2),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  HeartAnimationWidget(
                    alwaysAnimate: true,
                    isAnimating: isliked,
                    child: IconButton(
                      icon: Icon(
                        isliked ? Icons.favorite : FontAwesomeIcons.heart,
                        color: isliked ? Colors.red : Colors.grey.shade300,
                        size: 28,
                      ),
                      onPressed: () {
                        setState(() {
                          isliked = !isliked;
                          if (isliked) {
                            setState(() {
                              likes++;
                            });
                            likepost();
                          }
                          if (!isliked) {
                            setState(() {
                              likes--;
                            });
                            minuslikepost();
                          }
                        });
                      },
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      showModalBottomSheet(
                          useSafeArea: true,
                          isScrollControlled: true,
                          enableDrag: true,
                          context: context,
                          builder: (context) => Container(
                              padding: EdgeInsets.only(
                                  bottom:
                                      MediaQuery.of(context).viewInsets.bottom),
                              decoration: const BoxDecoration(
                                  color: LightColor.maincolor1,
                                  borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(25),
                                      topLeft: Radius.circular(25))),
                              child: Comments(
                                getcommenturl: widget.getcommenturl,
                                postcommenturl: widget.postcommenturl,
                                postid: widget.id,
                              )));
                    },
                    icon: Icon(
                      FontAwesomeIcons.message,
                      color: Colors.grey.shade300,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      List<String> selectedNames = [];

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
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                top: 16, left: 16, right: 16),
                                            child: TextField(
                                              decoration: InputDecoration(
                                                border: InputBorder.none,
                                                hintText: "Search friends...",
                                                hintStyle: TextStyle(
                                                    color:
                                                        Colors.grey.shade600),
                                                prefixIcon: Icon(
                                                  Icons.search,
                                                  color: Colors.grey.shade600,
                                                  size: 20,
                                                ),
                                                filled: true,
                                                fillColor:
                                                    LightColor.maincolor1,
                                                contentPadding:
                                                    const EdgeInsets.all(8),
                                                enabledBorder:
                                                    OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(20),
                                                        borderSide: BorderSide(
                                                            color: Colors.grey
                                                                .shade600)),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(height: 20),
                                          Expanded(
                                            child: ListView.builder(
                                              physics:
                                                  const BouncingScrollPhysics(),
                                              itemCount: people.length,
                                              itemBuilder: (context, index) {
                                                final isSelected = selectedNames
                                                    .contains(people[index]);

                                                return LongPressSelectableTile(
                                                  onTap: () {
                                                    setState(() {
                                                      if (selectedNames
                                                          .isNotEmpty) {
                                                        if (isSelected) {
                                                          selectedNames.remove(
                                                              people[index]);
                                                        }
                                                        if (!isSelected) {
                                                          selectedNames.add(
                                                              people[index]);
                                                        }
                                                      }
                                                    });
                                                  },
                                                  onLongPress: () {
                                                    setState(() {
                                                      if (!isSelected) {
                                                        selectedNames
                                                            .add(people[index]);
                                                      } else {
                                                        selectedNames.remove(
                                                            people[index]);
                                                      }
                                                    });
                                                  },
                                                  isSelected: isSelected,
                                                  name: people[index],
                                                  image:
                                                      imageList[index].imageUrl,
                                                  followers: "200k",
                                                );
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ));
                    },
                    icon: Transform(
                      transform: Matrix4.rotationZ(5.8),
                      child: Icon(
                        Icons.send,
                        color: Colors.grey.shade300,
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: _progress != null
                    ? SpinKitThreeBounce(
                        color: Colors.white,
                        size: 25,
                      )
                    : IconButton(
                        onPressed: () async {
                          FileDownloader.downloadFile(
                              url: widget.image!.trim(),
                              onProgress: (name, progress) {
                                setState(() {
                                  _progress = progress;
                                });
                              },
                              onDownloadCompleted: (value) {
                                print('path  $value ');
                                setState(() {
                                  _progress = null;
                                });
                                CherryToast.success(
                                        title: const Text(""),
                                        backgroundColor:
                                            Colors.black.withOpacity(0.9),
                                        description: Text(
                                          "Download complete",
                                          style: const TextStyle(
                                              color: Colors.white),
                                        ),
                                        animationDuration:
                                            const Duration(milliseconds: 500),
                                        autoDismiss: true)
                                    .show(context);
                              });
                        },
                        icon: Icon(
                          Icons.download_rounded,
                          color: Colors.grey.shade300,
                        ),
                      ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              const Text(
                "Liked by ",
              ),
              Text(
                "$likes",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const Text(
                " students",
              )
            ],
          ),
        ),
        Align(
          alignment: Alignment.topLeft,
          child: Padding(
            padding: const EdgeInsets.only(left: 8),
            child: RichText(
                text: TextSpan(children: [
              TextSpan(
                  text: widget.content,
                  style: TextStyle(color: Colors.grey.shade300, fontSize: 14)),
            ])),
          ),
        )
      ],
    );
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
