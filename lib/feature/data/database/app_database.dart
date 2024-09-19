import 'dart:async';

import 'package:anihan_app/feature/data/models/dao/login_dao.dart';
import 'package:anihan_app/feature/domain/entities/login_entity.dart';
import 'package:floor/floor.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

part 'app_database.g.dart';

@Database(version: 1, entities: [LoginEntity])
abstract class AppDatabase extends FloorDatabase {
  LoginDao get loginDAO;

  static Future<AppDatabase> create() async =>
      $FloorAppDatabase.databaseBuilder("app_database.db").build();
}
