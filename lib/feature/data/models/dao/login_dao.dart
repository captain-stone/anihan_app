import 'package:anihan_app/feature/data/database/app_database.dart';
import 'package:anihan_app/feature/data/models/dao/app_dao.dart';
import 'package:floor/floor.dart';
import 'package:injectable/injectable.dart';

import '../../../domain/entities/login_entity.dart';

@injectable
@dao
abstract class LoginDao extends AppDao<LoginEntity> {
  @factoryMethod
  static LoginDao create(AppDatabase db) => db.loginDAO;

  @Query("SELECT * FROM ${LoginEntity.tableName}")
  Future<LoginEntity?> getLoginDao();

  @Query("DELETE FROM ${LoginEntity.tableName}")
  Future<void> deleteData();
}
