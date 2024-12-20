// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:anihan_app/common/app_module.dart' as _i142;
import 'package:anihan_app/feature/data/database/app_database.dart' as _i673;
import 'package:anihan_app/feature/data/models/dao/login_dao.dart' as _i1057;
import 'package:anihan_app/feature/data/repositories/impl/product_repo_impl.dart'
    as _i234;
import 'package:anihan_app/feature/data/repositories/impl/registration_farmers_repo_impl.dart'
    as _i774;
import 'package:anihan_app/feature/data/repositories/impl/session_repo_impl.dart'
    as _i457;
import 'package:anihan_app/feature/data/repositories/impl/user_information_repo_impl.dart'
    as _i458;
import 'package:anihan_app/feature/data/repositories/interfaces/product_repository.dart'
    as _i1033;
import 'package:anihan_app/feature/data/repositories/interfaces/registration_farmers_repository.dart'
    as _i107;
import 'package:anihan_app/feature/data/repositories/interfaces/sessions_repositories.dart'
    as _i908;
import 'package:anihan_app/feature/data/repositories/interfaces/user_information_repository.dart'
    as _i521;
import 'package:anihan_app/feature/domain/usecases/login_usecase.dart' as _i946;
import 'package:anihan_app/feature/domain/usecases/product_usecase.dart'
    as _i593;
import 'package:anihan_app/feature/domain/usecases/registration_farmers_usecase.dart'
    as _i1068;
import 'package:anihan_app/feature/domain/usecases/sign_up_usecase.dart'
    as _i341;
import 'package:anihan_app/feature/domain/usecases/user_information_usecase.dart'
    as _i619;
import 'package:anihan_app/feature/presenter/gui/pages/add_ons_blocs/check_friends_bloc/check_friends_bloc.dart'
    as _i201;
import 'package:anihan_app/feature/presenter/gui/pages/add_product_page/add_product_page_bloc.dart'
    as _i905;
import 'package:anihan_app/feature/presenter/gui/pages/chats_bloc/blocs/chat_page/chats_page_bloc.dart'
    as _i609;
import 'package:anihan_app/feature/presenter/gui/pages/chats_bloc/blocs/chat_with_page_bloc/chat_with_bloc.dart'
    as _i1006;
import 'package:anihan_app/feature/presenter/gui/pages/chats_bloc/blocs/community_chat_page.dart/community_chat_bloc.dart'
    as _i643;
import 'package:anihan_app/feature/presenter/gui/pages/chats_bloc/blocs/join_community_bloc/join_community_bloc.dart'
    as _i210;
import 'package:anihan_app/feature/presenter/gui/pages/checkout_page/cubit/remove_checkout_cubit.dart'
    as _i726;
import 'package:anihan_app/feature/presenter/gui/pages/Journal/blocs/calendar_widget/calendar_widget_bloc.dart'
    as _i88;
import 'package:anihan_app/feature/presenter/gui/pages/Journal/blocs/journal_widget/journal_widget_bloc.dart'
    as _i109;
import 'package:anihan_app/feature/presenter/gui/pages/Journal/blocs/weather_widget/weather_widget_bloc.dart'
    as _i285;
import 'package:anihan_app/feature/presenter/gui/pages/login_bloc/login_page_bloc.dart'
    as _i550;
import 'package:anihan_app/feature/presenter/gui/pages/map__page/map_page_cubit.dart'
    as _i445;
import 'package:anihan_app/feature/presenter/gui/pages/notification_bloc/notification_page_bloc.dart'
    as _i517;
import 'package:anihan_app/feature/presenter/gui/pages/register_bloc/register_page_bloc.dart'
    as _i282;
import 'package:anihan_app/feature/presenter/gui/pages/seller_registration_bloc/seller_registration_bloc.dart'
    as _i905;
import 'package:anihan_app/feature/presenter/gui/pages/user_information_bloc/checkout_info/checkout_inf_bloc.dart'
    as _i266;
import 'package:anihan_app/feature/presenter/gui/pages/user_information_bloc/cubit/add_update_user_address_cubit.dart'
    as _i1003;
import 'package:anihan_app/feature/presenter/gui/pages/user_information_bloc/user_information_bloc_bloc.dart'
    as _i860;
import 'package:anihan_app/feature/presenter/gui/pages/wish_list_page/wishlist_bloc/wish_list_page_bloc.dart'
    as _i604;
import 'package:anihan_app/feature/presenter/gui/widgets/products/add_to_cart/add_to_cart_bloc.dart'
    as _i786;
import 'package:anihan_app/feature/presenter/gui/widgets/products/all_products_add_ons_bloc/all_products_add_ons_bloc.dart'
    as _i691;
import 'package:anihan_app/feature/presenter/gui/widgets/products/cubit/product_update_cubit.dart'
    as _i269;
import 'package:anihan_app/feature/presenter/gui/widgets/products/products_add_ons_bloc/product_add_ons_bloc.dart'
    as _i280;
import 'package:anihan_app/feature/presenter/gui/widgets/sellers/seller_add_ons/seller_info_add_ons_bloc.dart'
    as _i779;
import 'package:dio/dio.dart' as _i361;
import 'package:firebase_core/firebase_core.dart' as _i982;
import 'package:firebase_database/firebase_database.dart' as _i345;
import 'package:flutter_local_notifications/flutter_local_notifications.dart'
    as _i163;
import 'package:get_it/get_it.dart' as _i174;
import 'package:http/http.dart' as _i519;
import 'package:injectable/injectable.dart' as _i526;
import 'package:internet_connection_checker/internet_connection_checker.dart'
    as _i973;

extension GetItInjectableX on _i174.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  Future<_i174.GetIt> init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) async {
    final gh = _i526.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    final appModule = _$AppModule();
    await gh.factoryAsync<_i982.FirebaseApp>(
      () => appModule.firebaseApp,
      preResolve: true,
    );
    await gh.factoryAsync<_i673.AppDatabase>(
      () => appModule.db,
      preResolve: true,
    );
    await gh.factoryAsync<_i163.FlutterLocalNotificationsPlugin>(
      () => appModule.notification,
      preResolve: true,
    );
    gh.factory<_i201.CheckFriendsBloc>(() => _i201.CheckFriendsBloc());
    gh.factory<_i609.ChatsPageBloc>(() => _i609.ChatsPageBloc());
    gh.factory<_i1006.ChatWithBloc>(() => _i1006.ChatWithBloc());
    gh.factory<_i643.CommunityChatBloc>(() => _i643.CommunityChatBloc());
    gh.factory<_i210.JoinCommunityBloc>(() => _i210.JoinCommunityBloc());
    gh.factory<_i726.RemoveCheckoutCubit>(() => _i726.RemoveCheckoutCubit());
    gh.factory<_i88.CalendarWidgetBloc>(() => _i88.CalendarWidgetBloc());
    gh.factory<_i109.JournalWidgetBloc>(() => _i109.JournalWidgetBloc());
    gh.factory<_i285.WeatherWidgetBloc>(() => _i285.WeatherWidgetBloc());
    gh.factory<_i445.MapPageCubit>(() => _i445.MapPageCubit());
    gh.factory<_i517.NotificationPageBloc>(() => _i517.NotificationPageBloc());
    gh.factory<_i266.CheckoutInfBloc>(() => _i266.CheckoutInfBloc());
    gh.factory<_i1003.AddUpdateUserAddressCubit>(
        () => _i1003.AddUpdateUserAddressCubit());
    gh.factory<_i604.WishListPageBloc>(() => _i604.WishListPageBloc());
    gh.factory<_i269.ProductUpdateCubit>(() => _i269.ProductUpdateCubit());
    gh.lazySingleton<_i345.DatabaseReference>(() => appModule.ref);
    gh.lazySingleton<_i519.Client>(() => appModule.httpClient);
    gh.lazySingleton<_i361.Dio>(() => appModule.dio);
    gh.factory<_i779.SellerInfoAddOnsBloc>(() => _i779.SellerInfoAddOnsBloc(
          gh<_i345.DatabaseReference>(),
          gh<_i345.DatabaseReference>(),
        ));
    gh.factory<_i1057.LoginDao>(
        () => _i1057.LoginDao.create(gh<_i673.AppDatabase>()));
    gh.lazySingleton<_i973.InternetConnectionChecker>(
      () => appModule.internetConnectionChecker,
      instanceName: 'global',
    );
    gh.factory<_i691.AllProductsAddOnsBloc>(
        () => _i691.AllProductsAddOnsBloc(gh<_i345.DatabaseReference>()));
    gh.factory<_i280.ProductAddOnsBloc>(
        () => _i280.ProductAddOnsBloc(gh<_i345.DatabaseReference>()));
    gh.factory<_i908.SessionsRepositories>(() => _i457.SessionRepoImpl(
          gh<_i1057.LoginDao>(),
          gh<_i973.InternetConnectionChecker>(instanceName: 'global'),
        ));
    gh.factory<_i107.RegistrationFarmersRepository>(() =>
        _i774.RegistrationFarmersRepoImpl(
            gh<_i973.InternetConnectionChecker>(instanceName: 'global')));
    gh.factory<_i521.UserInformationRepository>(
        () => _i458.UserInformationRepoImpl(
              gh<_i973.InternetConnectionChecker>(instanceName: 'global'),
              gh<_i1057.LoginDao>(),
            ));
    gh.factory<_i1033.ProductRepository>(() => _i234.ProductRepoImpl(
        gh<_i973.InternetConnectionChecker>(instanceName: 'global')));
    gh.factory<_i946.LogoutUsecase>(
        () => _i946.LogoutUsecase(gh<_i521.UserInformationRepository>()));
    gh.factory<_i593.ProductUsecase>(
        () => _i593.ProductUsecase(gh<_i1033.ProductRepository>()));
    gh.factory<_i593.AddToCartProductUsecase>(
        () => _i593.AddToCartProductUsecase(gh<_i1033.ProductRepository>()));
    gh.factory<_i946.LoginUsecase>(
        () => _i946.LoginUsecase(gh<_i908.SessionsRepositories>()));
    gh.factory<_i341.SignUpUsecase>(
        () => _i341.SignUpUsecase(gh<_i908.SessionsRepositories>()));
    gh.factory<_i1068.RegistrationFarmersUsecase>(() =>
        _i1068.RegistrationFarmersUsecase(
            gh<_i107.RegistrationFarmersRepository>()));
    gh.factory<_i619.UserInformationUsecase>(() =>
        _i619.UserInformationUsecase(gh<_i521.UserInformationRepository>()));
    gh.factory<_i905.AddProductPageBloc>(
        () => _i905.AddProductPageBloc(gh<_i593.ProductUsecase>()));
    gh.factory<_i786.AddToCartBloc>(
        () => _i786.AddToCartBloc(gh<_i593.AddToCartProductUsecase>()));
    gh.factory<_i905.SellerRegistrationBloc>(() =>
        _i905.SellerRegistrationBloc(gh<_i1068.RegistrationFarmersUsecase>()));
    gh.factory<_i282.RegisterPageBloc>(
        () => _i282.RegisterPageBloc(gh<_i341.SignUpUsecase>()));
    gh.factory<_i550.LoginPageBloc>(
        () => _i550.LoginPageBloc(gh<_i946.LoginUsecase>()));
    gh.factory<_i860.UserInformationBlocBloc>(
        () => _i860.UserInformationBlocBloc(
              gh<_i619.UserInformationUsecase>(),
              gh<_i946.LogoutUsecase>(),
            ));
    return this;
  }
}

class _$AppModule extends _i142.AppModule {}
