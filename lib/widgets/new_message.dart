import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class NewMessage extends StatefulWidget {
  const NewMessage({super.key});

  @override
  State<NewMessage> createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> {
  late TextEditingController _messageController;

  @override
  void initState() {
    _messageController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _sendMessage() async {
    final enteredMessage = _messageController.text;
    _messageController.clear();

    if (enteredMessage.trim().isEmpty) {
      return;
    }

    final user = FirebaseAuth.instance.currentUser!;

    final userData = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();

    FirebaseFirestore.instance.collection('chat').add({
      'content': enteredMessage,
      'createdAt': Timestamp.now(),
      'userId': user.uid,
      'username': userData.data()!['username'],
      'userImage': userData.data()!['imageUrl'],
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 15,
        right: 1,
        bottom: 14,
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _messageController,
              textCapitalization: TextCapitalization.sentences,
              autocorrect: true,
              enableSuggestions: true,
              decoration: const InputDecoration(labelText: 'Send a message...'),
            ),
          ),
          IconButton(
            color: Theme.of(context).colorScheme.primary,
            onPressed: _sendMessage,
            icon: const Icon(Icons.send),
          ),
        ],
      ),
    );
  }
}
