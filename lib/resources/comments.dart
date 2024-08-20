import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:http/http.dart' as http;
import 'package:usersms/resources/apiconstatnts.dart';
import 'package:usersms/utils/colors.dart';
import 'package:usersms/widgets/comment_card.dart';

class Comments extends StatefulWidget {
  final String postcommenturl;
  final String getcommenturl;
  final int postid;
  const Comments(
      {Key? key,
      required this.postid,
      required this.postcommenturl,
      required this.getcommenturl})
      : super(key: key);

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
      final url =
          Uri.parse('$baseUrl/${widget.getcommenturl}/${widget.postid}');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);

        setState(() {
          data = jsonData.cast<Map<String, dynamic>>();
        });

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
    super.initState();
    timer = Timer.periodic(Duration(seconds: 2), (Timer t) {
      fetchData();
    });
  }

  @override
  void dispose() {
    timer.cancel();
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 10),
            const Text(
              "Comments",
              style: TextStyle(
                  fontSize: 16,
                  color: LightColor.background,
                  fontWeight: FontWeight.w700),
            ),
            Divider(color: Colors.grey.shade800),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                physics: const BouncingScrollPhysics(),
                // Remove the reverse: true property
                itemCount: data.length,
                itemBuilder: (context, index) {
                  // Reverse the order of the data list
                  var item = data[data.length - 1 - index];
                  return CommentCard(
                    content: item["content"],
                    date: item["time"],
                    profilepic: item["profilepicture"],
                    username: item["username"],
                  );
                },
              ),
            ),
            _buildMessageInput(),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageInput() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
      color: Colors.black,
      child: Row(
        children: <Widget>[
          Expanded(
            child: TextField(
              controller: _messageController,
              decoration: InputDecoration(
                hintText: "Write a comment...",
                hintStyle: TextStyle(color: Colors.grey),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0),
                  borderSide: BorderSide(color: Colors.grey),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0),
                  borderSide: BorderSide(color: LightColor.maincolor),
                ),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              ),
            ),
          ),
          SizedBox(width: 8),
          FloatingActionButton(
            onPressed: () {
              makecomment();
            },
            backgroundColor: LightColor.maincolor,
            elevation: 0,
            mini: true,
            child: const Icon(
              Icons.send,
              color: Colors.white,
              size: 18,
            ),
          ),
        ],
      ),
    );
  }
}
