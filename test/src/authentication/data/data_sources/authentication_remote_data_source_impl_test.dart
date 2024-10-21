import 'dart:convert';
import 'package:clean_architecture_tdd/core/constants/constants.dart';
import 'package:clean_architecture_tdd/core/errors/exceptions.dart';
import 'package:clean_architecture_tdd/src/authentication/data/data_sources/authentication_remote_data_source.dart';
import 'package:clean_architecture_tdd/src/authentication/data/data_sources/authentication_remote_data_source_impl.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';

class MockClient extends Mock implements http.Client {}

void main() {
  late http.Client client;
  late AuthenticationRemoteDataSourceImpl remoteDataSourceImpl;

  setUp(() {
    client = MockClient();
    remoteDataSourceImpl = AuthenticationRemoteDataSourceImpl(client);
    registerFallbackValue(Uri());
  });

  group('create user', () {
    test('should complete successfully when the status code is 200 or 201', () async {
      when(() => client.post(
            any(),
            body: any(named: 'body'),
            headers: any(named: 'headers'),
          )).thenAnswer((_) async => http.Response('User created successfully', 201));

      final methodCall = remoteDataSourceImpl.createUser;

      expect(
        methodCall(
          createdAt: '2023-10-17',
          name: 'John Doe',
          avatar: 'avatar_url',
        ),
        completes,
      );
      verify(() => client.post(Uri.parse('$kBaseUrl$kCreateUserEndpoint'),
          body: jsonEncode({
            "createdAt": "2023-10-17",
            "name": "John Doe",
            "avatar": "avatar_url",
          }))).called(1);
      verifyNoMoreInteractions(client);
    });

    test('should throw api exception when the status code is not 200 or 201', () async {
      when(() => client.post(
            any(),
            body: any(named: 'body'),
            headers: any(named: 'headers'),
          )).thenAnswer((_) async => http.Response('User not created', 400));

      final methodCall = remoteDataSourceImpl.createUser;

      expect(
        () async => methodCall(avatar: 'avatar_url', createdAt: '2023-10-17', name: 'John Doe'),
        throwsA(const ApiException(message: 'User not created', statusCode: 400)),
      );
      verify(
        () => client.post(
          Uri.parse('$kBaseUrl$kCreateUserEndpoint'),
          body: jsonEncode({
            "createdAt": "2023-10-17",
            "name": "John Doe",
            "avatar": "avatar_url",
          }),
        ),
      ).called(1);
      verifyNoMoreInteractions(client);
    });

    group('getUsers', () {
      test('should return list users when status code is 200', () async {
        when(() => client.get(any())).thenAnswer((_) async => http.Response('[]', 200));

        final result = await remoteDataSourceImpl.getUsers();

        expect(result, equals([]));
        verify(() => client.get(Uri.parse('$kBaseUrl$kGetUsersEndpoint'))).called(1);
        verifyNoMoreInteractions(client);
      });

      test('should throw api exception when the status code is not 200', () async {
        when(() => client.get(any())).thenAnswer((_) async => http.Response('Failed to get users', 500));

        final methodCall = remoteDataSourceImpl.getUsers;

        expect(
          () async => methodCall(),
          throwsA(const ApiException(message: 'Failed to get users', statusCode: 500)),
        );
        verify(() => client.get(Uri.parse('$kBaseUrl$kGetUsersEndpoint'))).called(1);
        verifyNoMoreInteractions(client);
      });
    });
  });
}
