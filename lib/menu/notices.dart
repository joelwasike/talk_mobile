import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:usersms/cubit/fetchdatacubit.dart';
import 'package:usersms/cubit/fetchdatastate.dart';
import 'package:usersms/resources/addnotice.dart';
import 'package:usersms/resources/notice_post.dart';
import 'package:usersms/resources/postsloading.dart';
import '../screens/homepage.dart';
import '../utils/colors.dart';

class Notices extends StatefulWidget {
  const Notices({super.key});

  @override
  State<Notices> createState() => _NoticesState();
}

class _NoticesState extends State<Notices> {
  @override
  void initState() {
    super.initState();
    context.read<Fetchdatacubit>().fetchnotices();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            floating: true,
            snap: true,
            toolbarHeight: 30,
            leading: DrawerWidget(),
            backgroundColor: LightColor.scaffold,
            flexibleSpace: FlexibleSpaceBar(
              title: Padding(
                padding: const EdgeInsets.only(left: 56),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    FadeInRight(
                      child: Text(
                        'Campus Notice',
                        style: GoogleFonts.aguafinaScript(
                          textStyle: const TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          BlocBuilder<Fetchdatacubit, Getdatastate>(
            builder: (context, state) {
              if (state is Getdataloading || state is Getdatainitial) {
                var box = Hive.box("Talk");
                var posts = box.get("notices");
                if (posts != null && posts.isNotEmpty) {
                  return SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final item = posts[index];
                        return NoticePost(
                          id: item['id'],
                          file: item['pdf'],
                          name: item['title'],
                          image: item['media'],
                          content: item['content'],
                          likes: item['likes'],
                        );
                      },
                      childCount: posts.length,
                    ),
                  );
                } else {
                  return SliverToBoxAdapter(child: Postsloading());
                }
              } else if (state is Getdataloaded) {
                return SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final item = state.data[index];
                      return NoticePost(
                        id: item['id'],
                        file: item['pdf'],
                        name: item['title'],
                        image: item['media'],
                        content: item['content'],
                        likes: item['likes'],
                      );
                    },
                    childCount: state.data.length,
                  ),
                );
              } else {
                return SliverToBoxAdapter(
                  child: Center(
                    child: Text("Please check your internet"),
                  ),
                );
              }
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.transparent,
        mini: false,
        shape: const CircleBorder(),
        onPressed: () {
          Navigator.push(
            (context),
            MaterialPageRoute(builder: (context) => const Addnotice()),
          );
        },
        child: Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: LightColor.maincolor,
            ),
          ),
          child: Center(
            child: Icon(
              Icons.add_box,
              color: LightColor.maincolor,
            ),
          ),
        ),
      ),
    );
  }
}
