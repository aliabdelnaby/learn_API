import 'package:dartz/dartz.dart';
import 'package:happy_tech_mastering_api_with_flutter/core/api/api_consumer.dart';
import 'package:happy_tech_mastering_api_with_flutter/core/api/end_points.dart';
import 'package:happy_tech_mastering_api_with_flutter/core/cache/cache_helper.dart';
import 'package:happy_tech_mastering_api_with_flutter/core/errors/exceptions.dart';
import 'package:happy_tech_mastering_api_with_flutter/core/functions/upload_image_to_api.dart';
import 'package:happy_tech_mastering_api_with_flutter/models/get_user_model.dart';
import 'package:happy_tech_mastering_api_with_flutter/models/sign_in_model.dart';
import 'package:happy_tech_mastering_api_with_flutter/models/sign_up_model.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class UserRepository {
  UserRepository({required this.api});

  final ApiConsumer api;

  Future<Either<String, SignInModel>> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final response = await api.post(
        EndPoint.signIn,
        data: {
          ApiKeys.email: email,
          ApiKeys.password: password,
        },
      );
      final user = SignInModel.fromJson(response);
      final decodedToken = JwtDecoder.decode(user.token);
      CacheHelper().saveData(key: ApiKeys.token, value: user.token);
      CacheHelper().saveData(key: ApiKeys.id, value: decodedToken[ApiKeys.id]);
      return Right(user);
    } on ServerExceptions catch (e) {
      return Left(e.errorModel.errorMessage);
    }
  }

  Future<Either<String, SignUpModel>> signUp({
    required String name,
    required String email,
    required String phone,
    required XFile profilePic,
    required String password,
    required String confirmPassword,
    // required String location,
  }) async {
    try {
      final response = await api.post(
        EndPoint.signIn,
        isFormData: true,
        data: {
          ApiKeys.name: name,
          ApiKeys.phone: phone,
          ApiKeys.email: email,
          ApiKeys.password: password,
          ApiKeys.confirmPassword: confirmPassword,
          ApiKeys.location:
              '{"name":"methalfa","address":"meet halfa","coordinates":[30.1572709,31.224779]}',
          ApiKeys.profilePic: await uploadImageToAPI(profilePic),
        },
      );
      final signUpModel = SignUpModel.fromJson(response);
      return Right(signUpModel);
    } on ServerExceptions catch (e) {
      return Left(e.errorModel.errorMessage);
    }
  }

  Future<Either<String, GetUserModel>> getUserData() async {
    try {
      final response = await api.get(
        EndPoint.getUserDataEndPoint(
          CacheHelper().getData(key: ApiKeys.id),
        ),
      );
      return Right(GetUserModel.fromJson(response));
    } on ServerExceptions catch (e) {
      return Left(e.errorModel.errorMessage);
    }
  }
}
