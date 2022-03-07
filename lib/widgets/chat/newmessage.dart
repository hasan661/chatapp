import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class NewMessage extends StatefulWidget {
  const NewMessage({Key? key}) : super(key: key);

  @override
  _NewMessageState createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> {
  final _controller = TextEditingController();
  var _enteredMessage = "";

  void _sendMessage() async{
    FocusScope.of(context).unfocus();
    final user=FirebaseAuth.instance.currentUser!;
    print(user);
    FirebaseFirestore.instance.collection("chat").add({
      "text": _enteredMessage,
      'createdAt': Timestamp.now(),
      "userId": user.uid
    });
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(
        top: 8,
      ),
      padding: const EdgeInsets.all(8),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              decoration:
                  const InputDecoration(label: Text("Send a message...")),
              onChanged: (newMessage) {
                setState(() {
                  _enteredMessage = newMessage;
                });
              },
            ),
          ),
          IconButton(
            onPressed: _enteredMessage.trim() == "" ? null : _sendMessage,
            icon: const Icon(Icons.send),
            color: Theme.of(context).primaryColor,
          )
        ],
      ),
    );
  }
}
