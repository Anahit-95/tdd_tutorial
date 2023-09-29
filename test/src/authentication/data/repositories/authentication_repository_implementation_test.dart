import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tdd_tutorial/core/errors/exceptions.dart';
import 'package:tdd_tutorial/core/errors/failure.dart';
import 'package:tdd_tutorial/src/authentication/data/datasources/authentication_remote_data_source.dart';
import 'package:tdd_tutorial/src/authentication/data/models/user_model.dart';
import 'package:tdd_tutorial/src/authentication/data/repositories/authentication_repository_implementation.dart';
import 'package:tdd_tutorial/src/authentication/domain/entities/user.dart';

class MockAuthRepmoteDataSrc extends Mock
    implements AuthenticationRemoteDataSource {}

void main() {
  late AuthenticationRemoteDataSource remoteDataSource;
  late AuthenticationRepositoryImplementation repoImpl;

  setUp(() {
    remoteDataSource = MockAuthRepmoteDataSrc();
    repoImpl = AuthenticationRepositoryImplementation(remoteDataSource);
  });

  const tException = APIException(
    message: 'Unknown error occured',
    statusCode: 500,
  );
  group('createUser', () {
    const createdAt = 'whatever.createdAt';
    const name = 'whatever.name';
    const avatar = 'whatever.avatar';

    test(
      '''should call the [RemotedataSource.createUser] 
        and complete successfully when 
        the call to remote source is successfull''',
      () async {
        // arrenge
        when(
          () => remoteDataSource.createUser(
            createdAt: any(named: 'createdAt'),
            name: any(named: 'name'),
            avatar: any(named: 'avatar'),
          ),
        ).thenAnswer((_) async => Future.value());

        // act
        final result = await repoImpl.createUser(
          createdAt: createdAt,
          name: name,
          avatar: avatar,
        );

        // assert
        expect(result, equals(const Right(null)));
        verify(
          () => remoteDataSource.createUser(
            createdAt: createdAt,
            name: name,
            avatar: avatar,
          ),
        ).called(1);
        verifyNoMoreInteractions(remoteDataSource);
      },
    );

    test(
      '''should return a [APIFailure] when the call to 
      the remote source is unsuccessfull''',
      () async {
        // Arrenge
        when(
          () => remoteDataSource.createUser(
            createdAt: any(named: 'createdAt'),
            name: any(named: 'name'),
            avatar: any(named: 'avatar'),
          ),
        ).thenThrow(tException);

        // Act
        final result = await repoImpl.createUser(
          createdAt: createdAt,
          name: name,
          avatar: avatar,
        );
        expect(
          result,
          equals(
            Left(APIFailure.fromException(tException)),
          ),
        );
        verify(
          () => remoteDataSource.createUser(
            createdAt: createdAt,
            name: name,
            avatar: avatar,
          ),
        ).called(1);
        verifyNoMoreInteractions(remoteDataSource);
      },
    );
  });

  group('getUsers', () {
    test(
      '''should call the [RemotedataSource.getUsers] 
        and return List<Users> when 
        the call to remote source is successfull''',
      () async {
        // arrenge
        when(
          () => remoteDataSource.getUsers(),
        ).thenAnswer((_) async => [UserModel.empty()]);

        // act
        final result = await repoImpl.getUsers();

        // assert
        expect(result, isA<Right<dynamic, List<User>>>());
        verify(
          () => remoteDataSource.getUsers(),
        ).called(1);
        verifyNoMoreInteractions(remoteDataSource);
      },
    );

    test(
      '''should return a [APIFailure] when the call to 
      the remote source is unsuccessfull''',
      () async {
        when(
          () => remoteDataSource.getUsers(),
        ).thenThrow(tException);
        final result = await repoImpl.getUsers();
        expect(
          result,
          equals(
            Left(APIFailure.fromException(tException)),
          ),
        );

        verify(
          () => remoteDataSource.getUsers(),
        ).called(1);
        verifyNoMoreInteractions(remoteDataSource);
      },
    );
  });
}
