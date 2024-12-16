import 'package:flutter/material.dart';

class MessageToSellerWidget extends StatelessWidget {
  final TextEditingController messageController;
  const MessageToSellerWidget({super.key, required this.messageController});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: const EdgeInsets.all(12),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: TextField(
          controller: messageController,
          decoration: InputDecoration(
            hintText: "Please leave a message...",
            hintStyle: Theme.of(context).inputDecorationTheme.hintStyle,
            filled: true,
            fillColor: Theme.of(context).inputDecorationTheme.fillColor,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
          ),
          maxLines: 2,
        ),
      ),
    );
  }
}
