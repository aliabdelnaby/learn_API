import 'package:happy_tech_mastering_api_with_flutter/models/get_user_model.dart';

class UserState {}

final class UserInitial extends UserState {}

final class SignInLoading extends UserState {}

final class SignInSuccess extends UserState {}

final class SignInFailure extends UserState {
  final String errMessage;

  SignInFailure({required this.errMessage});
}

final class SignUpLoading extends UserState {}

final class SignUpSuccess extends UserState {
  final String message;

  SignUpSuccess({required this.message});
}

final class SignUpFailure extends UserState {
  final String errMessage;

  SignUpFailure({required this.errMessage});
}

final class GetUserLoading extends UserState {}

final class GetUserSuccess extends UserState {
  final GetUserModel userModel;

  GetUserSuccess({required this.userModel});
}

final class GetUserFailure extends UserState {
  final String errMessage;

  GetUserFailure({required this.errMessage});
}

final class UploadProfilePic extends UserState {}
