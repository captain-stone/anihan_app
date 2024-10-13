// ignore_for_file: unused_element

import 'package:equatable/equatable.dart';

enum Status {
  success,
  error,
  loading,
  initial,
  saved,
}

enum Approval {
  approved,
  notApproved,
  pendingApproval,
}

enum ErrorType {
  nullError,
  noInternet,
  serverDown,
  sessionExpired,
  noSession,
  servernNotSupported,
  emailaddressAndPasswordNotSupported,
  generic,
  connectionFailed,
  invalidUsernameAndPassword,
  firebaseError,
}

class ApiResult<T> extends Equatable {
  final Status status;
  final T? data;
  final String? message;
  final ErrorType? errorType;

  const ApiResult._({
    required this.status,
    this.data,
    this.message,
    this.errorType,
  });

  const ApiResult.success(
    this.data, {
    this.message,
    this.status = Status.success,
    this.errorType,
  });

  const ApiResult.error(
    this.message, {
    this.errorType = ErrorType.generic,
    this.data,
    this.status = Status.error,
  });
  const ApiResult.loading(
      {this.status = Status.loading, this.data, this.errorType, this.message});

  const ApiResult.deleteSuccess(this.message,
      {this.data, this.status = Status.success, this.errorType});

  const ApiResult.invalidUsernamePassword(this.message,
      {this.data,
      this.errorType = ErrorType.invalidUsernameAndPassword,
      this.status = Status.error});
  const ApiResult.sessionExpired(
      {this.status = Status.error,
      this.message = "Session Expired",
      this.data,
      this.errorType = ErrorType.sessionExpired});

  const ApiResult.noInternetConenction(
      {this.message = "No Internet Connection",
      this.status = Status.error,
      this.errorType = ErrorType.noInternet,
      this.data});

  const ApiResult.connectionFailed(
      {this.data,
      this.status = Status.error,
      this.message = "Connection Failed",
      this.errorType = ErrorType.connectionFailed});

  @override
  List<Object?> get props => [status, data, message, errorType];
}
