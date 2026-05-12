import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:home_test_prudential/domain/auth/entities/login_entity.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:home_test_prudential/domain/auth/repositories/auth_repository.dart';
import 'package:home_test_prudential/domain/auth/usecases/login_usecase.dart';
import 'package:home_test_prudential/domain/core/errors/failures.dart';

@GenerateMocks([AuthRepository])
import 'login_usecase_test.mocks.dart';

void main() {
  late LoginUseCase loginUseCase;
  late MockAuthRepository mockAuthRepository;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    loginUseCase = LoginUseCase(mockAuthRepository);
  });

  final tParams = LoginParams(username: 'emilys', password: 'emilyspass');

  final tUser = LoginEntity(
    id: 1,
    username: 'username',
    email: 'email',
    firstName: 'firstName',
    lastName: 'lastName',
    gender: 'gender',
    image: 'image',
    accessToken: 'access-token',
    refreshToken: 'refresh-token',
  );

  group('LoginUseCase', () {
    test('should return UserEntity when login is successful', () async {
      // Arrange
      when(
        mockAuthRepository.login(any, any),
      ).thenAnswer((_) async => Right(tUser));

      // Act
      final result = await loginUseCase.execute(tParams);

      // Assert
      expect(result, Right(tUser));
      verify(mockAuthRepository.login(tParams.username, tParams.password));
      verifyNoMoreInteractions(mockAuthRepository);
    });

    test('should return ServerFailure when login fails', () async {
      // Arrange
      when(
        mockAuthRepository.login(any, any),
      ).thenAnswer((_) async => Left(ServerFailure('Invalid credentials')));

      // Act
      final result = await loginUseCase.execute(tParams);

      // Assert
      expect(result, isA<Left>());
      result.fold(
        (failure) => expect(failure.message, 'Invalid credentials'),
        (_) => fail('Expected Left but got Right'),
      );
      verify(mockAuthRepository.login(tParams.username, tParams.password));
      verifyNoMoreInteractions(mockAuthRepository);
    });
  });
}
