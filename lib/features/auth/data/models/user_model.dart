import 'package:customers/features/auth/domain/entities/user.dart';

class UserModel extends User {
  UserModel({
    required super.userCode,
    required super.displayName,
    required super.email,
    required super.employeeCode,
    required super.companyCode,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      userCode: json['User_Code'] ?? '',
      displayName: json['User_Display_Name'] ?? '',
      email: json['Email'] ?? '',
      employeeCode: json['User_Employee_Code'] ?? '',
      companyCode: json['Company_Code'] ?? '',
    );
  }
}