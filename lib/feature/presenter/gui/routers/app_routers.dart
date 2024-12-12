import 'package:anihan_app/feature/presenter/gui/pages/friend_request_page.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';

import '../../../domain/entities/product_entity.dart';
import '../pages/add_ons_blocs/check_friends_bloc/check_friends_bloc.dart';
import '../pages/add_product_page/addproductform.dart';
import '../pages/chats_bloc/chat_with_page.dart';
import '../pages/chats_bloc/chats_page.dart';
import '../pages/chats_bloc/community_chat_page.dart';
import '../pages/chats_bloc/show_friends_page.dart';
import '../pages/home_navigation_page.dart';
import '../pages/home_page.dart';
import '../pages/login_bloc/login_page.dart';
import '../pages/map__page/map_page.dart';
import '../pages/myinformation_farmer.dart';
import '../pages/user_information_bloc/user_information_page.dart';
import '../pages/notification_bloc/notification_page.dart';
import '../pages/register_bloc/register_page.dart';
import '../pages/seller_registration_bloc/seller_registration_page.dart';
import '../pages/wish_list_page/wish_list_page.dart';
import '../widgets/addons/informations_widgets/page/my_like_page.dart';
import '../widgets/addons/product_categories/show_product_by_category.dart';
import '../widgets/products/custom_product_viewing.dart';
part 'app_routers.gr.dart';

@AutoRouterConfig()
class AppRouters extends _$AppRouters {
  @override
  List<AutoRoute> get routes => [
        AutoRoute(page: LoginRoute.page, initial: true),
        // AutoRoute(page: HomeRoute.page),
        AutoRoute(page: RegistrationFormRoute.page),
        // AutoRoute(page: MyInformationRoute.page),
        AutoRoute(page: HomeNavigationRoute.page, children: [
          AutoRoute(page: WishListRoute.page),
          AutoRoute(page: ChatsRoute.page),
          AutoRoute(page: HomeRoute.page),
          AutoRoute(page: NotificationRoute.page),
          AutoRoute(page: MyInformationRoute.page),
        ]),
        AutoRoute(page: SellerRegistrationRoute.page),
        AutoRoute(page: MyInformationFarmerRoute.page),
        AutoRoute(page: AddProductFormRoute.page),
        AutoRoute(page: ShowProductByCategoryRoute.page),
        AutoRoute(page: CustomProductViewingRoute.page),
        AutoRoute(page: FriendRequestRoute.page),
        AutoRoute(page: MapRoute.page),
        AutoRoute(page: ChatWithRoute.page),
        AutoRoute(page: MyLikeRoute.page),
        AutoRoute(page: CommunityChatRoute.page)
      ];
}
