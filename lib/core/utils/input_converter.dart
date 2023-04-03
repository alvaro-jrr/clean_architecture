import 'package:dartz/dartz.dart';

import 'package:clean_architecture/core/error/failures.dart';

class InputConverter {
  Either<Failure, int> stringToUnsignedInteger(String str) {
    final integer = int.tryParse(str);

    // In case is not an string representing an integer or negative
    if (integer == null || integer < 0) {
      return Left(InvalidInputFailure());
    }

    return Right(integer);
  }
}

class InvalidInputFailure extends Failure {
  @override
  List<Object> get props => [];
}
