// ignore_for_file: unused_field, library_private_types_in_public_api, use_super_parameters

import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';

class User {
  final String name;
  final bool isOnline;

  User(this.name, this.isOnline);
}

class Community {
  final String name;
  final int currentOnlineMembers;

  Community(this.name, this.currentOnlineMembers);
}

class WishlistItem {
  final String productName;
  final String location;
  final String imageUrl;

  WishlistItem(this.productName, this.location, this.imageUrl);
}

@RoutePage()
class WishListPage extends StatefulWidget {
  const WishListPage({super.key});
  @override
  _WishListPageState createState() => _WishListPageState();
}

class _WishListPageState extends State<WishListPage> {
  @override
  Widget build(BuildContext context) {
    List<User> users = [];

    List<Community> communities = [];
    List<WishlistItem> wishlistItems = [];
    final double _height = MediaQuery.of(context).size.height;
    final double _width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Text('Following/Wishlists')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              FollowingSection(users: users, communities: communities),
              // const SizedBox(height: 20.0),
              WishlistSection(
                wishlistItems: wishlistItems,
                size: Size(_width, _height),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class UpperBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  const UpperBar({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      title: Text(
        title,
        style: Theme.of(context).textTheme.displayLarge?.copyWith(
              color: Colors.white,
            ),
      ),
      centerTitle: true,
      actions: [
        IconButton(
          icon: const Icon(Icons.chat_bubble_outline),
          onPressed: () {
            // Action for the chat icon, for example, navigating to a chat page
          },
        ),
      ],
      backgroundColor: Theme.of(context).colorScheme.primary,
      elevation: 0,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class FollowingSection extends StatelessWidget {
  final List<User> users;
  final List<Community> communities;

  const FollowingSection(
      {Key? key, required this.users, required this.communities})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double _height = MediaQuery.of(context).size.height;
    final double _width = MediaQuery.of(context).size.width;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Users Section
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            'Following',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
        ),
        const SizedBox(
          height: 12,
        ),

        users.isNotEmpty
            ? SizedBox(
                height: 115.0, // Set the height for user list
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: users.length,
                  itemBuilder: (context, index) {
                    return _buildUserItem(context, users[index]);
                  },
                ),
              )
            : Align(
                alignment: Alignment.center,
                child: SizedBox(
                  width: _width * 0.7,
                  child: const Center(
                    child: Text(
                      "You are not following anyone yet. Start exploring to follow interesting profiles!",
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),

        const SizedBox(
          height: 12,
        ),

        const Divider(),

        // Communities Section
        const SizedBox(
          height: 12,
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            'Communities',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
        ),
        const SizedBox(
          height: 12,
        ),

        communities.isNotEmpty
            ? SizedBox(
                height: 115.0, // Set the height for community list
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: communities.length,
                  itemBuilder: (context, index) {
                    return _buildCommunityItem(context, communities[index]);
                  },
                ),
              )
            : Align(
                alignment: Alignment.center,
                child: SizedBox(
                  width: _width * 0.7,
                  child: const Center(
                    child: Text(
                      "You do not have any communities yet. Start exploring to follow interesting community!",
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
        const SizedBox(
          height: 12,
        ),
        const SizedBox(
          height: 12,
        ),
        const Divider(),
      ],
    );
  }

  Widget _buildUserItem(BuildContext context, User user) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          CircleAvatar(
            radius: 25.0,
            backgroundColor: Colors.grey[300],
            child: Icon(Icons.person, size: 30.0, color: Colors.grey[700]),
          ),
          const SizedBox(height: 5.0),
          Text(user.name, style: Theme.of(context).textTheme.bodyMedium),
          Text(user.isOnline ? 'Online' : 'Offline',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: user.isOnline ? Colors.green : Colors.red,
                  )),
        ],
      ),
    );
  }

  Widget _buildCommunityItem(BuildContext context, Community community) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          CircleAvatar(
            radius: 25.0,
            backgroundColor: Colors.grey[300],
            child: Icon(Icons.group, size: 30.0, color: Colors.grey[700]),
          ),
          const SizedBox(height: 5.0),
          Text(community.name, style: Theme.of(context).textTheme.bodyMedium),
          Text(
            '${community.currentOnlineMembers} online',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Colors.green,
                ),
          ),
        ],
      ),
    );
  }
}

class WishlistSection extends StatelessWidget {
  final List<WishlistItem> wishlistItems;
  final Size size;

  const WishlistSection(
      {Key? key, required this.wishlistItems, required this.size})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            'Wishlist',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
        ),
        wishlistItems.isNotEmpty
            ? GridView.builder(
                shrinkWrap:
                    true, // Necessary to make the GridView fit inside a Column
                physics:
                    const NeverScrollableScrollPhysics(), // Prevent GridView from scrolling independently
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3, // Number of columns in the grid
                  crossAxisSpacing: 10.0, // Space between columns
                  mainAxisSpacing: 10.0, // Space between rows
                  childAspectRatio: 0.75, // Adjust ratio to match your design
                ),
                itemCount: wishlistItems.length,
                itemBuilder: (context, index) {
                  return _buildWishlistItem(context, wishlistItems[index]);
                },
              )
            : Align(
                alignment: Alignment.center,
                child: SizedBox(
                  width: size.width * 0.7,
                  child: const Center(
                    child: Text(
                      "You do not have any wishlist, try adding one.",
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
      ],
    );
  }

  Widget _buildWishlistItem(BuildContext context, WishlistItem item) {
    return Column(
      children: [
        Container(
          height: 80.0,
          width: 80.0,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            image: DecorationImage(
              image: NetworkImage(item.imageUrl),
              fit: BoxFit.cover,
            ),
          ),
        ),
        const SizedBox(height: 8.0),
        Text(
          item.productName,
          style: Theme.of(context).textTheme.bodyMedium,
          overflow: TextOverflow.ellipsis, // Truncate if too long
        ),
        Text(
          item.location,
          style: Theme.of(context)
              .textTheme
              .titleMedium
              ?.copyWith(color: Colors.black54),
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}
