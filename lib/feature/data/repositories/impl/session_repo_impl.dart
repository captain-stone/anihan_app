import 'package:anihan_app/common/api_result.dart';
import 'package:anihan_app/feature/data/models/dao/login_dao.dart';
import 'package:anihan_app/feature/data/repositories/interfaces/sessions_repositories.dart';
import 'package:anihan_app/feature/domain/entities/login_entity.dart';
import 'package:anihan_app/feature/domain/entities/sign_up_entity.dart';
import 'package:anihan_app/feature/domain/parameters/login_params.dart';
import 'package:anihan_app/feature/domain/parameters/sign_up_params.dart';
import 'package:injectable/injectable.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:logger/logger.dart';

@Injectable(as: SessionsRepositories)
class SessionRepoImpl extends SessionsRepositories {
  final Logger logger = Logger();
  final LoginDao loginDao;
  final InternetConnectionChecker internetConnectionChecker;

  SessionRepoImpl(
      this.loginDao, @Named('global') this.internetConnectionChecker);

  @override
  Future<ApiResult<LoginEntity>> getLoginEntity(LoginParams? params) async {
    var localLoginData = await loginDao.getLoginDao();

    //check if localLoginData is empty or the token is equal to the new token.
    //check the internet first

    if (!(await internetConnectionChecker.hasConnection)) {
      return const ApiResult.noInternetConenction();
    } else {
      //since parameters are not empty procceed
      try {
        if (params != null && localLoginData == null) {
          var user = await getUserCredential(params.username, params.password);

          var token = await user!.getIdToken();
          var emailVerified = user.emailVerified;
          if (emailVerified) {
            var loginEntity = LoginEntity(token!,
                displayName: user.displayName,
                uid: user.uid,
                username: user.email,
                password: params.password,
                dateLogin: user.metadata.lastSignInTime.toString());
            await loginDao.insert(loginEntity);

            return ApiResult.success(await loginDao.getLoginDao());
          } else {
            return const ApiResult.error(
                "We sent you an email to verify your account. Please verify it first before logging in");
          }
        } else if (params == null && localLoginData != null) {
          // String username = localLoginData.username!;
          // String password = localLoginData.password!;

          // var user = await getUserCredential(username, password);
          // var token = await user!.getIdToken();

          // if (token == localLoginData.token) {
          return ApiResult.success(localLoginData);
          // } else {
          //   await loginDao.deleteData();
          //   return ApiResult.sessionExpired();
          // }
        } else {
          return const ApiResult.loading(status: Status.initial);
        }
      } on FirebaseAuthException catch (e) {
        logger.f(e);
        logger.f(e.message);
        if (e.code == 'invalid-credential') {
          logger.e("yes");
          return const ApiResult.error(
              "The credentials you entered do not match any account. Please check your email and password and try again, or create a new account if you haven't registered yet.",
              errorType: ErrorType.firebaseError);
        } else if (e.code == 'wrong-password') {
          return const ApiResult.error(
              "The password you entered is incorrect. Please try again or use the 'Forgot Password?' option to reset it.",
              errorType: ErrorType.firebaseError);
        } else {
          return ApiResult.error(e.message, errorType: ErrorType.firebaseError);
        }
      } catch (e) {
        logger.e(e);
        return ApiResult.error(e.toString());
      }
    }
  }

  @override
  Future<ApiResult<SignUpEntity>> getSignUpEntity(SignUpParams params) async {
    //CHECK IF THERES NO INTERNET FIRST.

    if (!(await internetConnectionChecker.hasConnection)) {
      return const ApiResult.noInternetConenction();
    } else {
      ///put an validation na di need null is params
      try {
        var firebaseResponse =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: params.emailAddress,
          password: params.password,
        );

        var user = firebaseResponse.user;

        if (user != null) {
          await user.sendEmailVerification();
          await user.updateDisplayName(params.fullName);

          final databaseReference =
              FirebaseDatabase.instance.ref('users/${user.uid}');

          await databaseReference.set({
            'fullName': params.fullName,
            'phoneNumber': params.phoneNumber,
            'emailAddress': params.emailAddress,
          });

          return ApiResult.success(SignUpEntity(fullName: params.fullName));
        } else {
          // since sign up is required. this user might be deleted
          return const ApiResult.error(
              "This email has been delete by the admin");
        }
      } on FirebaseAuthException catch (e) {
        return ApiResult.error(e.message.toString(),
            errorType: ErrorType.firebaseError);
      } catch (e) {
        logger.e(e.toString());
        return ApiResult.error(e.toString());
      }
    }
  }

  Future<User?> getUserCredential(String username, String password) async {
    var firebaseResponse = await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: username, password: password);

    var user = firebaseResponse.user;

    return user;
  }
}
