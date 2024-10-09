import 'package:anihan_app/common/notification_module.dart';
import 'package:anihan_app/feature/data/database/app_database.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:injectable/injectable.dart';
import 'package:http/http.dart' as http;
// ignore: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i1;

import 'package:dio/dio.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

import 'app_module.config.dart';

@module
abstract class AppModule {
  @Named("global")
  @lazySingleton
  InternetConnectionChecker get internetConnectionChecker =>
      InternetConnectionChecker.createInstance();

  @lazySingleton
  DatabaseReference get ref => FirebaseDatabase.instance.ref();

  @lazySingleton
  http.Client get httpClient => http.Client();

  @lazySingleton
  Dio get dio => Dio(BaseOptions(
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 15),
      ));

  // @lazySingleton
  // Logger get logger => Logger();

  @preResolve
  Future<FirebaseApp> get firebaseApp async => await Firebase.initializeApp();

  @preResolve
  Future<AppDatabase> get db => AppDatabase.create();

  @preResolve
  Future<FlutterLocalNotificationsPlugin> get notification async {
    final plugin = FlutterLocalNotificationsPlugin();
    await NotificationModule.initializeNotifications(plugin);
    return plugin;
  }
}

final getIt = _i1.GetIt.instance;
@InjectableInit()
Future<void> configureDependencies() async => await getIt.init();
