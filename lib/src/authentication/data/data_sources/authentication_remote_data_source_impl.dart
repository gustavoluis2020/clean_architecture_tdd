import 'dart:convert';

import 'package:clean_architecture_tdd/core/constants/constants.dart';
import 'package:clean_architecture_tdd/core/errors/exceptions.dart';
import 'package:clean_architecture_tdd/src/authentication/data/data_sources/authentication_remote_data_source.dart';
import 'package:clean_architecture_tdd/src/authentication/data/models/user_model.dart';
import 'package:http/http.dart' as http;

class AuthenticationRemoteDataSourceImpl implements AuthenticationRemoteDataSource {
  const AuthenticationRemoteDataSourceImpl(this._client);

  final http.Client _client;

  @override
  Future<void> createUser({
    required String createdAt,
    required String name,
    required String avatar,
  }) async {
    try {
      final response = await _client.post(
        Uri.parse('$kBaseUrl$kCreateUserEndpoint'),
        body: jsonEncode({
          'createdAt': createdAt,
          'name': name,
          'avatar': avatar,
        }),
      );
      if (response.statusCode != 200 && response.statusCode != 201) {
        throw ApiException(message: 'User not created', statusCode: response.statusCode);
      }
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException(message: e.toString(), statusCode: 505);
    }
  }

  @override
  Future<List<UserModel>> getUsers() async {
    try {
      final response = await _client.get(Uri.parse('$kBaseUrl$kGetUsersEndpoint'));
      if (response.statusCode != 200) {
        throw ApiException(message: 'Failed to get users', statusCode: response.statusCode);
      }
      final List<dynamic> users = jsonDecode(response.body);
      return users.map((user) => UserModel.fromJson(user)).toList();
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException(message: e.toString(), statusCode: 505);
    }
  }
}
