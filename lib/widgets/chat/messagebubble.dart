import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MessageBubble extends StatelessWidget {
  const MessageBubble(
      {Key? key,
      required this.message,
      required this.isMe,
      required this.userId, required this.userName})
      : super(key: key);
  final String message;
  final bool isMe;
  final String userId;
  final String userName;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        Container(
          width: 140,
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
          decoration: BoxDecoration(
            color: isMe ? Colors.grey[300] : Theme.of(context).accentColor,
            borderRadius: BorderRadius.only(
              topLeft: const Radius.circular(12),
              topRight: const Radius.circular(12),
              bottomLeft: !isMe ? Radius.zero : const Radius.circular(12),
              bottomRight: isMe ? Radius.zero : const Radius.circular(12),
            ),
          ),
          margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
          child: Column(
            crossAxisAlignment:
                isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: [
             
                    Text(
                      userName,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: isMe
                              ? Colors.black
                              : Theme.of(context)
                                  .accentTextTheme
                                  .titleMedium!
                                  .color),
                    ),
                  
              Text(
                message,
                textAlign: isMe ? TextAlign.end : TextAlign.start,
                style: TextStyle(
                    color: isMe
                        ? Colors.black
                        : Theme.of(context).accentTextTheme.titleMedium!.color),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
