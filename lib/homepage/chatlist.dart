import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'chats.dart';

class ChatroomsPage extends StatelessWidget {
  final String userId;

  ChatroomsPage({required this.userId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat'),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .collection('chats')
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          return ListView(
            children: snapshot.data!.docs.map((chatDoc) {
              return ListTile(
                title: Text(chatDoc.id),
                subtitle: FutureBuilder(
                  future: FirebaseFirestore.instance
                      .collection('chatrooms')
                      .doc(chatDoc.id)
                      .get(),
                  builder:
                      (context, AsyncSnapshot<DocumentSnapshot> chatSnapshot) {
                    if (!chatSnapshot.hasData) {
                      return Text('Loading...');
                    }
                    return Text("testing");
                    var chatData = chatSnapshot.data!.data();
                    //var participantNames = chatData?['participantNames'] ?? [];
                    //return Text(participantNames.join(', '));
                  },
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          ChatroomPage(chatroomId: chatDoc.id),
                    ),
                  );
                },
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
