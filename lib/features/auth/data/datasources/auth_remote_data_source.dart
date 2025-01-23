import 'dart:convert';
import 'package:customers/core/error/exception.dart';
import 'package:customers/features/auth/data/models/user_model.dart';
import 'package:http/http.dart' as http;

abstract class AuthRemoteDataSource {
  Future<UserModel> login(String username, String password);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final http.Client client;
  bool isLoading = true;

  AuthRemoteDataSourceImpl(this.client);

  final Uri url =
      Uri.parse('https://api.ezuite.com/api/External_Api/Mobile_Api/Invoke');

  @override
  Future<UserModel> login(String username, String password) async {
    final requestBody = jsonEncode({
      "API_Body": [
        {"Unique_Id": "", "Pw": password}
      ],
      "Api_Action": "GetUserData",
      "Company_Code": username
    });

    print('Request Body: $requestBody');

    final response = await client.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: requestBody,
    );

    print('Response Status: ${response.statusCode}');
    print('Response Body: ${response.body}');

    if (response.statusCode == 200) {
      final responseBody = jsonDecode(response.body);
      if (responseBody['Response_Body'] != null &&
          responseBody['Response_Body'].isNotEmpty) {
        final userJson = responseBody['Response_Body'][0];
        return UserModel.fromJson(userJson);
      } else {
        throw ServerException('Invalid Response Body');
      }
    } else {
      throw ServerException('Error: ${response.statusCode}');
    }
  }
}
