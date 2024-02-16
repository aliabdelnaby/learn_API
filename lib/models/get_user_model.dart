import 'package:happy_tech_mastering_api_with_flutter/core/api/end_points.dart';

class GetUserModel {
  final String profilePic;
  final String email;
  final String name;
  final String phone;
  final Map<String, dynamic> address;

  GetUserModel({
    required this.profilePic,
    required this.email,
    required this.name,
    required this.phone,
    required this.address,
  });
  factory GetUserModel.fromJson(Map<String, dynamic> jsonData) {
    return GetUserModel(
      name: jsonData[ApiKeys.user][ApiKeys.name],
      email: jsonData[ApiKeys.user][ApiKeys.email],
      phone: jsonData[ApiKeys.user][ApiKeys.phone],
      profilePic: jsonData[ApiKeys.user][ApiKeys.profilePic],
      address: jsonData[ApiKeys.user][ApiKeys.location],
    );
  }
}
