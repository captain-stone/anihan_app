import 'package:anihan_app/feature/presenter/gui/pages/add_ons_blocs/check_friends_bloc/check_friends_bloc.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';

import '../pages/chats_bloc/blocs/chat_page/chats_page_bloc.dart';
import '../pages/order_details/order_page.dart';

class CustomAppBar extends StatelessWidget {
  final Function(String value) onChangeSearchCrops;

  // final void Function() onPressedIconUser;
  final void Function() onPressedIconJournal;
  final VoidCallback onPressedIconUser;
  final String uid;

  const CustomAppBar({
    super.key,
    required this.onChangeSearchCrops,
    required this.onPressedIconUser,
    required this.onPressedIconJournal,
    required this.uid,
  });

  @override
  Widget build(BuildContext context) {
    final logger = Logger();
    return AppBar(
      automaticallyImplyLeading: false,
      title: Row(
        children: [
          // SizedBox(width: 10),

          Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 8.0),
              child: TextField(
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(vertical: 12.0),
                  hintText: 'Search a Crop!',
                  prefixIcon: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12.0),
                    child: Icon(Icons.search, size: 24.0),
                  ),
                  prefixIconConstraints: const BoxConstraints(
                    minWidth: 40,
                    minHeight: 40,
                  ),
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
                onChanged: (value) => onChangeSearchCrops(value),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Stack(
            children: [
              IconButton(
                  icon: const Icon(Icons.people), onPressed: onPressedIconUser),
              Positioned(
                right: 4,
                top: 4,
                child: CircleAvatar(
                  radius: 8,
                  backgroundColor: Colors.red,
                  child: BlocBuilder<ChatsPageBloc, ChatsPageState>(
                    builder: (context, state) {
                      int numberOfRequest = 123;
                      // logger.d(state);
                      if (state is AllPendingRequestSuccessState) {
                        return Text(
                          '$numberOfRequest', // Notification count
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                          ),
                        );
                      }
                      return const Text(
                        '0', // Notification count
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
          IconButton(
              onPressed: onPressedIconJournal,
              icon: Icon(Icons.insert_drive_file_rounded)),
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () {
              // Placeholder for future cart function
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => OrdersPage(
                        uid: uid,
                      )));
            },
          ),
        ],
      ),
      backgroundColor: Theme.of(context).colorScheme.primary,
      elevation: 0,
    );
  }
}
