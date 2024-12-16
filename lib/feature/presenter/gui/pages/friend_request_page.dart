import 'package:anihan_app/feature/presenter/gui/pages/chats_bloc/chats_page.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import 'add_ons_blocs/check_friends_bloc/check_friends_bloc.dart';

@RoutePage()
class FriendRequestPage extends StatefulWidget {
  final List<Map<String, dynamic>> data;
  final CheckFriendsBloc checkFriendBuildContext;

  const FriendRequestPage(
      {super.key, required this.data, required this.checkFriendBuildContext});

  @override
  State<FriendRequestPage> createState() => _FriendRequestPageState();
}

class _FriendRequestPageState extends State<FriendRequestPage> {
  @override
  Widget build(BuildContext context) {
    final double _width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Friend Requests"),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
              children: widget.data.map((userData) {
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
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const CircleAvatar(
                    radius: 32,
                  ),
                  //const Icon(Icons.people), //change this as image
                  const SizedBox(width: 16.0),

                  SizedBox(
                    width: _width * 0.7,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 15,
                        ),
                        Text(userData['userInfo']['fullName']),
                        const SizedBox(
                          height: 12,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            SizedBox(
                              width: 125,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.blue,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(8))),
                                onPressed: () {
                                  var userWhoRequest = userData['requestedId'];

                                  widget.checkFriendBuildContext.add(
                                      UpdateFriendRequestEvent(
                                          "accepted", userWhoRequest));

                                  Navigator.of(context).pop();
                                },
                                child: const Text("Accept",
                                    style: TextStyle(color: Colors.white)),
                              ),
                            ),
                            SizedBox(
                              width: 125,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.grey,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(8))),
                                onPressed: () {
                                  var userWhoRequest = userData['requestedId'];

                                  widget.checkFriendBuildContext.add(
                                      UpdateFriendRequestEvent(
                                          "deny", userWhoRequest));
                                  Navigator.of(context).pop();

                                  // addFriendFunction(userId);
                                  // context.read<CheckFriendsBloc>()
                                },
                                child: const Text(
                                  "Delete",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                      ],
                    ),
                  )
                ],
              ),
            );
          }).toList()),
        ),
      ),
    );
  }
}
