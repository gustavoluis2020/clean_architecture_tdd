import 'dart:convert';
import 'package:clean_architecture_tdd/src/authentication/data/models/user_model.dart';
import 'package:clean_architecture_tdd/src/authentication/domain/entities/user.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  test('should be a subclass of [User] entity', () {
// arrange
    const tModel = UserModel(id: 'id', createdAt: 'createdAt', name: 'name', avatar: 'avatar');
// assert
    expect(tModel, isA<User>());
  });

  group('fromJson', () {
    test('should return a valid model when the JSON is valid', () {
// arrange
      final Map<String, dynamic> jsonMap = {
        "id": "id",
        "createdAt": "createdAt",
        "name": "name",
        "avatar": "avatar",
      };
// act
      final result = UserModel.fromJson(jsonMap);
// assert
      expect(
        result,
        const UserModel(
          id: 'id',
          createdAt: 'createdAt',
          name: 'name',
          avatar: 'avatar',
        ),
      );
    });
  });

  group('toJson', () {
    test('should return a JSON map containing the proper data', () {
// arrange
      final result = const UserModel(
        id: 'id',
        createdAt: 'createdAt',
        name: 'name',
        avatar: 'avatar',
      ).toJson();
// assert
      final expectedMap = {
        "id": "id",
        "createdAt": "createdAt",
        "name": "name",
        "avatar": "avatar",
      };
      expect(result, expectedMap);
    });
  });

  group('copyWith', () {
    test('should return a copy of the model', () {
// arrange
      final result = const UserModel(
        id: 'id',
        createdAt: 'createdAt',
        name: 'name',
        avatar: 'avatar',
      ).copyWith(
        name: 'teste',
      );
// assert
      expect(
        result.name,
        equals('teste'),
      );
    });
  });

  group('fromJson', () {
    test('should read a json file', () {
      final tJson = fixture('user.json');
      final tMap = jsonDecode(tJson) as Map<String, dynamic>;

      final result = UserModel.fromJson(tMap);

      expect(result, isA<UserModel>());
    });
  });

  group('toJson', () {
    test('should send a toJson file', () {
      const userModel = UserModel(
        id: 'id',
        createdAt: 'createdAt',
        name: 'name',
        avatar: 'avatar',
      );
      final result = userModel.toJson();

      expect(result, isA<Map<String, dynamic>>());
      expect(result, {
        'id': 'id',
        'createdAt': 'createdAt',
        'name': 'name',
        'avatar': 'avatar',
      });
    });
  });
}
