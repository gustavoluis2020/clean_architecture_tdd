import 'package:clean_architecture_tdd/core/type/type.dart';
import 'package:clean_architecture_tdd/core/usecase/usecase.dart';
import 'package:clean_architecture_tdd/src/authentication/domain/repositories/authentication_repository.dart';
import 'package:equatable/equatable.dart';

class CreateUser extends UseCaseWithParans<void, CreateUserParams> {
  CreateUser(this._repository);

  final AuthenticationRepository _repository;

  @override
  ResultVoid call(
    CreateUserParams parans,
  ) async =>
      _repository.createUser(
        createdAt: parans.createdAt,
        name: parans.name,
        avatar: parans.avatar,
      );
}

class CreateUserParams extends Equatable {
  const CreateUserParams({
    required this.createdAt,
    required this.name,
    required this.avatar,
  });

  final String createdAt;
  final String name;
  final String avatar;

  @override
  List<Object?> get props => [createdAt, name, avatar];
}
