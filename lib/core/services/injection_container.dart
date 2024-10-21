import 'package:clean_architecture_tdd/src/authentication/data/data_sources/authentication_remote_data_source.dart';
import 'package:clean_architecture_tdd/src/authentication/data/data_sources/authentication_remote_data_source_impl.dart';
import 'package:clean_architecture_tdd/src/authentication/data/repositories/authentication_repository_impl.dart';
import 'package:clean_architecture_tdd/src/authentication/domain/repositories/authentication_repository.dart';
import 'package:clean_architecture_tdd/src/authentication/domain/usecases/create_user.dart';
import 'package:clean_architecture_tdd/src/authentication/domain/usecases/get_users.dart';
import 'package:clean_architecture_tdd/src/authentication/presentation/cubit/authentication_cubit.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;

final sl = GetIt.instance;

Future<void> init() async {
  sl
    //app logic
    ..registerFactory(() => AuthenticationCubit(
          createUser: sl(),
          getUsers: sl(),
        ))
    //usecases
    ..registerLazySingleton(() => CreateUser(sl()))
    ..registerLazySingleton(() => GetUsers(sl()))
    //repositories
    ..registerLazySingleton<AuthenticationRepository>(() => AuthenticationRepositoryImpl(sl()))
    //data sources
    ..registerLazySingleton<AuthenticationRemoteDataSource>(() => AuthenticationRemoteDataSourceImpl(sl()))
    //external
    ..registerLazySingleton(() => http.Client());
}
