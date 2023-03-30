import 'package:dartz/dartz.dart';

import 'package:clean_architecture/core/error/exceptions.dart';
import 'package:clean_architecture/core/platform/network_info.dart';
import 'package:clean_architecture/features/number_trivia/data/data_sources/number_trivia_local_data_source.dart';
import 'package:clean_architecture/features/number_trivia/data/data_sources/number_trivia_remote_data_source.dart';
import 'package:clean_architecture/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:clean_architecture/core/error/failures.dart';
import 'package:clean_architecture/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:clean_architecture/features/number_trivia/domain/repositories/number_trivia_repository.dart';

typedef _ConcreteOrRandomChooser = Future<NumberTriviaModel> Function();

class NumberTriviaRepositoryImpl implements NumberTriviaRepository {
  final NumberTriviaRemoteDataSource remoteDataSource;
  final NumberTriviaLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  NumberTriviaRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, NumberTrivia>> getConcreteNumberTrivia(
    int number,
  ) async {
    return await _getTrivia(() {
      return remoteDataSource.getConcreteNumberTrivia(number);
    });
  }

  @override
  Future<Either<Failure, NumberTrivia>> getRandomNumberTrivia() async {
    return await _getTrivia(() => remoteDataSource.getRandomNumberTrivia());
  }

  Future<Either<Failure, NumberTrivia>> _getTrivia(
    _ConcreteOrRandomChooser getConcreteOrRandom,
  ) async {
    final isConnected = await networkInfo.isConnected;

    if (!isConnected) {
      try {
        final localTrivia = await localDataSource.getLastNumberTrivia();
        return Right(localTrivia);
      } on CacheException {
        return Left(CacheFailure());
      }
    }

    try {
      final remoteTrivia = await getConcreteOrRandom();
      await localDataSource.cacheNumberTrivia(remoteTrivia);
      return Right(remoteTrivia);
    } on ServerException {
      return Left(ServerFailure());
    }
  }
}
