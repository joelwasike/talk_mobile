import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:usersms/cubit/fetchdatacubit.dart';
import 'package:usersms/cubit/fetchdatastate.dart';
import 'package:usersms/resources/club_post.dart';
import 'package:usersms/resources/clubcred.dart';
import 'package:usersms/resources/isloadong.dart';
import 'package:usersms/widgets/club_card.dart';
import '../screens/homepage.dart';
import '../utils/colors.dart';

class Clubs extends StatefulWidget {
  const Clubs({super.key});

  @override
  State<Clubs> createState() => _ClubsState();
}

class _ClubsState extends State<Clubs> {
  List<Map<String, dynamic>> filteredData = []; // Store filtered data

  List<Map<String, dynamic>> data = [];
  bool isloading = false;

  // Method to filter data based on search query
  void filterData(String query) {
    setState(() {
      filteredData = data
          .where((item) =>
              item['name'].toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    context.read<Fetchdatacubit>().fetchClublist();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: DrawerWidget(),
        toolbarHeight: 30,
        backgroundColor: LightColor.scaffold,
        title: Padding(
          padding: const EdgeInsets.only(left: 56),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Spacer(),
              FadeInRight(
                  child: Text('Clubs & Societies',
                      style: GoogleFonts.aguafinaScript(
                        textStyle: const TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.w900,
                        ),
                      ))),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor:
            Colors.transparent, // Set the background color to transparent
        mini: false,
        shape:
            const CircleBorder(), // Use CircleBorder to create a round button
        onPressed: () {
          Navigator.push(
            (context),
            MaterialPageRoute(builder: (context) => const ClubCred()),
          );
        },
        child: Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: LightColor.maincolor, // Specify the border color here
            ),
          ),
          child: Center(
              child: Icon(
            Icons.add_box,
            color: LightColor.maincolor,
          )),
        ),
      ),
      body: isloading
          ? Isloading()
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 2, left: 6, right: 2),
                  child: TextField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Colors.grey.shade600),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6),
                        borderSide: BorderSide(color: Colors.grey.shade600),
                      ),
                      hintText: "Search clubs and societies...",
                      hintStyle: TextStyle(color: Colors.grey.shade600),
                      prefixIcon: Icon(
                        Icons.search,
                        color: Colors.grey.shade600,
                        size: 20,
                      ),
                      filled: true,
                      fillColor: LightColor.maincolor1,
                      contentPadding: const EdgeInsets.all(8),
                    ),
                    onChanged: (query) {
                      filterData(query);
                    },
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                Expanded(
                  child: BlocBuilder<Fetchdatacubit, Getdatastate>(
                    builder: (context, state) {
                      if (state is Getdatainitial) {
                        var box = Hive.box("Talk");
                        var posts = box.get("clublist");
                        if (posts != null && posts.isNotEmpty) {
                          return ListView.builder(
                            physics: const BouncingScrollPhysics(),
                            itemCount: posts.length,
                            itemBuilder: (context, index) {
                              final club = posts[index];
                              return GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    (context),
                                    MaterialPageRoute(
                                        builder: (context) => Clubpost(
                                              title: club['name'],
                                              clubid: club["id"],
                                            )),
                                  );
                                },
                                child: ClubCard(
                                  name: club['name'],
                                  image: club['profilepicture'],
                                  description: club['description'],
                                ),
                              );
                            },
                          );
                        } else {
                          return Isloading();
                        }
                      } else if (state is Getdataloading) {
                        var box = Hive.box("Talk");
                        var posts = box.get("clublist");
                        if (posts != null && posts.isNotEmpty) {
                          return ListView.builder(
                            physics: const BouncingScrollPhysics(),
                            itemCount: posts.length,
                            itemBuilder: (context, index) {
                              final club = posts[index];
                              return GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    (context),
                                    MaterialPageRoute(
                                        builder: (context) => Clubpost(
                                              title: club['name'],
                                              clubid: club["id"],
                                            )),
                                  );
                                },
                                child: ClubCard(
                                  name: club['name'],
                                  image: club['profilepicture'],
                                  description: club['description'],
                                ),
                              );
                            },
                          );
                        } else {
                          return Isloading();
                        }
                      } else if (state is Getdataloaded) {
                        return ListView.builder(
                          physics: const BouncingScrollPhysics(),
                          itemCount: state.data.length,
                          itemBuilder: (context, index) {
                            final club = state.data[index];
                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  (context),
                                  MaterialPageRoute(
                                      builder: (context) => Clubpost(
                                            title: club['name'],
                                            clubid: club["id"],
                                          )),
                                );
                              },
                              child: ClubCard(
                                name: club['name'],
                                image: club['profilepicture'],
                                description: club['description'],
                              ),
                            );
                          },
                        );
                      } else {
                        return Center(
                          child: Text("Please check your internet"),
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
    );
  }
}
