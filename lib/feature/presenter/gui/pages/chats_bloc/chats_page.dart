// ignore_for_file: unused_element, unused_field, prefer_final_fields, no_leading_underscores_for_local_identifiers

import 'package:anihan_app/common/enum_files.dart';
import 'package:anihan_app/feature/data/models/api/firebase_model.dart';
import 'package:anihan_app/feature/presenter/gui/pages/chats_bloc/chats_page_bloc.dart';
import 'package:anihan_app/feature/presenter/gui/routers/app_routers.dart';
import 'package:anihan_app/feature/presenter/gui/widgets/addons/custom_alert_dialog.dart';
import 'package:anihan_app/feature/presenter/gui/widgets/debugger/logger_debugger.dart';
import 'package:auto_route/auto_route.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';

@RoutePage()
class ChatsPage extends StatefulWidget {
  final String? uid;
  const ChatsPage({this.uid, super.key});
  @override
  State<ChatsPage> createState() => _ChatsPageState();
}

class _ChatsPageState extends State<ChatsPage> with LoggerEvent {
  // final _bloc = getIt<ChatsPageBloc>();
  int _selectedIndex = 2;
  bool isFriendsExpanded = true;
  bool isFriendsSuggestionExpanded = true;
  bool isLoading = false;

  static const List<ChatItem> chatItems = [];
  List<FirebaseDataModel> users = [];
  List<FirebaseDataModel> requestedUsers = [];

  List<Map<String, dynamic>> friendRequestsMapList = [];
  List<Map<String, dynamic>> friendSuggestionsMapList = [];

  List<String> _friendSuggestions = [];

  String _searchQuery = '';

  bool searchEmpty = true;

  List<FirebaseDataModel?> friends = [];
  List<FirebaseDataModel?> notFriends = [];
  List<FirebaseDataModel> searchData = [];
  final logger = Logger();

  @override
  void initState() {
    super.initState();
    context
        .read<ChatsPageBloc>()
        .add(GetUserListEvent(currentUserId: widget.uid!));

    // _bloc.add(GetUserListEvent());
  }

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
        context.read<ChatsPageBloc>().add(SearchFriendEvent(_searchQuery));
      });
    } else {
      setState(() {
        searchEmpty = true;
        friends = [];
        notFriends = [];
        context
            .read<ChatsPageBloc>()
            .add(GetUserListEvent(currentUserId: widget.uid!));
      });
    }
  }

  void onSearchFunction() {
    // _bloc.add(SearchFriendEvent(_searchQuery));
    context.read<ChatsPageBloc>().add(SearchFriendEvent(_searchQuery));
  }

  void addFriendFunction(String userId) {
    context.read<ChatsPageBloc>().add(AddingFriendEvent(userId, widget.uid!));
    // logger.d(userId);
  }

  void _onChatMessage(String userId) {
    AutoRouter.of(context).push(ChatWithRoute(friendId: userId));
  }

  Widget showFriendsAndNotFriends(Size size) {
    double _width = size.width;
    double _height = size.height;
    return Column(
      children: [
        const SizedBox(
          height: 12,
        ),
        Container(
          width: _width,
          padding: const EdgeInsets.symmetric(horizontal: 18),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              //title
              const Text(
                "Friends",
                style: TextStyle(fontSize: 18),
              ),
              IconButton(
                  onPressed: () {
                    setState(() {
                      isFriendsExpanded = !isFriendsExpanded;
                    });
                  },
                  icon: Icon(
                    !isFriendsExpanded
                        ? Icons.arrow_forward_ios_outlined
                        : Icons.keyboard_arrow_down,
                    size: 18,
                  ))
            ],
          ),
        ),
        if (isFriendsExpanded)
          SizedBox(
            // color: Colors.red,
            width: _width,
            child: friends.isNotEmpty
                ? ShowFriendListToChat(
                    widget.uid!,
                    notFriends,
                    onChat: _onChatMessage,
                  )
                : Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Container(
                      width: _width,
                      height: _height * 0.2,
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: const Color(0xFFF1E7F5),
                        boxShadow: [
                          BoxShadow(
                            color:
                                Colors.black.withOpacity(0.1), // Shadow color
                            offset: const Offset(0, 4),
                            blurRadius: 8, // Spread of the shadow
                            spreadRadius: 1, // How much the shadow spreads
                          ),
                        ],
                      ),
                      child: const Center(
                        child: Text(
                          "You are not following anyone yet. Start exploring to follow interesting profiles!",
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
          ),
        Container(
          width: _width,
          padding: const EdgeInsets.symmetric(horizontal: 18),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              //title
              const Text(
                "Friends Suggestions",
                style: TextStyle(fontSize: 18),
              ),
              IconButton(
                  onPressed: () {
                    setState(() {
                      isFriendsSuggestionExpanded =
                          !isFriendsSuggestionExpanded;
                    });
                  },
                  icon: Icon(
                    !isFriendsSuggestionExpanded
                        ? Icons.arrow_forward_ios_outlined
                        : Icons.keyboard_arrow_down,
                    size: 18,
                  ))
            ],
          ),
        ),
        if (isFriendsSuggestionExpanded)
          SizedBox(
            // color: Colors.red,
            width: _width,
            // height: _height,
            child: notFriends.isNotEmpty
                ? FriendsSuggestions(
                    widget.uid!,
                    notFriends,
                    addFriendFunction: addFriendFunction,
                  )
                : Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Container(
                      width: _width,
                      height: _height * 0.2,
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: const Color(0xFFF1E7F5),
                        boxShadow: [
                          BoxShadow(
                            color:
                                Colors.black.withOpacity(0.1), // Shadow color
                            offset: const Offset(0, 4),
                            blurRadius: 8, // Spread of the shadow
                            spreadRadius: 1, // How much the shadow spreads
                          ),
                        ],
                      ),
                      child: const Center(
                        child: Text(
                          "It looks like there is no friend suggestions. Invite some friends to get started.",
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final double _width = MediaQuery.of(context).size.width;
    final double _height = MediaQuery.of(context).size.height;
    return Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(60.0),
          child: CustomAppBar(
            ChatsPageBloc(),
            valueString: _searchQuery,
            isSearching: searchEmpty,
            onChanged: (value) => onChange(value),
            onSearchFunction: onSearchFunction,
          ),
        ),
        body: SingleChildScrollView(
          child: BlocBuilder<ChatsPageBloc, ChatsPageState>(
            builder: (context, state) {
              // logger.d(state);

              if (state is ChatsPageLoadingState) {
                return SizedBox(
                  width: _width,
                  height: _height,
                  child: const Center(
                    child: CircularProgressIndicator(
                      color: Colors.orange,
                    ),
                  ),
                );
              }
              if (state is ChatsPageSuccessState) {
                friendRequestsMapList = state.data["friendRequests"]!;
                friendSuggestionsMapList = state.data["friendSuggestions"]!;

                users = friendSuggestionsMapList
                    .map((entry) => FirebaseDataModel(
                          key: entry[
                              "userId"], // Assuming "userId" is stored in each entry
                          value: Map<String, dynamic>.from(entry["userInfo"]),
                        ))
                    .toList();
                requestedUsers = friendRequestsMapList
                    .map((entry) => FirebaseDataModel(
                        key: entry["requestId"], value: entry))
                    .toList();

                friends = requestedUsers
                    .where((e) => e.value["requestFrom"] == widget.uid)
                    .map((e) {
                  return FirebaseDataModel(
                      key: e.key,
                      value: e.value["userInfo"],
                      status: e.value["status"]);
                }).toList();

                // logger.d(friends);
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
                // logger.d(notFriends);

                return Column(
                  children: [
                    const SizedBox(
                      height: 12,
                    ),
                    Container(
                      width: _width,
                      padding: const EdgeInsets.symmetric(horizontal: 18),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          //title
                          const Text(
                            "Friends",
                            style: TextStyle(fontSize: 18),
                          ),
                          IconButton(
                              onPressed: () {
                                setState(() {
                                  isFriendsExpanded = !isFriendsExpanded;
                                });
                              },
                              icon: Icon(
                                !isFriendsExpanded
                                    ? Icons.arrow_forward_ios_outlined
                                    : Icons.keyboard_arrow_down,
                                size: 18,
                              ))
                        ],
                      ),
                    ),
                    if (isFriendsExpanded)
                      SizedBox(
                        // color: Colors.red,
                        width: _width,
                        child: friends.isNotEmpty
                            ? ShowFriendListToChat(
                                widget.uid!,
                                friends,
                                onChat: _onChatMessage,
                              )
                            : Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 24.0),
                                child: Container(
                                  width: _width,
                                  height: _height * 0.2,
                                  padding: const EdgeInsets.all(18),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    color: const Color(0xFFF1E7F5),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black
                                            .withOpacity(0.1), // Shadow color
                                        offset: const Offset(0, 4),
                                        blurRadius: 8, // Spread of the shadow
                                        spreadRadius:
                                            1, // How much the shadow spreads
                                      ),
                                    ],
                                  ),
                                  child: const Center(
                                    child: Text(
                                      "You are not following anyone yet. Start exploring to follow interesting profiles!",
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                              ),
                      ),
                    Container(
                      width: _width,
                      padding: const EdgeInsets.symmetric(horizontal: 18),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          //title
                          const Text(
                            "Friends Suggestions",
                            style: TextStyle(fontSize: 18),
                          ),
                          IconButton(
                              onPressed: () {
                                setState(() {
                                  isFriendsSuggestionExpanded =
                                      !isFriendsSuggestionExpanded;
                                });
                              },
                              icon: Icon(
                                !isFriendsSuggestionExpanded
                                    ? Icons.arrow_forward_ios_outlined
                                    : Icons.keyboard_arrow_down,
                                size: 18,
                              ))
                        ],
                      ),
                    ),
                    if (isFriendsSuggestionExpanded)
                      SizedBox(
                        // color: Colors.red,
                        width: _width,
                        // height: _height,
                        child: notFriends.isNotEmpty
                            ? FriendsSuggestions(
                                widget.uid!,
                                notFriends,
                                addFriendFunction: addFriendFunction,
                              )
                            : Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 24.0),
                                child: Container(
                                  width: _width,
                                  height: _height * 0.2,
                                  padding: const EdgeInsets.all(18),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    color: const Color(0xFFF1E7F5),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black
                                            .withOpacity(0.1), // Shadow color
                                        offset: const Offset(0, 4),
                                        blurRadius: 8, // Spread of the shadow
                                        spreadRadius:
                                            1, // How much the shadow spreads
                                      ),
                                    ],
                                  ),
                                  child: const Center(
                                    child: Text(
                                      "It looks like there is no friend suggestions. Invite some friends to get started.",
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                              ),
                      ),
                  ],
                );
              }

              if (state is ChatsPageSearchSuccessState) {
                searchData = state.data;
                if (searchData.isEmpty) {
                  return const Center(
                    child: Text("No Available users"),
                  );
                } else {
                  friends = [];
                  notFriends = [];
                  friends = searchData
                      .map((e) {
                        if (e.key == widget.uid) {
                          return null;
                        } else {
                          if (e.value.containsKey('friends')) {
                            return FirebaseDataModel(
                                key: e.key, value: e.value);
                          } else {
                            return null;
                          }
                        }
                      })
                      .where((element) => element != null)
                      .toList();

                  notFriends = searchData
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
                }

                return Column(
                  children: [
                    const SizedBox(
                      height: 12,
                    ),
                    Container(
                      width: _width,
                      padding: const EdgeInsets.symmetric(horizontal: 18),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          //title
                          const Text(
                            "Friends",
                            style: TextStyle(fontSize: 18),
                          ),
                          IconButton(
                              onPressed: () {
                                setState(() {
                                  isFriendsExpanded = !isFriendsExpanded;
                                });
                              },
                              icon: Icon(
                                !isFriendsExpanded
                                    ? Icons.arrow_forward_ios_outlined
                                    : Icons.keyboard_arrow_down,
                                size: 18,
                              ))
                        ],
                      ),
                    ),
                    if (isFriendsExpanded)
                      SizedBox(
                        // color: Colors.red,
                        width: _width,
                        child: friends.isNotEmpty
                            ? ShowFriendListToChat(
                                widget.uid!,
                                notFriends,
                                onChat: _onChatMessage,
                              )
                            : Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 24.0),
                                child: Container(
                                  width: _width,
                                  height: _height * 0.2,
                                  padding: const EdgeInsets.all(18),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    color: const Color(0xFFF1E7F5),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black
                                            .withOpacity(0.1), // Shadow color
                                        offset: const Offset(0, 4),
                                        blurRadius: 8, // Spread of the shadow
                                        spreadRadius:
                                            1, // How much the shadow spreads
                                      ),
                                    ],
                                  ),
                                  child: const Center(
                                    child: Text(
                                      "You are not following anyone yet. Start exploring to follow interesting profiles!",
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                              ),
                      ),
                    Container(
                      width: _width,
                      padding: const EdgeInsets.symmetric(horizontal: 18),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          //title
                          const Text(
                            "Friends Suggestions",
                            style: TextStyle(fontSize: 18),
                          ),
                          IconButton(
                              onPressed: () {
                                setState(() {
                                  isFriendsSuggestionExpanded =
                                      !isFriendsSuggestionExpanded;
                                });
                              },
                              icon: Icon(
                                !isFriendsSuggestionExpanded
                                    ? Icons.arrow_forward_ios_outlined
                                    : Icons.keyboard_arrow_down,
                                size: 18,
                              ))
                        ],
                      ),
                    ),
                    if (isFriendsSuggestionExpanded)
                      SizedBox(
                        // color: Colors.red,
                        width: _width,
                        // height: _height,
                        child: notFriends.isNotEmpty
                            ? FriendsSuggestions(
                                widget.uid!,
                                notFriends,
                                addFriendFunction: addFriendFunction,
                              )
                            : Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 24.0),
                                child: Container(
                                  width: _width,
                                  height: _height * 0.2,
                                  padding: const EdgeInsets.all(18),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    color: const Color(0xFFF1E7F5),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black
                                            .withOpacity(0.1), // Shadow color
                                        offset: const Offset(0, 4),
                                        blurRadius: 8, // Spread of the shadow
                                        spreadRadius:
                                            1, // How much the shadow spreads
                                      ),
                                    ],
                                  ),
                                  child: const Center(
                                    child: Text(
                                      "It looks like there is no friend suggestions. Invite some friends to get started.",
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                              ),
                      ),
                  ],
                );
              }

              if (state is FriendRequestSuccessState) {
                // logger.d(notFriends);

                return showFriendsAndNotFriends(Size(_width, _height));
              }

              if (state is FriendRequestErrorState) {
                return showFriendsAndNotFriends(Size(_width, _height));
              }

              return Container();
            },
          ),
        ));
  }
}

class CustomAppBar extends StatelessWidget {
  final Function(String value) onChanged;
  final String valueString;
  final ChatsPageBloc bloc;
  final bool isSearching;

  final void Function() onSearchFunction;

  const CustomAppBar(this.bloc,
      {required this.valueString,
      required this.onChanged,
      required this.isSearching,
      required this.onSearchFunction,
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
                          onPressed: onSearchFunction,
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
            icon: const Icon(Icons.message), // New chats icon
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
  // final ChatsPageBloc bloc;
  final String uid;
  final List<FirebaseDataModel?> users;
  final Function(String userId) addFriendFunction;

  const FriendsSuggestions(this.uid, this.users,
      {required this.addFriendFunction, super.key});

  @override
  Widget build(BuildContext context) {
    final logger = Logger();
    // print(users);

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        child: Column(
          children: users.map((user) {
            return Container(
              // color: Colors.green,
              padding: const EdgeInsets.all(8.0),
              margin:
                  const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
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
                      Text(user!.value['fullName']),
                    ],
                  ),
                  TextButton(
                    onPressed: () {
                      var userId = user.key;
                      logger.d(userId);

                      addFriendFunction(userId);
                    },
                    child: const Text("add"),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}

class ShowFriendListToChat extends StatelessWidget {
  final String uid;
  final List<FirebaseDataModel?> users;
  final Function(String userId) onChat;

  const ShowFriendListToChat(this.uid, this.users,
      {super.key, required this.onChat});

  @override
  Widget build(BuildContext context) {
    final logger = Logger();
    // var usersInfo =
    // final double _width = MediaQuery.of(context).size.width;
    // final double _height = MediaQuery.of(context).size.height;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: users.map((friend) {
          if (friend == null) {
            return Container();
          } else if (friend.status == null) {
            logger.d("${friend.key}\n$uid");
            return Visibility(
              visible: uid != friend.key,
              child: Container(
                padding: const EdgeInsets.all(12.0),
                margin:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
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
                        Text(friend.value['fullName']),
                      ],
                    ),
                    const CircularProgressIndicator()
                  ],
                ),
              ),
            );
          } else {
            return Visibility(
              visible: uid != friend.key,
              child: GestureDetector(
                onTap: () {
                  logger.d("TAP: ${friend.key}");

                  if (friend.status == FriendStatus.pending.name ||
                      friend.status == FriendStatus.rejected.name) {
                    showDialog(
                        context: context,
                        builder: (context) => CustomAlertDialog(
                            colorMessage: Colors.red,
                            onPressedCloseBtn: () {
                              Navigator.pop(context);
                            },
                            title: "Information",
                            child: const Text(
                                "Oops! I think your still not a friend yet.")));
                  }

                  if (friend.status == FriendStatus.accepted.name) {
                    //openCHat
                    onChat(friend.key);
                  }
                },
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
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.people),
                          const SizedBox(width: 16.0),
                          Text(friend.value['fullName']),
                        ],
                      ),
                      Text(
                        "${friend.status}",
                        style: TextStyle(
                            color: friend.status! == FriendStatus.accepted.name
                                ? Colors.green
                                : friend.status! == FriendStatus.rejected.name
                                    ? Colors.red
                                    : Colors.orange),
                      )
                    ],
                  ),
                ),
              ),
            );
          }
        }).toList(),
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
