import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:happy_tech_mastering_api_with_flutter/core/api/api_consumer.dart';
import 'package:happy_tech_mastering_api_with_flutter/core/api/end_points.dart';
import 'package:happy_tech_mastering_api_with_flutter/core/cache/cache_helper.dart';
import 'package:happy_tech_mastering_api_with_flutter/core/errors/exceptions.dart';
import 'package:happy_tech_mastering_api_with_flutter/core/functions/upload_image_to_api.dart';
import 'package:happy_tech_mastering_api_with_flutter/cubit/user_state.dart';
import 'package:happy_tech_mastering_api_with_flutter/models/sign_in_model.dart';
import 'package:happy_tech_mastering_api_with_flutter/models/sign_up_model.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class UserCubit extends Cubit<UserState> {
  UserCubit(this.api) : super(UserInitial());
  final ApiConsumer api;
  //Sign in Form key
  GlobalKey<FormState> signInFormKey = GlobalKey();
  //Sign in email
  TextEditingController signInEmail = TextEditingController();
  //Sign in password
  TextEditingController signInPassword = TextEditingController();
  //Sign Up Form key
  GlobalKey<FormState> signUpFormKey = GlobalKey();
  //Profile Pic
  XFile? profilePic;
  //Sign up name
  TextEditingController signUpName = TextEditingController();
  //Sign up phone number
  TextEditingController signUpPhoneNumber = TextEditingController();
  //Sign up email
  TextEditingController signUpEmail = TextEditingController();
  //Sign up password
  TextEditingController signUpPassword = TextEditingController();
  //Sign up confirm password
  TextEditingController confirmPassword = TextEditingController();
  SignInModel? user;

  uploadProfilePic(XFile image) {
    profilePic = image;
    emit(UploadProfilePic());
  }

  signIn() async {
    try {
      emit(SignInLoading());
      final response = await api.post(
        EndPoint.signIn,
        data: {
          ApiKeys.email: signInEmail.text,
          ApiKeys.password: signInPassword.text,
        },
      );
      user = SignInModel.fromJson(response);
      final decodedToken = JwtDecoder.decode(user!.token);
      CacheHelper().saveData(key: ApiKeys.token, value: user!.token);
      CacheHelper().saveData(key: ApiKeys.id, value: decodedToken[ApiKeys.id]);
      emit(SignInSuccess());
    } on ServerExceptions catch (e) {
      emit(SignInFailure(errMessage: e.errorModel.errorMessage));
    }
  }

  signUp() async {
    try {
      emit(SignUpLoading());
      final response = await api.post(
        EndPoint.signUp,
        isFormData: true,
        data: {
          ApiKeys.name: signUpName.text,
          ApiKeys.phone: signUpPhoneNumber.text,
          ApiKeys.email: signUpEmail.text,
          ApiKeys.password: signUpPassword.text,
          ApiKeys.confirmPassword: confirmPassword.text,
          ApiKeys.location:
              '{"name":"methalfa","address":"meet halfa","coordinates":[30.1572709,31.224779]}',
          ApiKeys.profilePic: await uploadImageToAPI(profilePic!),
        },
      );
      final signUpModel = SignUpModel.fromJson(response);

      emit(SignUpSuccess(message: signUpModel.message));
    } on ServerExceptions catch (e) {
      emit(SignUpFailure(errMessage: e.errorModel.errorMessage));
    }
  }
}
