import 'package:clean_architecture_tdd/src/authentication/domain/repositories/authentication_repository.dart';
import 'package:clean_architecture_tdd/src/authentication/domain/usecases/create_user.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRepo extends Mock implements AuthenticationRepository {}

void main() {
  late CreateUser usecase;
  late AuthenticationRepository repository;

  setUp(() {
    repository = MockAuthRepo();
    usecase = CreateUser(repository);
  });

  test('should call the [AuthRepo.createUser]', () async {
    // arrange
    when(
      () => repository.createUser(
        createdAt: any(named: 'createdAt'),
        name: any(named: 'name'),
        avatar: any(named: 'avatar'),
      ),
    ).thenAnswer(
      (_) async => const Right(null),
    );

    // act
    final result = await usecase(
      const CreateUserParams(
        createdAt: 'createdAt',
        name: 'name',
        avatar: 'avatar',
      ),
    );

    // assert
    expect(result, equals(const Right<dynamic, void>(null)));
    verify(() => repository.createUser(
          createdAt: 'createdAt',
          name: 'name',
          avatar: 'avatar',
        ));
    verifyNoMoreInteractions(repository);
  });
}
