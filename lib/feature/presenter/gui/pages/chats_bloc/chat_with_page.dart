import 'package:anihan_app/feature/domain/entities/message_data.dart';
import 'package:anihan_app/feature/presenter/gui/pages/chats_bloc/blocs/chat_with_page_bloc/chat_with_bloc.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';

import '../../../../../common/app_module.dart';

@RoutePage()
class ChatWithPage extends StatefulWidget {
  final String friendId;
  const ChatWithPage({super.key, required this.friendId});

  @override
  State<ChatWithPage> createState() => _ChatWithPageState();
}

class _ChatWithPageState extends State<ChatWithPage> {
  final TextEditingController _messageController = TextEditingController();
  List<MessageData> _messages = [];
  final Logger logger = Logger();

  final _chatWithBloc = getIt<ChatWithBloc>();

  void _sendMessage() {
    // if (_messageController.text.trim().isNotEmpty) {
    //   setState(() {
    //     _messages.add(_messageController.text.trim());
    //     _messageController.clear();
    //   });
    // }

    _chatWithBloc
        .add(SendAMessageEvent(widget.friendId, _messageController.text));
  }

  @override
  void initState() {
    super.initState();

    //get the chats using id.c

    _chatWithBloc.add(GetMessageEvent(widget.friendId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat'),
      ),
      body: Column(
        children: [
          // Messages List
          BlocBuilder<ChatWithBloc, ChatWithState>(
            bloc: _chatWithBloc,
            builder: (context, state) {
              logger.d(state);
              String friendId = "";

              if (state is ChatWithSuccessState) {
                _messages.clear();
                logger.d(state.messages);

                friendId = widget.friendId;

                _messages = state.messages;
                _messages.sort((a, b) => b.datetime.compareTo(a.datetime));

                return Expanded(
                  child: ListView.builder(
                    reverse: true,
                    itemCount: _messages.length,
                    itemBuilder: (context, index) {
                      final message = _messages[index];
                      final isFriendId = message.sender == friendId;
                      final time =
                          DateFormat('hh:mm a').format(message.datetime);
                      logger.e("SHITTTTT");
                      // final message = _messages[_messages.length - 1 - index];
                      // return Padding(
                      //   padding: const EdgeInsets.symmetric(
                      //       horizontal: 16.0, vertical: 8.0),
                      //   child: Align(
                      //     alignment: Alignment.centerRight,
                      //     child: Container(
                      //       decoration: BoxDecoration(
                      //         color: Colors.blue,
                      //         borderRadius: BorderRadius.circular(12),
                      //       ),
                      //       padding: const EdgeInsets.all(12),
                      //       child: Text(
                      //         message.message,
                      //         style: const TextStyle(
                      //           color: Colors.white,
                      //         ),
                      //       ),
                      //     ),
                      //   ),
                      // );

                      return Align(
                        alignment: isFriendId
                            ? Alignment.centerLeft
                            : Alignment.centerRight,
                        child: Container(
                          margin: const EdgeInsets.symmetric(
                              vertical: 4, horizontal: 8),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: !isFriendId ? Colors.blue : Colors.grey[300],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                message.message,
                                style: TextStyle(
                                  color:
                                      !isFriendId ? Colors.white : Colors.black,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                time,
                                style: TextStyle(
                                  color: !isFriendId
                                      ? Colors.white70
                                      : Colors.black54,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                );
              }

              if (state is ChatWithLoadingState) {
                return const Expanded(
                  child: CircularProgressIndicator(),
                );
              }

              return const Center(
                child: Text("No messages yet!"),
              );
            },
          ),
          // Message Input Field
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: const InputDecoration(
                      hintText: 'Type your message...',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.send),
                  color: Colors.blue,
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }
}
