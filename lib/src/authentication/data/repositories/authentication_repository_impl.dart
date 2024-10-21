import 'package:clean_architecture_tdd/core/errors/exceptions.dart';
import 'package:clean_architecture_tdd/core/errors/failure.dart';
import 'package:clean_architecture_tdd/core/type/type.dart';
import 'package:clean_architecture_tdd/src/authentication/data/data_sources/authentication_remote_data_source.dart';
import 'package:clean_architecture_tdd/src/authentication/domain/entities/user.dart';
import 'package:clean_architecture_tdd/src/authentication/domain/repositories/authentication_repository.dart';
import 'package:dartz/dartz.dart';

class AuthenticationRepositoryImpl implements AuthenticationRepository {
  const AuthenticationRepositoryImpl(this._remoteDataSource);

  final AuthenticationRemoteDataSource _remoteDataSource;

  @override
  ResultVoid createUser({
    required String createdAt,
    required String name,
    required String avatar,
  }) async {
    try {
      await _remoteDataSource.createUser(
        createdAt: createdAt,
        name: name,
        avatar: avatar,
      );

      return const Right(null);
    } on ApiException catch (e) {
      return Left(ApiFailure(message: e.message, statusCode: e.statusCode));
    }
  }

  @override
  ResultFuture<List<User>> getUsers() async {
    try {
      final result = await _remoteDataSource.getUsers();
      return Right(result);
    } on ApiException catch (e) {
      return Left(ApiFailure(message: e.message, statusCode: e.statusCode));
    }
  }
}
