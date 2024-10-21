import 'package:clean_architecture_tdd/core/errors/exceptions.dart';
import 'package:clean_architecture_tdd/core/errors/failure.dart';
import 'package:clean_architecture_tdd/src/authentication/data/data_sources/authentication_remote_data_source.dart';
import 'package:clean_architecture_tdd/src/authentication/data/repositories/authentication_repository_impl.dart';
import 'package:clean_architecture_tdd/src/authentication/domain/entities/user.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRemoteDataSource extends Mock implements AuthenticationRemoteDataSource {}

void main() {
  late AuthenticationRemoteDataSource remoteDataSource;
  late AuthenticationRepositoryImpl repositoryImpl;

  setUp(() {
    remoteDataSource = MockAuthRemoteDataSource();
    repositoryImpl = AuthenticationRepositoryImpl(remoteDataSource);
  });

  group('should call the remote data source', () {
    test('createUser', () async {
      when(() => remoteDataSource.createUser(
            createdAt: any(named: 'createdAt'),
            name: any(named: 'name'),
            avatar: any(named: 'avatar'),
          )).thenAnswer(
        (_) async => Future.value(),
      );

      final result = await repositoryImpl.createUser(
        createdAt: 'createdAt',
        name: 'name',
        avatar: 'avatar',
      );

      expect(result, equals(const Right(null)));

      verify(() => remoteDataSource.createUser(
            createdAt: 'createdAt',
            name: 'name',
            avatar: 'avatar',
          )).called(1);
      verifyNoMoreInteractions(remoteDataSource);
    });

    test('should return a Failure', () async {
      //arrange
      when(
        () => remoteDataSource.createUser(
          createdAt: any(named: 'createdAt'),
          name: any(named: 'name'),
          avatar: any(
            named: 'avatar',
          ),
        ),
      ).thenThrow(
        const ApiException(message: 'Server Error', statusCode: 500),
      );
      //act
      final result = await repositoryImpl.createUser(
        createdAt: 'createdAt',
        name: 'name',
        avatar: 'avatar',
      );
      //assert
      expect(
        result,
        equals(
          const Left(
            ApiFailure(message: 'Server Error', statusCode: 500),
          ),
        ),
      );
      verify(() => remoteDataSource.createUser(
            createdAt: 'createdAt',
            name: 'name',
            avatar: 'avatar',
          )).called(1);
      verifyNoMoreInteractions(remoteDataSource);
    });
  });

  group('GET USERS', () {
    test('should call the remote data source get users and return list users', () async {
      when(() => remoteDataSource.getUsers()).thenAnswer((_) async => ([]));

      final result = await repositoryImpl.getUsers();

      expect(result, isA<Right<dynamic, List<User>>>());

      verify(() => remoteDataSource.getUsers()).called(1);
      verifyNoMoreInteractions(remoteDataSource);
    });

    test('should return a api failure', () async {
      //arrange
      when(() => remoteDataSource.getUsers()).thenThrow(const ApiException(message: 'Server Error', statusCode: 500));
      //act
      final result = await repositoryImpl.getUsers();
      //assert
      expect(
        result,
        equals(
          const Left(
            ApiFailure(message: 'Server Error', statusCode: 500),
          ),
        ),
      );
      verify(() => remoteDataSource.getUsers()).called(1);
      verifyNoMoreInteractions(remoteDataSource);
    });
  });
}
