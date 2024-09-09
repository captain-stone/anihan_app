import 'package:auto_route/auto_route.dart';

import '../pages/home_page.dart';
import '../pages/login_page.dart';
import '../pages/register_page.dart';
part 'app_routers.gr.dart';

@AutoRouterConfig()
class AppRouters extends _$AppRouters {
  @override
  // TODO: implement routes
  List<AutoRoute> get routes => [
        AutoRoute(page: LoginRoute.page, initial: true),
        AutoRoute(page: HomeRoute.page),
        AutoRoute(page: RegistrationFormRoute.page)
      ];
}
