// import 'package:animate_do/animate_do.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:getwidget/components/shimmer/gf_shimmer.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:hive_flutter/hive_flutter.dart';
// import 'package:inview_notifier_list/inview_notifier_list.dart';
// import 'package:usersms/cubit/fetchdatacubit.dart';
// import 'package:usersms/cubit/fetchdatastate.dart';
// import 'package:usersms/resources/addforumpost.dart';
// import 'package:usersms/resources/apiconstatnts.dart';
// import 'package:usersms/resources/postsloading.dart';
// import 'package:usersms/resources/video_user_post.dart';
// import '../resources/photo_user_posts.dart';
// import '../utils/colors.dart';
// import 'dart:convert';
// import 'package:http/http.dart' as http;

// class ForumPosts extends StatefulWidget {
//   final String title;
//   final int forumid;
//   const ForumPosts({super.key, required this.title, required this.forumid});

//   @override
//   State<ForumPosts> createState() => _ForumPostsState();
// }

// class _ForumPostsState extends State<ForumPosts> {
//   final ScrollController _scrollController =
//       ScrollController(); // Add this line
//   List<Map<String, dynamic>> data = [];
//   bool isloading = false;
//   String? content;
//   String? email;
//   int? id;
//   int? likes;
//   String? media;
//   String? pdf;
//   int? title;

//   bool isVideoLink(String link) {
//     final videoExtensions = ['.mp4', '.avi', '.mkv', '.mov', '.wmv'];
//     for (final extension in videoExtensions) {
//       if (link.toLowerCase().endsWith(extension)) {
//         return true;
//       }
//     }
//     return false;
//   }

//   @override
//   void initState() {
//     super.initState();
//     context.read<Fetchdatacubit>().fetchforumPosts(widget.forumid);
//   }

//   @override
//   void dispose() {
//     _scrollController.dispose(); // Dispose the scroll controller
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         iconTheme: IconThemeData(color: LightColor.background),
//         toolbarHeight: 40,
//         backgroundColor: Colors.black,
//         flexibleSpace: FlexibleSpaceBar(
//           title: Row(
//             mainAxisAlignment: MainAxisAlignment.end,
//             children: [
//               FadeInRight(
//                   child: Text("${widget.title}",
//                       style: GoogleFonts.aguafinaScript(
//                         textStyle: TextStyle(
//                           color: Colors.grey.shade300,
//                           fontSize: 22,
//                           fontWeight: FontWeight.w900,
//                         ),
//                       ))),
//               SizedBox(
//                 width: 5,
//               )
//             ],
//           ),
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         backgroundColor:
//             Colors.transparent, // Set the background color to transparent
//         mini: false,
//         shape:
//             const CircleBorder(), // Use CircleBorder to create a round button
//         onPressed: () {
//           Navigator.push(
//             (context),
//             MaterialPageRoute(
//                 builder: (context) => AddForumPost(
//                       clubid: widget.forumid,
//                     )),
//           );
//         },
//         child: Container(
//           decoration: BoxDecoration(
//             shape: BoxShape.circle,
//             border: Border.all(
//               color: LightColor.maincolor, // Specify the border color here
//             ),
//           ),
//           child: Center(
//               child: Icon(
//             Icons.add_box,
//             color: LightColor.maincolor,
//           )),
//         ),
//       ),
//       body: BlocBuilder<Fetchdatacubit, Getdatastate>(
//         builder: (context, state) {
//           if (state is Getdataloading) {
//             var box = Hive.box("Talk");
//             var posts = box.get("forumposts");
//             if (posts != null && posts.isNotEmpty) {
//               return InViewNotifierList(
//                 physics: BouncingScrollPhysics(),
//                 scrollDirection: Axis.vertical,
//                 initialInViewIds: const ['0'],
//                 isInViewPortCondition: (double deltaTop, double deltaBottom,
//                     double viewPortDimension) {
//                   return deltaTop < (0.5 * viewPortDimension) &&
//                       deltaBottom > (0.5 * viewPortDimension);
//                 },
//                 itemCount: posts.length,
//                 builder: (BuildContext context, int index) {
//                   return LayoutBuilder(
//                     builder:
//                         (BuildContext context, BoxConstraints constraints) {
//                       return InViewNotifierWidget(
//                         id: '$index',
//                         builder: (BuildContext context, bool isInView,
//                             Widget? child) {
//                           final item = posts[index];
//                           return isVideoLink(item["media"])
//                               ? FadeInRight(
//                                   child: VUserPost(
//                                     profilepic: item['profilepic'],
//                                     scrollController: _scrollController,
//                                     addlikelink: "postlikes",
//                                     minuslikelink: "postlikesminus",
//                                     id: item["id"],
//                                     play: isInView,
//                                     name: 'Club',
//                                     url: item['media'],
//                                     content: item['content'],
//                                     likes: item['likes'],
//                                     getcommenturl: 'getforumcomments',
//                                     postcommenturl: 'forumcomments',
//                                   ),
//                                 )
//                               : FadeInRight(
//                                   child: UserPost(
//                                     profilepic: item['profilepic'],
//                                     scrollController: _scrollController,
//                                     addlikelink: "forumlikes",
//                                     minuslikelink: "minusforumlikes",
//                                     id: item["id"],
//                                     name: "thejoel",
//                                     image: item['media'],
//                                     content: item['content'],
//                                     likes: item['likes'],
//                                     getcommenturl: 'getforumcomments',
//                                     postcommenturl: 'forumcomments',
//                                   ),
//                                 );
//                         },
//                       );
//                     },
//                   );
//                 },
//               );
//             } else {
//               return Postsloading();
//             }
//           } else if (state is Getdatainitial) {
//             var box = Hive.box("Talk");
//             var posts = box.get("forumposts");
//             if (posts != null && posts.isNotEmpty) {
//               return InViewNotifierList(
//                 physics: BouncingScrollPhysics(),
//                 scrollDirection: Axis.vertical,
//                 initialInViewIds: const ['0'],
//                 isInViewPortCondition: (double deltaTop, double deltaBottom,
//                     double viewPortDimension) {
//                   return deltaTop < (0.5 * viewPortDimension) &&
//                       deltaBottom > (0.5 * viewPortDimension);
//                 },
//                 itemCount: posts.length,
//                 builder: (BuildContext context, int index) {
//                   return LayoutBuilder(
//                     builder:
//                         (BuildContext context, BoxConstraints constraints) {
//                       return InViewNotifierWidget(
//                         id: '$index',
//                         builder: (BuildContext context, bool isInView,
//                             Widget? child) {
//                           final item = posts[index];
//                           return isVideoLink(item["media"])
//                               ? FadeInRight(
//                                   child: VUserPost(
//                                     profilepic: item['profilepic'],
//                                     scrollController: _scrollController,
//                                     addlikelink: "postlikes",
//                                     minuslikelink: "postlikesminus",
//                                     id: item["id"],
//                                     play: isInView,
//                                     name: 'Club',
//                                     url: item['media'],
//                                     content: item['content'],
//                                     likes: item['likes'],
//                                     getcommenturl: 'getforumcomments',
//                                     postcommenturl: 'forumcomments',
//                                   ),
//                                 )
//                               : FadeInRight(
//                                   child: UserPost(
//                                     profilepic: item['profilepic'],
//                                     scrollController: _scrollController,
//                                     addlikelink: "forumlikes",
//                                     minuslikelink: "minusforumlikes",
//                                     id: item["id"],
//                                     name: "thejoel",
//                                     image: item['media'],
//                                     content: item['content'],
//                                     likes: item['likes'],
//                                     getcommenturl: 'getforumcomments',
//                                     postcommenturl: 'forumcomments',
//                                   ),
//                                 );
//                         },
//                       );
//                     },
//                   );
//                 },
//               );
//             } else {
//               return Postsloading();
//             }
//           } else if (state is Getdataloaded) {
//             return InViewNotifierList(
//               physics: BouncingScrollPhysics(),
//               scrollDirection: Axis.vertical,
//               initialInViewIds: const ['0'],
//               isInViewPortCondition: (double deltaTop, double deltaBottom,
//                   double viewPortDimension) {
//                 return deltaTop < (0.5 * viewPortDimension) &&
//                     deltaBottom > (0.5 * viewPortDimension);
//               },
//               itemCount: state.data.length,
//               builder: (BuildContext context, int index) {
//                 return LayoutBuilder(
//                   builder: (BuildContext context, BoxConstraints constraints) {
//                     return InViewNotifierWidget(
//                       id: '$index',
//                       builder:
//                           (BuildContext context, bool isInView, Widget? child) {
//                         final item = state.data[index];
//                         return isVideoLink(item["media"])
//                             ? FadeInRight(
//                                 child: VUserPost(
//                                   profilepic: item['profilepic'],
//                                   scrollController: _scrollController,
//                                   addlikelink: "postlikes",
//                                   minuslikelink: "postlikesminus",
//                                   id: item["id"],
//                                   play: isInView,
//                                   name: 'Club',
//                                   url: item['media'],
//                                   content: item['content'],
//                                   likes: item['likes'],
//                                   getcommenturl: 'getforumcomments',
//                                   postcommenturl: 'forumcomments',
//                                 ),
//                               )
//                             : FadeInRight(
//                                 child: UserPost(
//                                   profilepic: item['profilepic'],
//                                   scrollController: _scrollController,
//                                   addlikelink: "forumlikes",
//                                   minuslikelink: "minusforumlikes",
//                                   id: item["id"],
//                                   name: "thejoel",
//                                   image: item['media'],
//                                   content: item['content'],
//                                   likes: item['likes'],
//                                   getcommenturl: 'getforumcomments',
//                                   postcommenturl: 'forumcomments',
//                                 ),
//                               );
//                       },
//                     );
//                   },
//                 );
//               },
//             );
//           } else {
//             return Center(
//               child: Text("Please check your internet"),
//             );
//           }
//         },
//       ),
//     );
//   }
// }
