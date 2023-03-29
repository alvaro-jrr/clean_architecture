import 'package:dartz/dartz.dart';

import 'package:clean_architecture/core/error/failures.dart';

abstract class UseCase<ReturnType, ParamsType> {
  Future<Either<Failure, ReturnType>> call(ParamsType params);
}
