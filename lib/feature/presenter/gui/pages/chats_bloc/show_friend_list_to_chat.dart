import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

import '../../../../../common/enum_files.dart';
import '../../../../data/models/api/firebase_model.dart';
import '../../widgets/addons/custom_alert_dialog.dart';

class ShowFriendListToChat extends StatelessWidget {
  final String uid;
  final List<FirebaseDataModel?> users;
  final Function(String userId, String name) onChat;

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
                  // logger.d("SADAJSDSADASDASFASF");
                  if (friend.status == FriendStatus.accepted.name) {
                    //openCHat
                    logger.w("HELLO");

                    logger.d(friend.value['fullName']);
                    onChat(friend.key, friend.value['fullName']);
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
