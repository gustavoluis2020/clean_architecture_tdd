import 'package:clean_architecture_tdd/core/type/type.dart';
import 'package:clean_architecture_tdd/src/authentication/domain/entities/user.dart';

abstract class AuthenticationRepository {
  const AuthenticationRepository();

  ResultVoid createUser({
    required String createdAt,
    required String name,
    required String avatar,
  });

  ResultFuture<List<User>> getUsers();
}
