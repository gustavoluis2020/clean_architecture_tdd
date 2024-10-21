import 'package:clean_architecture_tdd/core/type/type.dart';

abstract class UseCaseWithParans<Type, Params> {
  const UseCaseWithParans();

  ResultFuture<Type> call(Params parans);
}

abstract class UseCaseWithoutParans<Type> {
  const UseCaseWithoutParans();

  ResultFuture<Type> call();
}
