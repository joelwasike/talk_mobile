import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart'; // Import intl package
import 'package:usersms/resources/chat_service.dart';
import 'package:usersms/utils/chat_bubble.dart';

class Chatpage extends StatefulWidget {
  final String email;
  final String uid;
  const Chatpage({super.key, required this.email, required this.uid});

  @override
  State<Chatpage> createState() => _ChatpageState();
}

class _ChatpageState extends State<Chatpage> {
  final TextEditingController _messageController = TextEditingController();
  final Chatservice _chatservice = Chatservice();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  ScrollController _scrollController = ScrollController();

  void sendMessage() async {
    if (_messageController.text.isNotEmpty) {
      await _chatservice.sendMessage(widget.uid, _messageController.text);
      _messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.white, //change your color here
        ),
        backgroundColor: const Color(0xFF121212),
        title: Text(
          widget.email,
          style: const TextStyle(color: Colors.white),
        ),
      ),
      body: Column(
        children: [
          Expanded(child: _buildMessageList()),
          _buildMessageInput(),
        ],
      ),
    );
  }



  Widget _buildMessageList() {
    return StreamBuilder(
      stream:
          _chatservice.getMessages(widget.uid, _firebaseAuth.currentUser!.uid),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text("error ${snapshot.error.toString()}");
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text("Loading..");
        }
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        });

        return ListView.builder(
          controller: _scrollController,
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (context, index) {
            return _buildMessageItem(snapshot.data!.docs[index]);
          },
        );
      },
    );
  }

  Widget _buildMessageInput() {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: _messageController,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(vertical: 16),
              border: InputBorder.none,
              hintText: "    Enter message",
              hintStyle: TextStyle(color: Colors.grey.shade400),
            ),
          ),
        ),
        IconButton(onPressed: sendMessage, icon: const Icon(Icons.send))
      ],
    );
  }

  Widget _buildMessageItem(DocumentSnapshot document) {
    Map<String, dynamic> data = document.data() as Map<String, dynamic>;
    var alignment = (data["senderId"] == _firebaseAuth.currentUser!.uid)
        ? Alignment.centerRight
        : Alignment.centerLeft;

    return Container(
      alignment: alignment,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment:
              (data["senderId"] == _firebaseAuth.currentUser!.uid)
                  ? CrossAxisAlignment.end
                  : CrossAxisAlignment.start,
          children: [
            ChatBubble(message: data["message"]),
            SizedBox(height: 5),
            Text(
              DateFormat('hh:mm a').format(
                (data["timestamp"] as Timestamp)
                    .toDate(), // Convert to DateTime
              ),
              style: TextStyle(
                color: Colors.grey,
                fontSize: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
