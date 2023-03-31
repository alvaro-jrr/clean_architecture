import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:clean_architecture/core/network/network_info.dart';

@GenerateNiceMocks([MockSpec<InternetConnectionChecker>()])
import 'network_info_test.mocks.dart';

void main() {
  late NetworkInfoImpl networkInfoImpl;
  late MockInternetConnectionChecker internetConnectionChecker;

  setUp(() {
    internetConnectionChecker = MockInternetConnectionChecker();
    networkInfoImpl = NetworkInfoImpl(internetConnectionChecker);
  });

  group('isConnected', () {
    test(
      'should forward the call to InternetConnectionChecker.hasConnection',
      () async {
        // arrange
        final tHasConnectionFuture = Future.value(true);

        when(internetConnectionChecker.hasConnection)
            .thenAnswer((_) => tHasConnectionFuture);

        // act
        final result = networkInfoImpl.isConnected;

        // assert
        verify(internetConnectionChecker.hasConnection);
        expect(result, tHasConnectionFuture);
      },
    );
  });
}
