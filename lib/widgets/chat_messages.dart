import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'message_bubble.dart';

class ChatMessages extends StatelessWidget {
  const ChatMessages({super.key});

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser!;

    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('chat')
          .orderBy(
            'createdAt',
            descending: true,
          )
          .snapshots(),
      builder: (ctx, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(
            child: Text('Nothing here...'),
          );
        }

        if (snapshot.hasError) {
          return const Center(
            child: Text('Something went wrong'),
          );
        }

        final loadedMessages = snapshot.data!.docs;

        return ListView.builder(
          padding: EdgeInsets.only(bottom: 40, left: 13, right: 13),
          reverse: true,
          itemCount: loadedMessages.length,
          itemBuilder: (ctx, index) {
            final message = loadedMessages[index].data();
            final nextMessage = index + 1 < loadedMessages.length
                ? loadedMessages[index + 1].data()
                : null;
            final currentMessageUserId = message['userId'];
            final nextMessageUserId =
                nextMessage != null ? nextMessage['userId'] : null;
            final nextUserIsSame = currentMessageUserId == nextMessageUserId;
            if (nextUserIsSame) {
              return MessageBubble.next(
                message: message['content'],
                isMe: currentUser.uid == currentMessageUserId,
              );
            } else {
              return MessageBubble.first(
                message: message['content'],
                isMe: currentUser.uid == currentMessageUserId,
                userImage: message['userImage'],
                username: message['username'],
              );
            }
          },
        );
      },
    );
  }
}
