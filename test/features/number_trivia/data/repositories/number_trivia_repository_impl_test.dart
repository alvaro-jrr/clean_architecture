import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';

import 'package:clean_architecture/core/error/exceptions.dart';
import 'package:clean_architecture/core/error/failures.dart';
import 'package:clean_architecture/core/platform/network_info.dart';
import 'package:clean_architecture/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:clean_architecture/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:clean_architecture/features/number_trivia/data/repositories/number_trivia_repository_impl.dart';
import 'package:clean_architecture/features/number_trivia/data/data_sources/number_trivia_local_data_source.dart';
import 'package:clean_architecture/features/number_trivia/data/data_sources/number_trivia_remote_data_source.dart';

@GenerateNiceMocks([
  MockSpec<NumberTriviaRemoteDataSource>(),
  MockSpec<NumberTriviaLocalDataSource>(),
  MockSpec<NetworkInfo>(),
])
import 'number_trivia_repository_impl_test.mocks.dart';

void main() {
  late NumberTriviaRepositoryImpl repository;
  late MockNumberTriviaRemoteDataSource remoteDataSource;
  late MockNumberTriviaLocalDataSource localDataSource;
  late MockNetworkInfo networkInfo;

  setUp(() {
    remoteDataSource = MockNumberTriviaRemoteDataSource();
    localDataSource = MockNumberTriviaLocalDataSource();
    networkInfo = MockNetworkInfo();

    repository = NumberTriviaRepositoryImpl(
      remoteDataSource: remoteDataSource,
      localDataSource: localDataSource,
      networkInfo: networkInfo,
    );
  });

  void runOnlineTests(Function body) {
    group('device is online', () {
      setUp(() {
        when(networkInfo.isConnected).thenAnswer((_) async => true);
      });

      body();
    });
  }

  void runOfflineTests(Function body) {
    group('device is offline', () {
      setUp(() {
        when(networkInfo.isConnected).thenAnswer((_) async => false);
      });

      body();
    });
  }

  group('getConcreteNumberTrivia', () {
    const tNumber = 1;
    const tNumberTriviaModel = NumberTriviaModel(
      text: 'Test Text',
      number: tNumber,
    );
    const NumberTrivia tNumberTrivia = tNumberTriviaModel;

    test(
      'should check if device is online',
      () async {
        // arrange
        when(networkInfo.isConnected).thenAnswer((_) async => true);

        // act
        repository.getConcreteNumberTrivia(tNumber);

        // assert
        verify(networkInfo.isConnected);
      },
    );

    runOnlineTests(() {
      test(
        'should return remote data when the call to remote data source is successful',
        () async {
          // arrange
          when(remoteDataSource.getConcreteNumberTrivia(any))
              .thenAnswer((_) async => tNumberTriviaModel);

          // act
          final result = await repository.getConcreteNumberTrivia(tNumber);

          // assert
          verify(remoteDataSource.getConcreteNumberTrivia(tNumber));
          expect(result, equals(const Right(tNumberTrivia)));
        },
      );

      test(
        'should cache the data locally when the call to remote data source is successful',
        () async {
          // arrange
          when(remoteDataSource.getConcreteNumberTrivia(any))
              .thenAnswer((_) async => tNumberTriviaModel);

          // act
          await repository.getConcreteNumberTrivia(tNumber);

          // assert
          verify(remoteDataSource.getConcreteNumberTrivia(tNumber));
          verify(localDataSource.cacheNumberTrivia(tNumberTriviaModel));
        },
      );

      test(
        'should return ServerFailure when the call to remote data source is unsuccessful',
        () async {
          // arrange
          when(remoteDataSource.getConcreteNumberTrivia(any))
              .thenThrow(ServerException());

          // act
          final result = await repository.getConcreteNumberTrivia(tNumber);

          // assert
          verify(remoteDataSource.getConcreteNumberTrivia(tNumber));
          verifyZeroInteractions(localDataSource);
          expect(result, equals(Left(ServerFailure())));
        },
      );
    });

    runOfflineTests(() {
      test(
        'should return last locally cached data when the cached data is present',
        () async {
          // arrange
          when(localDataSource.getLastNumberTrivia())
              .thenAnswer((_) async => tNumberTriviaModel);

          // act
          final result = await repository.getConcreteNumberTrivia(tNumber);

          // assert
          verify(localDataSource.getLastNumberTrivia());
          verifyZeroInteractions(remoteDataSource);
          expect(result, const Right(tNumberTrivia));
        },
      );

      test(
        'should return CacheFailure when the there is no cached data present',
        () async {
          // arrange
          when(localDataSource.getLastNumberTrivia())
              .thenThrow(CacheException());

          // act
          final result = await repository.getConcreteNumberTrivia(tNumber);

          // assert
          verify(localDataSource.getLastNumberTrivia());
          verifyZeroInteractions(remoteDataSource);
          expect(result, Left(CacheFailure()));
        },
      );
    });
  });

  group('getRandomNumberTrivia', () {
    const tNumberTriviaModel = NumberTriviaModel(
      text: 'Test Text',
      number: 123,
    );
    const NumberTrivia tNumberTrivia = tNumberTriviaModel;

    test(
      'should check if device is online',
      () async {
        // arrange
        when(networkInfo.isConnected).thenAnswer((_) async => true);

        // act
        repository.getRandomNumberTrivia();

        // assert
        verify(networkInfo.isConnected);
      },
    );

    runOnlineTests(() {
      test(
        'should return remote data when the call to remote data source is successful',
        () async {
          // arrange
          when(remoteDataSource.getRandomNumberTrivia())
              .thenAnswer((_) async => tNumberTriviaModel);

          // act
          final result = await repository.getRandomNumberTrivia();

          // assert
          verify(remoteDataSource.getRandomNumberTrivia());
          expect(result, equals(const Right(tNumberTrivia)));
        },
      );

      test(
        'should cache the data locally when the call to remote data source is successful',
        () async {
          // arrange
          when(remoteDataSource.getRandomNumberTrivia())
              .thenAnswer((_) async => tNumberTriviaModel);

          // act
          await repository.getRandomNumberTrivia();

          // assert
          verify(remoteDataSource.getRandomNumberTrivia());
          verify(localDataSource.cacheNumberTrivia(tNumberTriviaModel));
        },
      );

      test(
        'should return ServerFailure when the call to remote data source is unsuccessful',
        () async {
          // arrange
          when(remoteDataSource.getRandomNumberTrivia())
              .thenThrow(ServerException());

          // act
          final result = await repository.getRandomNumberTrivia();

          // assert
          verify(remoteDataSource.getRandomNumberTrivia());
          verifyZeroInteractions(localDataSource);
          expect(result, equals(Left(ServerFailure())));
        },
      );
    });

    runOfflineTests(() {
      test(
        'should return last locally cached data when the cached data is present',
        () async {
          // arrange
          when(localDataSource.getLastNumberTrivia())
              .thenAnswer((_) async => tNumberTriviaModel);

          // act
          final result = await repository.getRandomNumberTrivia();

          // assert
          verify(localDataSource.getLastNumberTrivia());
          verifyZeroInteractions(remoteDataSource);
          expect(result, const Right(tNumberTrivia));
        },
      );

      test(
        'should return CacheFailure when the there is no cached data present',
        () async {
          // arrange
          when(localDataSource.getLastNumberTrivia())
              .thenThrow(CacheException());

          // act
          final result = await repository.getRandomNumberTrivia();

          // assert
          verify(localDataSource.getLastNumberTrivia());
          verifyZeroInteractions(remoteDataSource);
          expect(result, Left(CacheFailure()));
        },
      );
    });
  });
}
