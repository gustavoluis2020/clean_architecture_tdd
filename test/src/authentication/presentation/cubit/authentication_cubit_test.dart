import 'package:bloc_test/bloc_test.dart';
import 'package:clean_architecture_tdd/core/errors/failure.dart';
import 'package:clean_architecture_tdd/src/authentication/domain/usecases/create_user.dart';
import 'package:clean_architecture_tdd/src/authentication/domain/usecases/get_users.dart';
import 'package:clean_architecture_tdd/src/authentication/presentation/cubit/authentication_cubit.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockGetUsers extends Mock implements GetUsers {}

class MockCreateUser extends Mock implements CreateUser {}

void main() {
  late GetUsers getUsers;
  late CreateUser createUser;
  late AuthenticationCubit cubit;

  const tCreateUserParams = CreateUserParams(
    createdAt: '2021-09-01',
    name: 'John Doe',
    avatar: 'https://example.com/avatar.jpg',
  );

  setUp(() {
    getUsers = MockGetUsers();
    createUser = MockCreateUser();
    cubit = AuthenticationCubit(
      createUser: createUser,
      getUsers: getUsers,
    );
    registerFallbackValue(tCreateUserParams);
  });

  tearDown(() => cubit.close());

  test('initial state should be authentication initial', () {
    expect(cubit.state, const AuthenticationInitial());
  });

  group('createUser', () {
    blocTest<AuthenticationCubit, AuthenticationState>('should emit creating user , user created when successful',
        build: () {
          when(() => createUser(tCreateUserParams)).thenAnswer(
            (_) async => const Right(null),
          );
          return cubit;
        },
        act: (cubit) => cubit.createUser(
              createdAt: '2021-09-01',
              name: 'John Doe',
              avatar: 'https://example.com/avatar.jpg',
            ),
        expect: () => const [CreatingUser(), UserCreated()],
        verify: (_) {
          verify(() => createUser(tCreateUserParams)).called(1);
          verifyNoMoreInteractions(createUser);
        });

    blocTest<AuthenticationCubit, AuthenticationState>(
      'should emit creating user , error when unsuccessful',
      build: () {
        when(() => createUser(tCreateUserParams)).thenAnswer(
          (_) async => const Left(ApiFailure(message: 'Server Error', statusCode: 500)),
        );
        return cubit;
      },
      act: (cubit) => cubit.createUser(
        createdAt: '2021-09-01',
        name: 'John Doe',
        avatar: 'https://example.com/avatar.jpg',
      ),
      expect: () => const [CreatingUser(), AuthenticationError('Server Error')],
      verify: (_) {
        verify(() => createUser(tCreateUserParams)).called(1);
        verifyNoMoreInteractions(createUser);
      },
    );
  });

  group('getUsers', () {
    blocTest<AuthenticationCubit, AuthenticationState>('should emit getting users , user loaded when successful',
        build: () {
          when(() => getUsers()).thenAnswer(
            (_) async => const Right([]),
          );
          return cubit;
        },
        act: (cubit) => cubit.getUsers(),
        expect: () => const [GettingUsers(), UsersLoaded([])],
        verify: (_) {
          verify(() => getUsers()).called(1);
          verifyNoMoreInteractions(getUsers);
        });

    blocTest<AuthenticationCubit, AuthenticationState>(
      'should emit getting users , error when unsuccessful',
      build: () {
        when(() => getUsers()).thenAnswer(
          (_) async => const Left(ApiFailure(message: 'Server Error', statusCode: 500)),
        );
        return cubit;
      },
      act: (cubit) => cubit.getUsers(),
      expect: () => const [GettingUsers(), AuthenticationError('Server Error')],
      verify: (_) {
        verify(() => getUsers()).called(1);
        verifyNoMoreInteractions(getUsers);
      },
    );
  });
}
