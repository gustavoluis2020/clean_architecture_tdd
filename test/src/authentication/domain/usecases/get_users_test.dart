import 'package:clean_architecture_tdd/src/authentication/domain/entities/user.dart';
import 'package:clean_architecture_tdd/src/authentication/domain/repositories/authentication_repository.dart';
import 'package:clean_architecture_tdd/src/authentication/domain/usecases/get_users.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRepo extends Mock implements AuthenticationRepository {}

void main() {
  late GetUsers usecase;
  late AuthenticationRepository repository;

  setUp(() {
    repository = MockAuthRepo();
    usecase = GetUsers(repository);
  });

  test('should call the [AuthRepo.getUsers] and return [List<User>]', () async {
    // arrange

    final mockUsers = [
      const User(
        id: '1',
        createdAt: '2023-10-17',
        name: 'John Doe',
        avatar: 'avatar_url',
      ),
    ];

    when(() => repository.getUsers()).thenAnswer((_) async => Right(mockUsers));
    // act
    final result = await usecase();
    // assert
    expect(
      result,
      equals(
        Right<dynamic, List<User>>(mockUsers),
      ),
    );
    verify(() => repository.getUsers());
    verifyNoMoreInteractions(repository);
  });
}
