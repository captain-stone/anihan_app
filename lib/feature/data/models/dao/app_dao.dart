import 'package:anihan_app/feature/domain/entities/app_entity.dart';
import 'package:floor/floor.dart';

abstract class AppDao<T extends AppEntity> {
  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insert(T data);
  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insertAll(List<T> data);
}
