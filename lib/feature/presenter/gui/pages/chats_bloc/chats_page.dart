// ignore_for_file: unused_element, unused_field, prefer_final_fields

import 'package:anihan_app/common/app_module.dart';
import 'package:anihan_app/feature/data/models/api/firebase_model.dart';
import 'package:anihan_app/feature/presenter/gui/pages/chats_bloc/chats_page_bloc.dart';
import 'package:anihan_app/feature/presenter/gui/widgets/debugger/logger_debugger.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

@RoutePage()
class ChatsPage extends StatefulWidget {
  final String? uid;
  const ChatsPage({this.uid, super.key});
  @override
  State<ChatsPage> createState() => _ChatsPageState();
}

class _ChatsPageState extends State<ChatsPage> with LoggerEvent {
  final _bloc = getIt<ChatsPageBloc>();
  int _selectedIndex = 2;
  static const List<ChatItem> chatItems = [];
  List<FirebaseDataModel> users = [];

  List<String> _friendSuggestions = [];

  String _searchQuery = '';

  bool searchEmpty = true;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    debug("Selected index: $index");
  }

  void onChange(String value) {
    logger.d(value);

    setState(() {
      _searchQuery = value;
    });

    if (value != "") {
      setState(() {
        searchEmpty = false;
      });
    } else {
      setState(() {
        searchEmpty = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ChatsPageBloc()..add(GetUserListEvent()),
      child: Scaffold(
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(60.0),
            child: CustomAppBar(
              _bloc,
              valueString: _searchQuery,
              isSearching: searchEmpty,
              onChanged: (value) => onChange(value),
            ),
          ),
          body: BlocBuilder<ChatsPageBloc, ChatsPageState>(
            builder: (context, state) {
              List<FirebaseDataModel?> friends = [];
              List<FirebaseDataModel?> notFriends = [];
              List<FirebaseDataModel?> searchData = [];
              logger.d(state);
              if (state is ChatsPageSuccessState) {
                users = state.data;

                friends = users
                    .map((e) {
                      if (e.key == widget.uid) {
                        return null;
                      } else {
                        if (e.value.containsKey('friends')) {
                          return FirebaseDataModel(key: e.key, value: e.value);
                        } else {
                          return null;
                        }
                      }
                    })
                    .where((element) => element != null)
                    .toList();

                notFriends = users
                    .map((e) {
                      if (e.key == widget.uid) {
                        return null;
                      }
                      if (e.value.containsKey('friends')) {
                        return null;
                      } else {
                        var firebaseData =
                            FirebaseDataModel(key: e.key, value: e.value);
                        return firebaseData;
                      }
                    })
                    .where((element) => element != null)
                    .toList();

                logger.d(friends);
                logger.d(notFriends);
              }

              if (state is ChatsPageSearchSuccessState) {
                logger.e(state);
                searchData = state.data;
              }
              return friends.isEmpty && notFriends.isNotEmpty
                  ?
                  //SHOWIGN SUGGESTIONS
                  FriendsSuggestions(_bloc, widget.uid!, friends)
                  :
                  //YOU CAN ADD FRIENDS HERE PAREN
                  friends.isNotEmpty && notFriends.isNotEmpty
                      ?
                      //MUST ADDING FRIENDS
                      ShowFriendListToChat(widget.uid!, notFriends)
                      : searchData.isNotEmpty
                          ? const Center(
                              child: Text("Search"),
                            )
                          : const Center(
                              child: CircularProgressIndicator(),
                            );
            },
          )),
    );
  }
}

class CustomAppBar extends StatelessWidget {
  final Function(String value) onChanged;
  final String valueString;
  final ChatsPageBloc bloc;
  final bool isSearching;

  const CustomAppBar(this.bloc,
      {required this.valueString,
      required this.onChanged,
      required this.isSearching,
      super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      title: Row(
        children: [
          const SizedBox(width: 10),
          Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 8.0),
              child: TextField(
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(vertical: 12.0),
                  hintText: _ChatsPageState.chatItems.isEmpty
                      ? 'Search Friends'
                      : 'Search Chats', // Updated placeholder text
                  prefixIcon: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12.0),
                    child: Icon(Icons.search, size: 24.0), // Search icon
                  ),
                  prefixIconConstraints: const BoxConstraints(
                    minWidth: 40,
                    minHeight: 40,
                  ),
                  suffixIcon: !isSearching
                      ? TextButton(
                          onPressed: () {
                            bloc.add(SearchFriendEvent(valueString));
                          },
                          child: const Text('search'),
                        )
                      : null,
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    borderSide: const BorderSide(
                      color: Colors.black,
                      width: 1.0,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    borderSide: const BorderSide(
                      color: Colors.green,
                      width: 2.0,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    borderSide: const BorderSide(
                      color: Colors.black,
                      width: 1.0,
                    ),
                  ),
                ),
                onChanged: (value) => onChanged(value),
              ),
            ),
          ),
          const SizedBox(width: 10),
          IconButton(
            icon: const Icon(Icons.chat_rounded), // New chats icon
            onPressed: () {
              // Placeholder for future chats function
            },
          ),
        ],
      ),
      backgroundColor: Theme.of(context).colorScheme.primary,
      elevation: 0,
    );
  }
}

//showing suggestions...

class FriendsSuggestions extends StatelessWidget {
  final ChatsPageBloc bloc;
  final String uid;
  final List<FirebaseDataModel?> users;

  const FriendsSuggestions(this.bloc, this.uid, this.users, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 12,
          ),
          const Text(
            "Friends Suggestions",
            style: TextStyle(fontSize: 18),
          ),
          const SizedBox(
            height: 12,
          ),
          Expanded(
            child: ListView.builder(
                itemCount: users.length,
                itemBuilder: (context, index) {
                  return Container(
                    padding: const EdgeInsets.all(12.0),
                    margin: const EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 16.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 6.0,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.people),
                            const SizedBox(width: 16.0),
                            Text(users[index]!.value['fullName']),
                          ],
                        ),
                        TextButton(
                            onPressed: () {
                              bloc.add(
                                  AddingFriendEvent(uid, users[index]!.key));
                            },
                            child: const Text("ADD"))
                      ],
                    ),
                  );
                }),
          ),
        ],
      ),
    );
  }
}

class ShowFriendListToChat extends StatelessWidget {
  final String uid;
  final List<FirebaseDataModel?> users;
  const ShowFriendListToChat(this.uid, this.users, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 12,
          ),
          const Text(
            "Friends",
            style: TextStyle(fontSize: 18),
          ),
          const SizedBox(
            height: 12,
          ),
          Expanded(
            child: ListView.builder(
                itemCount: users.length,
                itemBuilder: (context, index) {
                  return Visibility(
                    visible: uid != users[index]!.key,
                    child: Container(
                      padding: const EdgeInsets.all(12.0),
                      margin: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 16.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 6.0,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const Icon(Icons.people),
                          const SizedBox(width: 16.0),
                          Text(users[index]!.value['fullName']),
                        ],
                      ),
                    ),
                  );
                }),
          ),
        ],
      ),
    );
  }
}

// Chat List
class ChatList extends StatelessWidget {
  final String query;
  final List<ChatItem> chatItems;
  final List<FirebaseDataModel> onlineUsers;
  final bool isSearchEmpty;
  const ChatList(
      {required this.query,
      required this.chatItems,
      required this.onlineUsers,
      required this.isSearchEmpty,
      super.key});

  DateTime parseTimeString(String time) {
    final now = DateTime.now();

    if (time.contains('minutes ago')) {
      final minutes = int.parse(time.split(' ')[0]);
      return now.subtract(Duration(minutes: minutes));
    } else if (time.contains('hour ago') || time.contains('hours ago')) {
      final hours = int.parse(time.split(' ')[0]);
      return now.subtract(Duration(hours: hours));
    } else if (time.contains('Yesterday')) {
      return DateTime(now.year, now.month, now.day - 1);
    } else if (time.contains('days ago')) {
      final days = int.parse(time.split(' ')[0]);
      return DateTime(now.year, now.month, now.day - days);
    }

    return now;
  }

  @override
  Widget build(BuildContext context) {
    // List<ChatItem> chatItems = [
    //   ChatItem(
    //     imageUrl: 'https://example.com/profile1.jpg',
    //     isOnline: true,
    //     name: 'Vedanta',
    //     recentMessage: 'Meron kaming stock ng bigas ngayon',
    //     dateTime: parseTimeString('10:30 AM'),
    //     isUnread: true,
    //     isUserMessage: true,
    //   ),
    //   ChatItem(
    //     imageUrl: 'https://example.com/profile2.jpg',
    //     isOnline: false,
    //     name: 'John Cena',
    //     recentMessage: 'OFfer ko sayo 250 per kilo?',
    //     dateTime: parseTimeString('08:15 AM'),
    //     isUnread: false,
    //     isUserMessage: false,
    //   ),
    //   ChatItem(
    //     imageUrl: 'https://example.com/profile3.jpg',
    //     isOnline: true,
    //     name: 'Jane Doe',
    //     recentMessage: 'Let\'s meet tomorrow at the office.',
    //     dateTime: parseTimeString('Yesterday'),
    //     isUnread: false,
    //     isUserMessage: true,
    //   ),
    //   ChatItem(
    //     imageUrl: 'https://example.com/profile4.jpg',
    //     isOnline: false,
    //     name: 'Michael Scott',
    //     recentMessage: 'That\'s what she said!',
    //     dateTime: parseTimeString('2 days ago'),
    //     isUnread: true,
    //     isUserMessage: true,
    //   ),
    //   ChatItem(
    //     imageUrl: 'https://example.com/profile5.jpg',
    //     isOnline: true,
    //     name: 'Dwight Schrute',
    //     recentMessage: 'Beets, bears, Battlestar Galactica.',
    //     dateTime: parseTimeString('10:45 AM'),
    //     isUnread: false,
    //     isUserMessage: false,
    //   ),
    //   ChatItem(
    //     imageUrl: 'https://example.com/profile6.jpg',
    //     isOnline: false,
    //     name: 'Pam Beesly',
    //     recentMessage: 'Can you send me the files?',
    //     dateTime: parseTimeString('1 hour ago'),
    //     isUnread: true,
    //     isUserMessage: true,
    //   ),
    //   ChatItem(
    //     imageUrl: 'https://example.com/profile7.jpg',
    //     isOnline: true,
    //     name: 'Jim Halpert',
    //     recentMessage: 'Pranks on Dwight are the best.',
    //     dateTime: parseTimeString('30 minutes ago'),
    //     isUnread: true,
    //     isUserMessage: true,
    //   ),
    //   ChatItem(
    //     imageUrl: 'https://example.com/profile8.jpg',
    //     isOnline: false,
    //     name: 'Stanley Hudson',
    //     recentMessage: 'I\'ll be in Florida for the next week.',
    //     dateTime: parseTimeString('3 days ago'),
    //     isUnread: false,
    //     isUserMessage: false,
    //   ),
    //   ChatItem(
    //     imageUrl: 'https://example.com/profile9.jpg',
    //     isOnline: true,
    //     name: 'Ryan Howard',
    //     recentMessage: 'The temp is the boss now.',
    //     dateTime: parseTimeString('5 minutes ago'),
    //     isUnread: true,
    //     isUserMessage: true,
    //   ),
    //   ChatItem(
    //     imageUrl: 'https://example.com/profile10.jpg',
    //     isOnline: false,
    //     name: 'Kelly Kapoor',
    //     recentMessage: 'Fashion show at lunch?',
    //     dateTime: parseTimeString('4 days ago'),
    //     isUnread: false,
    //     isUserMessage: false,
    //   ),
    // ];

    // Sort chat items by their dateTime, most recent first
    chatItems.sort((a, b) => b.dateTime.compareTo(a.dateTime));
    if (isSearchEmpty) {
      if (chatItems.isEmpty) {
        return const Center(
          child: Text("No messages yet"),
        );
      } else {
        return ListView(children: chatItems);
      }
    } else {
      List<String> name = onlineUsers.map((e) {
        if (e.value['fullName'].toString().toLowerCase() ==
            query.toLowerCase()) {
          return e.value['fullName'].toString();
        }
        return "sdsf";
      }).toList();

      if (name.contains('query')) {
        name = name;
      }

      return ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: name.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(name[index]),
            onTap: () {
              // Handle friend selection
            },
          );
        },
      );
    }
  }
}

// Chat Item
class ChatItem extends StatelessWidget {
  final String imageUrl;
  final bool isOnline;
  final String name;
  final String recentMessage;
  final DateTime dateTime;
  final bool isUnread;
  final bool isUserMessage;

  const ChatItem({
    super.key,
    required this.imageUrl,
    required this.isOnline,
    required this.name,
    required this.recentMessage,
    required this.dateTime,
    required this.isUnread,
    required this.isUserMessage,
  });

  String formatTime(DateTime dateTime) {
    final now = DateTime.now();
    final timeFormat = DateFormat('hh:mm a');

    if (now.year == dateTime.year &&
        now.month == dateTime.month &&
        now.day == dateTime.day) {
      return timeFormat.format(dateTime);
    } else if (now.year == dateTime.year &&
        now.month == dateTime.month &&
        now.day - dateTime.day == 1) {
      return "Yesterday";
    } else {
      return "${now.difference(dateTime).inDays} days ago";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12.0),
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 6.0,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          ProfilePicture(imageUrl: imageUrl, isOnline: isOnline),
          const SizedBox(width: 16.0),
          Expanded(
            child: ChatDetails(
              name: name,
              recentMessage: recentMessage,
              isUnread: isUnread,
              isUserMessage: isUserMessage,
            ),
          ),
          const SizedBox(width: 16.0),
          TimeIndicator(
            time: formatTime(dateTime),
            isUnread: isUnread,
          ),
        ],
      ),
    );
  }
}

// Profile Picture with Status Indicator
class ProfilePicture extends StatelessWidget {
  final String imageUrl;
  final bool isOnline;

  const ProfilePicture({
    super.key,
    required this.imageUrl,
    required this.isOnline,
  });

  @override
  Widget build(BuildContext context) {
    final theme = ChatsPageTheme.of(context);

    return Stack(
      children: [
        CircleAvatar(
          radius: 30.0,
          backgroundImage: NetworkImage(imageUrl),
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: CircleAvatar(
            radius: 8.0,
            backgroundColor:
                isOnline ? theme.onlineStatusColor : theme.offlineStatusColor,
          ),
        ),
      ],
    );
  }
}

// Chat Details (Name and Recent Message)
class ChatDetails extends StatelessWidget {
  final String name;
  final String recentMessage;
  final bool isUnread;
  final bool isUserMessage;

  const ChatDetails({
    super.key,
    required this.name,
    required this.recentMessage,
    required this.isUnread,
    required this.isUserMessage,
  });

  @override
  Widget build(BuildContext context) {
    String displayMessage =
        isUserMessage ? "You: $recentMessage" : recentMessage;
    TextStyle messageStyle = Theme.of(context).textTheme.bodyMedium!;

    if (isUnread) {
      messageStyle = messageStyle.copyWith(fontWeight: FontWeight.bold);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          name,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 4.0),
        Text(
          displayMessage,
          style: messageStyle,
        ),
      ],
    );
  }
}

// Time Indicator and Unread Message Badge
class TimeIndicator extends StatelessWidget {
  final String time;
  final bool isUnread;

  const TimeIndicator({
    super.key,
    required this.time,
    required this.isUnread,
  });

  @override
  Widget build(BuildContext context) {
    TextStyle timeStyle = Theme.of(context).textTheme.titleMedium!;

    if (isUnread) {
      timeStyle = timeStyle.copyWith(fontWeight: FontWeight.bold);
    }

    return Text(
      time,
      style: timeStyle,
    );
  }
}

class ChatsPageTheme {
  final TextStyle unreadMessageStyle;
  final TextStyle readMessageStyle;
  final Color onlineStatusColor;
  final Color offlineStatusColor;
  final Color unreadOver24hrsBadgeColor;

  ChatsPageTheme({
    required this.unreadMessageStyle,
    required this.readMessageStyle,
    required this.onlineStatusColor,
    required this.offlineStatusColor,
    required this.unreadOver24hrsBadgeColor,
  });

  static ChatsPageTheme of(BuildContext context) {
    return ChatsPageTheme(
      unreadMessageStyle: const TextStyle(
        color: Colors.black87,
        fontWeight: FontWeight.bold,
      ),
      readMessageStyle: const TextStyle(
        color: Colors.black54,
        fontWeight: FontWeight.normal,
      ),
      onlineStatusColor: Colors.green,
      offlineStatusColor: Colors.grey,
      unreadOver24hrsBadgeColor: Colors.red,
    );
  }
}
