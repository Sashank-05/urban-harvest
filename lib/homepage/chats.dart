import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChatroomPage extends StatelessWidget {
  final String chatroomId;

  const ChatroomPage({super.key, required this.chatroomId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chatroom'),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('chatrooms')
            .doc(chatroomId)
            .collection('messages')
            .orderBy('timestamp', descending: true)
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          var messageDocs = snapshot.data!.docs;
          return ListView(
            reverse: true,
            children: messageDocs.map((messageDoc) {
              return ListTile(
                title: Text(messageDoc['text']),
                subtitle: Text(messageDoc['sender']),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
