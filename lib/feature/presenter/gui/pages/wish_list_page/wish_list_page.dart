// ignore_for_file: unused_field, library_private_types_in_public_api, use_super_parameters

import 'package:anihan_app/common/enum_files.dart';
import 'package:anihan_app/feature/presenter/gui/pages/wish_list_page/friends_bloc/friends_list_page_bloc.dart';
import 'package:anihan_app/feature/presenter/gui/pages/wish_list_page/wishlist_bloc/wish_list_page_bloc.dart';
import 'package:anihan_app/feature/presenter/gui/widgets/addons/custom_alert_dialog.dart';
import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';

import '../../../../../common/api_result.dart';
import '../../../../data/models/api/firebase_model.dart';
import '../../../../domain/entities/product_entity.dart';
import '../../widgets/products/product_favorite_cubit/product_card.dart';

class Community {
  final String name;
  final int currentOnlineMembers;

  Community(this.name, this.currentOnlineMembers);
}

@RoutePage()
class WishListPage extends StatefulWidget {
  final String? uid;
  const WishListPage({super.key, this.uid});
  @override
  _WishListPageState createState() => _WishListPageState();
}

class _WishListPageState extends State<WishListPage> {
  final logger = Logger();
  List<FirebaseDataModel> requestedUsers = [];
  List<FirebaseDataModel> friends = [];
  final _communityController = TextEditingController();

  @override
  void initState() {
    super.initState();

    context.read<WishListPageBloc>().add(GetWishListEvent());
    context.read<FriendsListPageBloc>().add(const GetUserListEvent());
  }

  @override
  Widget build(BuildContext context) {
    List<Community> communities = [];

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
              BlocBuilder<FriendsListPageBloc, FriendsListPageState>(
                builder: (context, state) {
                  if (state is FriendsListPageSuccessState) {
                    var data = state.data;
                    // logger.d(data);

                    requestedUsers = data
                        .where((status) =>
                            status['status'] == FriendStatus.accepted.name)
                        .map((entry) => FirebaseDataModel(
                            key: entry["requestId"], value: entry))
                        .toList();

                    friends = requestedUsers
                        .where((e) => e.value["requestFrom"] == widget.uid)
                        .map((e) {
                      // logger.d(
                      //     "IS USERNAME EQUAL: ${e.value["requestFrom"] == widget.uid}\n${e.value["requestFrom"]}");

                      return FirebaseDataModel(
                          key: e.key,
                          value: e.value["userInfo"],
                          status: e.value["status"]);
                    }).toList();

                    logger.d(friends);
                  }
                  return FollowingSection(
                    users: friends,
                    communities: communities,
                    communityController: _communityController,
                    saveCommunityNameFunction: () {
                      logger.d("HAhsHDASDS;A");
                      setState(() {
                        communities
                            .add(Community(_communityController.text, 0));
                        logger.d(communities);
                      });
                    },
                  );
                },
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
  final List<FirebaseDataModel> users;
  final List<Community> communities;
  final TextEditingController communityController;
  final void Function() saveCommunityNameFunction;

  const FollowingSection(
      {Key? key,
      required this.users,
      required this.communities,
      required this.communityController,
      required this.saveCommunityNameFunction})
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
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Communities',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextButton(
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return CustomAlertDialog(
                              colorMessage: Colors.green,
                              title: "Community",
                              actionLabel: "Save",
                              onPressedCloseBtn: () {
                                Navigator.of(context).pop();
                              },
                              actionCloseVisibility: true,
                              actionOkayVisibility: true,
                              onPressOkay: saveCommunityNameFunction,
                              child: TextFormField(
                                controller: communityController,
                                decoration: InputDecoration(
                                  labelText: 'Community Name:',
                                  labelStyle:
                                      Theme.of(context).textTheme.bodyMedium,
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter your community name.';
                                  }
                                  return null;
                                },
                              ));
                        });
                  },
                  child: Text(
                    'add',
                    style: Theme.of(context).textTheme.bodyMedium,
                  )),
            ),
          ],
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

  Widget _buildUserItem(BuildContext context, FirebaseDataModel user) {
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
          Text(user.value['fullName'],
              style: Theme.of(context).textTheme.bodyMedium),
          Text(true ? 'Online' : 'Offline',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: true ? Colors.green : Colors.red,
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
  final String label;
  final String uid;
  final List<ProductEntity> productEntityList;
  final Size size;

  WishlistSection(
      {Key? key,
      this.label = "Wishlist",
      required this.uid,
      required this.productEntityList,
      required this.size})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            label,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
        ),
        _buildProductGrid(context, productEntityList),
      ],
    );
  }

  Widget _buildProductGrid(BuildContext context, List<ProductEntity> products) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: products.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10.0,
          mainAxisSpacing: 10.0,
          childAspectRatio: 0.75,
        ),
        itemBuilder: (context, index) {
          return ProductCard(
            parentContext: context,
            uid: uid,
            product: products[index],
            dist: ProductDist.suggestions,
          );
        },
      ),
    );
  }
}
