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
  int _selectedIndex = 2; // Default selected index is "Home"

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    print("Selected index: $index");
  }

  @override
  Widget build(BuildContext context) {
    List<User> users = [
      User('John Cena', true),
      User('Jane Doe', false),
      User('Mike Ross', true),
    ];

    List<Community> communities = [
      Community('Vedanta', 42),
      Community('Flutter Devs', 23),
      Community('Food Lovers', 12),
    ];
    List<WishlistItem> wishlistItems = [
      WishlistItem(
          'Rambutan', 'Tanauan City', 'https://example.com/rambutan.jpg'),
      WishlistItem(
          'Saging (Saba)', 'Tanauan City', 'https://example.com/banana.jpg'),
      WishlistItem('Langka', 'Tanauan City', 'https://example.com/langka.jpg'),
      WishlistItem('Durian', 'Davao City', 'https://example.com/durian.jpg'),
      WishlistItem('Mango', 'Guimaras', 'https://example.com/mango.jpg'),
    ];
    return Scaffold(
      appBar: AppBar(
          automaticallyImplyLeading: false, title: Text('Following/Wishlists')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              FollowingSection(users: users, communities: communities),
              const SizedBox(height: 20.0),
              WishlistSection(wishlistItems: wishlistItems),
            ],
          ),
        ),
      ),
      // bottomNavigationBar: BottomNavigationBar(
      //   items: const [
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.favorite),
      //       label: 'Wishlist',
      //     ),
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.message),
      //       label: 'Messages',
      //     ),
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.home),
      //       label: 'Home',
      //     ),
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.notifications),
      //       label: 'Notifications',
      //     ),
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.person),
      //       label: 'Account',
      //     ),
      //   ],
      //   currentIndex: _selectedIndex,
      //   selectedItemColor: Colors.green.shade700,
      //   unselectedItemColor: Colors.black54,
      //   backgroundColor: Colors.white,
      //   showSelectedLabels: true,
      //   showUnselectedLabels: false,
      //   type: BottomNavigationBarType.fixed,
      //   elevation: 8.0,
      //   onTap: _onItemTapped,
      // ),
    );
  }
}

class UpperBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  const UpperBar({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: IconButton(
        icon: Icon(Icons.arrow_back),
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
          icon: Icon(Icons.chat_bubble_outline),
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Users Section
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            'Following',
            style: Theme.of(context).textTheme.displayLarge,
          ),
        ),
        SizedBox(
          height: 115.0, // Set the height for user list
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: users.length,
            itemBuilder: (context, index) {
              return _buildUserItem(context, users[index]);
            },
          ),
        ),

        // Communities Section
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            'Communities',
            style: Theme.of(context).textTheme.displayLarge,
          ),
        ),
        SizedBox(
          height: 115.0, // Set the height for community list
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: communities.length,
            itemBuilder: (context, index) {
              return _buildCommunityItem(context, communities[index]);
            },
          ),
        ),
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

  const WishlistSection({Key? key, required this.wishlistItems})
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
            style: Theme.of(context).textTheme.displayLarge,
          ),
        ),
        GridView.builder(
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
