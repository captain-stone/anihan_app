// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

part of 'app_routers.dart';

abstract class _$AppRouters extends RootStackRouter {
  // ignore: unused_element
  _$AppRouters({super.navigatorKey});

  @override
  final Map<String, PageFactory> pagesMap = {
    AddProductFormRoute.name: (routeData) {
      final args = routeData.argsAs<AddProductFormRouteArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: AddProductFormPage(
          key: args.key,
          uid: args.uid,
        ),
      );
    },
    ChatWithRoute.name: (routeData) {
      final args = routeData.argsAs<ChatWithRouteArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: ChatWithPage(
          key: args.key,
          friendId: args.friendId,
          friendName: args.friendName,
        ),
      );
    },
    ChatsRoute.name: (routeData) {
      final args = routeData.argsAs<ChatsRouteArgs>(
          orElse: () => const ChatsRouteArgs());
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: ChatsPage(
          uid: args.uid,
          key: args.key,
        ),
      );
    },
    CommunityChatRoute.name: (routeData) {
      final args = routeData.argsAs<CommunityChatRouteArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: CommunityChatPage(
          ownerId: args.ownerId,
          communityName: args.communityName,
          key: args.key,
        ),
      );
    },
    CustomProductViewingRoute.name: (routeData) {
      final args = routeData.argsAs<CustomProductViewingRouteArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: CustomProductViewingPage(
          args.uid,
          key: args.key,
          product: args.product,
          height: args.height,
          width: args.width,
        ),
      );
    },
    FriendRequestRoute.name: (routeData) {
      final args = routeData.argsAs<FriendRequestRouteArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: FriendRequestPage(
          key: args.key,
          data: args.data,
          checkFriendBuildContext: args.checkFriendBuildContext,
        ),
      );
    },
    HomeNavigationRoute.name: (routeData) {
      final args = routeData.argsAs<HomeNavigationRouteArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: HomeNavigationPage(
          args.uid,
          key: args.key,
        ),
      );
    },
    HomeRoute.name: (routeData) {
      final args =
          routeData.argsAs<HomeRouteArgs>(orElse: () => const HomeRouteArgs());
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: HomePage(
          uid: args.uid,
          key: args.key,
        ),
      );
    },
    LoginRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const LoginPage(),
      );
    },
    MapRoute.name: (routeData) {
      final args = routeData.argsAs<MapRouteArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: MapPage(
          key: args.key,
          center: args.center,
          city: args.city,
        ),
      );
    },
    MyInformationFarmerRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const MyInformationFarmerPage(),
      );
    },
    MyInformationRoute.name: (routeData) {
      final args = routeData.argsAs<MyInformationRouteArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: MyInformationPage(
          args.uid,
          key: args.key,
        ),
      );
    },
    MyLikeRoute.name: (routeData) {
      final args = routeData.argsAs<MyLikeRouteArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: MyLikePage(
          key: args.key,
          uid: args.uid,
        ),
      );
    },
    NotificationRoute.name: (routeData) {
      final args = routeData.argsAs<NotificationRouteArgs>(
          orElse: () => const NotificationRouteArgs());
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: NotificationPage(
          uid: args.uid,
          key: args.key,
        ),
      );
    },
    RegistrationFormRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const RegistrationFormPage(),
      );
    },
    SellerRegistrationRoute.name: (routeData) {
      final args = routeData.argsAs<SellerRegistrationRouteArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: SellerRegistrationPage(
          uid: args.uid,
          fullName: args.fullName,
          phoneNumber: args.phoneNumber,
          key: args.key,
        ),
      );
    },
    ShowChatRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const ShowChatPage(),
      );
    },
    ShowProductByCategoryRoute.name: (routeData) {
      final args = routeData.argsAs<ShowProductByCategoryRouteArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: ShowProductByCategoryPage(
          key: args.key,
          uid: args.uid,
          label: args.label,
          productData: args.productData,
        ),
      );
    },
    WishListRoute.name: (routeData) {
      final args = routeData.argsAs<WishListRouteArgs>(
          orElse: () => const WishListRouteArgs());
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: WishListPage(
          key: args.key,
          uid: args.uid,
        ),
      );
    },
  };
}

/// generated route for
/// [AddProductFormPage]
class AddProductFormRoute extends PageRouteInfo<AddProductFormRouteArgs> {
  AddProductFormRoute({
    Key? key,
    required String? uid,
    List<PageRouteInfo>? children,
  }) : super(
          AddProductFormRoute.name,
          args: AddProductFormRouteArgs(
            key: key,
            uid: uid,
          ),
          initialChildren: children,
        );

  static const String name = 'AddProductFormRoute';

  static const PageInfo<AddProductFormRouteArgs> page =
      PageInfo<AddProductFormRouteArgs>(name);
}

class AddProductFormRouteArgs {
  const AddProductFormRouteArgs({
    this.key,
    required this.uid,
  });

  final Key? key;

  final String? uid;

  @override
  String toString() {
    return 'AddProductFormRouteArgs{key: $key, uid: $uid}';
  }
}

/// generated route for
/// [ChatWithPage]
class ChatWithRoute extends PageRouteInfo<ChatWithRouteArgs> {
  ChatWithRoute({
    Key? key,
    required String friendId,
    required String friendName,
    List<PageRouteInfo>? children,
  }) : super(
          ChatWithRoute.name,
          args: ChatWithRouteArgs(
            key: key,
            friendId: friendId,
            friendName: friendName,
          ),
          initialChildren: children,
        );

  static const String name = 'ChatWithRoute';

  static const PageInfo<ChatWithRouteArgs> page =
      PageInfo<ChatWithRouteArgs>(name);
}

class ChatWithRouteArgs {
  const ChatWithRouteArgs({
    this.key,
    required this.friendId,
    required this.friendName,
  });

  final Key? key;

  final String friendId;

  final String friendName;

  @override
  String toString() {
    return 'ChatWithRouteArgs{key: $key, friendId: $friendId, friendName: $friendName}';
  }
}

/// generated route for
/// [ChatsPage]
class ChatsRoute extends PageRouteInfo<ChatsRouteArgs> {
  ChatsRoute({
    String? uid,
    Key? key,
    List<PageRouteInfo>? children,
  }) : super(
          ChatsRoute.name,
          args: ChatsRouteArgs(
            uid: uid,
            key: key,
          ),
          initialChildren: children,
        );

  static const String name = 'ChatsRoute';

  static const PageInfo<ChatsRouteArgs> page = PageInfo<ChatsRouteArgs>(name);
}

class ChatsRouteArgs {
  const ChatsRouteArgs({
    this.uid,
    this.key,
  });

  final String? uid;

  final Key? key;

  @override
  String toString() {
    return 'ChatsRouteArgs{uid: $uid, key: $key}';
  }
}

/// generated route for
/// [CommunityChatPage]
class CommunityChatRoute extends PageRouteInfo<CommunityChatRouteArgs> {
  CommunityChatRoute({
    required String ownerId,
    required String communityName,
    Key? key,
    List<PageRouteInfo>? children,
  }) : super(
          CommunityChatRoute.name,
          args: CommunityChatRouteArgs(
            ownerId: ownerId,
            communityName: communityName,
            key: key,
          ),
          initialChildren: children,
        );

  static const String name = 'CommunityChatRoute';

  static const PageInfo<CommunityChatRouteArgs> page =
      PageInfo<CommunityChatRouteArgs>(name);
}

class CommunityChatRouteArgs {
  const CommunityChatRouteArgs({
    required this.ownerId,
    required this.communityName,
    this.key,
  });

  final String ownerId;

  final String communityName;

  final Key? key;

  @override
  String toString() {
    return 'CommunityChatRouteArgs{ownerId: $ownerId, communityName: $communityName, key: $key}';
  }
}

/// generated route for
/// [CustomProductViewingPage]
class CustomProductViewingRoute
    extends PageRouteInfo<CustomProductViewingRouteArgs> {
  CustomProductViewingRoute({
    required String uid,
    Key? key,
    required ProductEntity product,
    double height = 100,
    double width = 100,
    List<PageRouteInfo>? children,
  }) : super(
          CustomProductViewingRoute.name,
          args: CustomProductViewingRouteArgs(
            uid: uid,
            key: key,
            product: product,
            height: height,
            width: width,
          ),
          initialChildren: children,
        );

  static const String name = 'CustomProductViewingRoute';

  static const PageInfo<CustomProductViewingRouteArgs> page =
      PageInfo<CustomProductViewingRouteArgs>(name);
}

class CustomProductViewingRouteArgs {
  const CustomProductViewingRouteArgs({
    required this.uid,
    this.key,
    required this.product,
    this.height = 100,
    this.width = 100,
  });

  final String uid;

  final Key? key;

  final ProductEntity product;

  final double height;

  final double width;

  @override
  String toString() {
    return 'CustomProductViewingRouteArgs{uid: $uid, key: $key, product: $product, height: $height, width: $width}';
  }
}

/// generated route for
/// [FriendRequestPage]
class FriendRequestRoute extends PageRouteInfo<FriendRequestRouteArgs> {
  FriendRequestRoute({
    Key? key,
    required List<Map<String, dynamic>> data,
    required CheckFriendsBloc checkFriendBuildContext,
    List<PageRouteInfo>? children,
  }) : super(
          FriendRequestRoute.name,
          args: FriendRequestRouteArgs(
            key: key,
            data: data,
            checkFriendBuildContext: checkFriendBuildContext,
          ),
          initialChildren: children,
        );

  static const String name = 'FriendRequestRoute';

  static const PageInfo<FriendRequestRouteArgs> page =
      PageInfo<FriendRequestRouteArgs>(name);
}

class FriendRequestRouteArgs {
  const FriendRequestRouteArgs({
    this.key,
    required this.data,
    required this.checkFriendBuildContext,
  });

  final Key? key;

  final List<Map<String, dynamic>> data;

  final CheckFriendsBloc checkFriendBuildContext;

  @override
  String toString() {
    return 'FriendRequestRouteArgs{key: $key, data: $data, checkFriendBuildContext: $checkFriendBuildContext}';
  }
}

/// generated route for
/// [HomeNavigationPage]
class HomeNavigationRoute extends PageRouteInfo<HomeNavigationRouteArgs> {
  HomeNavigationRoute({
    required String? uid,
    Key? key,
    List<PageRouteInfo>? children,
  }) : super(
          HomeNavigationRoute.name,
          args: HomeNavigationRouteArgs(
            uid: uid,
            key: key,
          ),
          initialChildren: children,
        );

  static const String name = 'HomeNavigationRoute';

  static const PageInfo<HomeNavigationRouteArgs> page =
      PageInfo<HomeNavigationRouteArgs>(name);
}

class HomeNavigationRouteArgs {
  const HomeNavigationRouteArgs({
    required this.uid,
    this.key,
  });

  final String? uid;

  final Key? key;

  @override
  String toString() {
    return 'HomeNavigationRouteArgs{uid: $uid, key: $key}';
  }
}

/// generated route for
/// [HomePage]
class HomeRoute extends PageRouteInfo<HomeRouteArgs> {
  HomeRoute({
    String? uid,
    Key? key,
    List<PageRouteInfo>? children,
  }) : super(
          HomeRoute.name,
          args: HomeRouteArgs(
            uid: uid,
            key: key,
          ),
          initialChildren: children,
        );

  static const String name = 'HomeRoute';

  static const PageInfo<HomeRouteArgs> page = PageInfo<HomeRouteArgs>(name);
}

class HomeRouteArgs {
  const HomeRouteArgs({
    this.uid,
    this.key,
  });

  final String? uid;

  final Key? key;

  @override
  String toString() {
    return 'HomeRouteArgs{uid: $uid, key: $key}';
  }
}

/// generated route for
/// [LoginPage]
class LoginRoute extends PageRouteInfo<void> {
  const LoginRoute({List<PageRouteInfo>? children})
      : super(
          LoginRoute.name,
          initialChildren: children,
        );

  static const String name = 'LoginRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [MapPage]
class MapRoute extends PageRouteInfo<MapRouteArgs> {
  MapRoute({
    Key? key,
    required LatLng center,
    required String city,
    List<PageRouteInfo>? children,
  }) : super(
          MapRoute.name,
          args: MapRouteArgs(
            key: key,
            center: center,
            city: city,
          ),
          initialChildren: children,
        );

  static const String name = 'MapRoute';

  static const PageInfo<MapRouteArgs> page = PageInfo<MapRouteArgs>(name);
}

class MapRouteArgs {
  const MapRouteArgs({
    this.key,
    required this.center,
    required this.city,
  });

  final Key? key;

  final LatLng center;

  final String city;

  @override
  String toString() {
    return 'MapRouteArgs{key: $key, center: $center, city: $city}';
  }
}

/// generated route for
/// [MyInformationFarmerPage]
class MyInformationFarmerRoute extends PageRouteInfo<void> {
  const MyInformationFarmerRoute({List<PageRouteInfo>? children})
      : super(
          MyInformationFarmerRoute.name,
          initialChildren: children,
        );

  static const String name = 'MyInformationFarmerRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [MyInformationPage]
class MyInformationRoute extends PageRouteInfo<MyInformationRouteArgs> {
  MyInformationRoute({
    required String? uid,
    Key? key,
    List<PageRouteInfo>? children,
  }) : super(
          MyInformationRoute.name,
          args: MyInformationRouteArgs(
            uid: uid,
            key: key,
          ),
          initialChildren: children,
        );

  static const String name = 'MyInformationRoute';

  static const PageInfo<MyInformationRouteArgs> page =
      PageInfo<MyInformationRouteArgs>(name);
}

class MyInformationRouteArgs {
  const MyInformationRouteArgs({
    required this.uid,
    this.key,
  });

  final String? uid;

  final Key? key;

  @override
  String toString() {
    return 'MyInformationRouteArgs{uid: $uid, key: $key}';
  }
}

/// generated route for
/// [MyLikePage]
class MyLikeRoute extends PageRouteInfo<MyLikeRouteArgs> {
  MyLikeRoute({
    Key? key,
    required String uid,
    List<PageRouteInfo>? children,
  }) : super(
          MyLikeRoute.name,
          args: MyLikeRouteArgs(
            key: key,
            uid: uid,
          ),
          initialChildren: children,
        );

  static const String name = 'MyLikeRoute';

  static const PageInfo<MyLikeRouteArgs> page = PageInfo<MyLikeRouteArgs>(name);
}

class MyLikeRouteArgs {
  const MyLikeRouteArgs({
    this.key,
    required this.uid,
  });

  final Key? key;

  final String uid;

  @override
  String toString() {
    return 'MyLikeRouteArgs{key: $key, uid: $uid}';
  }
}

/// generated route for
/// [NotificationPage]
class NotificationRoute extends PageRouteInfo<NotificationRouteArgs> {
  NotificationRoute({
    String? uid,
    Key? key,
    List<PageRouteInfo>? children,
  }) : super(
          NotificationRoute.name,
          args: NotificationRouteArgs(
            uid: uid,
            key: key,
          ),
          initialChildren: children,
        );

  static const String name = 'NotificationRoute';

  static const PageInfo<NotificationRouteArgs> page =
      PageInfo<NotificationRouteArgs>(name);
}

class NotificationRouteArgs {
  const NotificationRouteArgs({
    this.uid,
    this.key,
  });

  final String? uid;

  final Key? key;

  @override
  String toString() {
    return 'NotificationRouteArgs{uid: $uid, key: $key}';
  }
}

/// generated route for
/// [RegistrationFormPage]
class RegistrationFormRoute extends PageRouteInfo<void> {
  const RegistrationFormRoute({List<PageRouteInfo>? children})
      : super(
          RegistrationFormRoute.name,
          initialChildren: children,
        );

  static const String name = 'RegistrationFormRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [SellerRegistrationPage]
class SellerRegistrationRoute
    extends PageRouteInfo<SellerRegistrationRouteArgs> {
  SellerRegistrationRoute({
    required String uid,
    required String fullName,
    required int phoneNumber,
    Key? key,
    List<PageRouteInfo>? children,
  }) : super(
          SellerRegistrationRoute.name,
          args: SellerRegistrationRouteArgs(
            uid: uid,
            fullName: fullName,
            phoneNumber: phoneNumber,
            key: key,
          ),
          initialChildren: children,
        );

  static const String name = 'SellerRegistrationRoute';

  static const PageInfo<SellerRegistrationRouteArgs> page =
      PageInfo<SellerRegistrationRouteArgs>(name);
}

class SellerRegistrationRouteArgs {
  const SellerRegistrationRouteArgs({
    required this.uid,
    required this.fullName,
    required this.phoneNumber,
    this.key,
  });

  final String uid;

  final String fullName;

  final int phoneNumber;

  final Key? key;

  @override
  String toString() {
    return 'SellerRegistrationRouteArgs{uid: $uid, fullName: $fullName, phoneNumber: $phoneNumber, key: $key}';
  }
}

/// generated route for
/// [ShowChatPage]
class ShowChatRoute extends PageRouteInfo<void> {
  const ShowChatRoute({List<PageRouteInfo>? children})
      : super(
          ShowChatRoute.name,
          initialChildren: children,
        );

  static const String name = 'ShowChatRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [ShowProductByCategoryPage]
class ShowProductByCategoryRoute
    extends PageRouteInfo<ShowProductByCategoryRouteArgs> {
  ShowProductByCategoryRoute({
    Key? key,
    required String uid,
    required String label,
    required List<ProductEntity> productData,
    List<PageRouteInfo>? children,
  }) : super(
          ShowProductByCategoryRoute.name,
          args: ShowProductByCategoryRouteArgs(
            key: key,
            uid: uid,
            label: label,
            productData: productData,
          ),
          initialChildren: children,
        );

  static const String name = 'ShowProductByCategoryRoute';

  static const PageInfo<ShowProductByCategoryRouteArgs> page =
      PageInfo<ShowProductByCategoryRouteArgs>(name);
}

class ShowProductByCategoryRouteArgs {
  const ShowProductByCategoryRouteArgs({
    this.key,
    required this.uid,
    required this.label,
    required this.productData,
  });

  final Key? key;

  final String uid;

  final String label;

  final List<ProductEntity> productData;

  @override
  String toString() {
    return 'ShowProductByCategoryRouteArgs{key: $key, uid: $uid, label: $label, productData: $productData}';
  }
}

/// generated route for
/// [WishListPage]
class WishListRoute extends PageRouteInfo<WishListRouteArgs> {
  WishListRoute({
    Key? key,
    String? uid,
    List<PageRouteInfo>? children,
  }) : super(
          WishListRoute.name,
          args: WishListRouteArgs(
            key: key,
            uid: uid,
          ),
          initialChildren: children,
        );

  static const String name = 'WishListRoute';

  static const PageInfo<WishListRouteArgs> page =
      PageInfo<WishListRouteArgs>(name);
}

class WishListRouteArgs {
  const WishListRouteArgs({
    this.key,
    this.uid,
  });

  final Key? key;

  final String? uid;

  @override
  String toString() {
    return 'WishListRouteArgs{key: $key, uid: $uid}';
  }
}
