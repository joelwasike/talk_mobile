import 'dart:async';
import 'dart:convert';
import 'package:hive_flutter/adapters.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:usersms/resources/apiconstatnts.dart';
import 'package:usersms/utils/colors.dart';
import 'package:usersms/widgets/comment_card.dart';

class Comments extends StatefulWidget {
  final String postcommenturl;
  final String getcommenturl;
  final int postid;
  const Comments(
      {super.key,
      required this.postid,
      required this.postcommenturl,
      required this.getcommenturl});

  @override
  State<Comments> createState() => _CommentsState();
}

class _CommentsState extends State<Comments> {
  TextEditingController _messageController = TextEditingController();
  var message = "";
  List<Map<String, dynamic>> data = [];
  bool isloading = false;
  String? content;
  String? email;
  int? id;
  int? likes;
  String? media;
  String? pdf;
  String? title;
  late Timer timer;

  Future<void> fetchData() async {
    try {
      setState(() {
        isloading = true;
      });
      final url = Uri.parse(
          '$baseUrl/${widget.getcommenturl}/${widget.postid}'); // Replace with your JSON URL
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);

        setState(() {
          data = jsonData.cast<Map<String, dynamic>>();
        });

        // Now you can access the data as needed.
        for (final item in data) {
          content = item['content'];
          email = item['email'];
          id = item['id'];
          likes = item['likes'];
          media = item['media'];
          title = item['username'];
        }
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      print(e);
    } finally {
      if (mounted) {
        setState(() {
          isloading = false;
        });
      }
    }
  }

  Future<void> makecomment() async {
    setState(() {
      message = _messageController.text;
      _messageController.clear();
    });

    var box = Hive.box("Talk");
    var userid = box.get("id");
    Map body = {"userid": userid, "postid": widget.postid, "comment": message};
    final url = Uri.parse('$baseUrl/${widget.postcommenturl}');
    final response = await http.post(url, body: jsonEncode(body));
    print(response.body);

    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body);
      print(jsonData);
    } else {
      print('HTTP Request Error: ${response.statusCode}');
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Timer.periodic(Duration(seconds: 2), (Timer timer) {
      fetchData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const SizedBox(
            height: 10,
          ),
          const Text(
            "Comments",
            style: TextStyle(fontSize: 16, color: LightColor.background),
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
              reverse: true,
              itemCount: data.length,
              itemBuilder: (context, index) {
                var item = data[index];
                return CommentCard(
                  content: item["content"],
                  date: item["time"],
                  profilepic: item["profilepicture"],
                  username: item["username"],
                );
              },
            ),
          ),
          _buildMessageInput()
        ],
      ),
    );
  }

  Widget _buildMessageInput() {
    return Align(
      alignment: Alignment.bottomLeft,
      child: Container(
        padding: const EdgeInsets.only(left: 5, bottom: 10, top: 5),
        height: 60,
        width: double.infinity,
        color: LightColor.scaffold,
        child: Row(
          children: <Widget>[
            const SizedBox(
              width: 15,
            ),
            Expanded(
              child: TextField(
                controller: _messageController,
                decoration: InputDecoration(
                  hintText: "Write a comment...",
                  hintStyle: TextStyle(color: Colors.grey),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                    borderSide: BorderSide(
                      color: Colors.grey,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                    borderSide: BorderSide(
                      color: LightColor
                          .maincolor, // You can change the border color when focused
                    ),
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 15),
                ),
              ),
            ),
            const SizedBox(
              width: 15,
            ),
            FloatingActionButton(
              onPressed: () {
                makecomment();
              },
              backgroundColor: LightColor.maincolor,
              elevation: 0,
              child: const Icon(
                Icons.send,
                color: Colors.white,
                size: 18,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
