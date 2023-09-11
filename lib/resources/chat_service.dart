import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:usersms/models/message.dart';

class Chatservice extends ChangeNotifier {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firebaseStore = FirebaseFirestore.instance;

  //send messages
  Future sendMessage(String receiverId, String message) async {
    //get user info
    final String currentUserId = _firebaseAuth.currentUser!.uid;
    final String senderEmail = _firebaseAuth.currentUser!.email.toString();
    final Timestamp timestamp = Timestamp.now();

    //create new message
    Message newMessage = Message(
        message: message,
        senderId: currentUserId,
        receiverId: receiverId,
        senderEmail: senderEmail,
        timestamp: timestamp);

    //create a chatroom id
    List<String> ids = [currentUserId, receiverId];
    ids.sort();
    String chatroomId = ids.join("_");

    //add new message to the database
    await _firebaseStore
        .collection("chat_room")
        .doc(chatroomId)
        .collection("messages")
        .add(newMessage.toMap());
  }

  //get messages
  Stream<QuerySnapshot> getMessages(String userId, String otheruserId) {
    List<String> ids = [userId, otheruserId];
    ids.sort();
    String chatroomId = ids.join("_");

    return _firebaseStore
        .collection("chat_room")
        .doc(chatroomId)
        .collection("messages")
        .orderBy("timestamp", descending: false)
        .snapshots();
  }
}
