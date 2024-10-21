import 'package:clean_architecture_tdd/core/type/type.dart';
import 'package:clean_architecture_tdd/core/usecase/usecase.dart';
import 'package:clean_architecture_tdd/src/authentication/domain/entities/user.dart';
import 'package:clean_architecture_tdd/src/authentication/domain/repositories/authentication_repository.dart';

class GetUsers extends UseCaseWithoutParans<List<User>> {
  const GetUsers(
    this._repository,
  );

  final AuthenticationRepository _repository;

  @override
  ResultFuture<List<User>> call() => _repository.getUsers();
}
