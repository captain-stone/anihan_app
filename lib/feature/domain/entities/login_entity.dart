import 'package:anihan_app/feature/domain/entities/app_entity.dart';
import 'package:floor/floor.dart';

@Entity(tableName: LoginEntity.tableName)
class LoginEntity extends AppEntity {
  @ignore
  static const String tableName = "login_credential_tbl";

  @primaryKey
  final int id = 1;

  final String? refreshToken;
  final String? displayName;
  final String? uid;
  final String? username;
  final String? password;
  final String token;

  final String? dateLogin;

  LoginEntity(this.token,
      {this.displayName,
      this.refreshToken,
      this.uid,
      this.dateLogin,
      this.username,
      this.password});

  @override
  // TODO: implement props
  List<Object?> get props => [token, displayName, uid, refreshToken, dateLogin];
}
